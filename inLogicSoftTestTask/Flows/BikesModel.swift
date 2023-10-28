import Foundation
import Combine
import CoreLocation

protocol BikesNavigationHandler {}

final class BikesModel {
    
    private let navigationHandler: BikesNavigationHandler
    
    let requestState = CurrentValueSubject<RequestState, Never>(.finished)
    let reloadInfoData = PassthroughSubject<Void, Never>()
    var stations = [Stations]()
    
    init(navigationHandler: BikesNavigationHandler) {
        self.navigationHandler = navigationHandler
        
        fetchData()
    }
    
    private func fetchData() {
        let url = "https://api.citybik.es/v2/networks/wienmobil-rad"
        let urls = URL(string: url)
        
        URLSession.shared.dataTask(with: urls!) { (data, response, error) in
            guard let data = data else { return }
            
            Task {
                do {
                    let decoder = JSONDecoder()
                    let citiesInfos = try decoder.decode(BikesAPI.self, from: data)
                    
                    DispatchQueue.main.async { [self] in
                        
                        let sorted = citiesInfos.network.stations.sorted(by: {$0.name < $1.name})
                        self.stations.append(contentsOf: sorted)
                        reloadInfoData.send(())
                        requestState.send(.finished)
                    }
                } catch {
                    self.requestState.send(.failed(error))
                    print("Error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
}
