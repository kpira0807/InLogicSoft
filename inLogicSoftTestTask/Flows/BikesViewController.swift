import Foundation
import UIKit
import SnapKit
import Combine
import CoreLocation

final class BikesViewController: NiblessViewController, CLLocationManagerDelegate {
    
    var filteredArticles: [BikesCellViewModel] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var coordination: CLLocation?
    let locationManager = CLLocationManager()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BikesCell.self, forCellReuseIdentifier: BikesCell.identifier)
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = L10n.NavigationBar.Search.title
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        
        return searchController
    }()
    
    private let viewModel: BikesViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: BikesViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Asset.titleColor.color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Asset.titleColor.color]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Asset.titleColor.color, .font: UIFont.boldSystemFont(ofSize: 20.0)] 
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = L10n.NavigationBar.title
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        view.backgroundColor = .white
        
        activityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(activityIndicator)
        
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setuplocation()
    }
    
    func setuplocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, coordination == nil {
            coordination = locations.first
            locationManager.stopUpdatingLocation()
            setupBindings()
        }
    }
    
    
    @objc private func refresh(sender: UIRefreshControl) {
        setupBindings()
        sender.endRefreshing()
    }
    
    private func setupBindings() {
        activityIndicator.startAnimating()
        viewModel.reloadInfoData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.setupViews()
                self?.tableView.reloadData()
                
                let valueDefault = CLLocation(latitude: 48.210033, longitude: 16.363449)
                
                if self?.coordination != nil {
                    let sort = self?.viewModel.cellViewModels.sorted(by: {$0.coordination.distance(from: self?.coordination ?? valueDefault) > $1.coordination.distance(from: self?.coordination ?? valueDefault)})
                    self?.viewModel.cellViewModels.removeAll()
                    self?.viewModel.cellViewModels.append(contentsOf: sort!)
                    self?.tableView.reloadData()
                }
                
                self?.activityIndicator.stopAnimating()
            }.store(in: &subscriptions)
    }
    
}

extension BikesViewController {
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        tableView.accessibilityIdentifier = "tableView"
        tableView.snp.makeConstraints { make in
            make.top.equalTo((navigationController?.navigationBar.snp.bottom)!)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let info = viewModel.cellViewModels
        filteredArticles = info.filter({(bikes: BikesCellViewModel) -> Bool in
            return bikes.title.contains(searchText) || bikes.emptySlots.contains(searchText) || bikes.freeBikes.description.contains(searchText)        })
        tableView.reloadData()
    }
    
}

extension BikesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredArticles.count
        }
        
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var viewModels: BikesCellViewModel
        if isFiltering {
            viewModels = filteredArticles[indexPath.row]
        } else {
            viewModels = viewModel.cellViewModels[indexPath.row]
        }
        
        let cell: BikesCell = tableView.dequeueReusableCell(withIdentifier: BikesCell.identifier, for: indexPath) as! BikesCell
        cell.setup(viewModels)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension BikesViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("performDropWith")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: "http://maps.apple.com/?ll=\(Double()),\(Double())")
        let viewModels: BikesCellViewModel
        
        if isFiltering {
            viewModels = filteredArticles[indexPath.row]
            let url = URL(string: "http://maps.apple.com/?ll=\(viewModels.latitude),\(viewModels.longitude)")
            UIApplication.shared.open(url!)
        } else {
            viewModels = viewModel.cellViewModels[indexPath.row]
            let url = URL(string: "http://maps.apple.com/?ll=\(viewModels.latitude),\(viewModels.longitude)")
            UIApplication.shared.open(url!)
        }
    }
    
}

extension BikesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}
