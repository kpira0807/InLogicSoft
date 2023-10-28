import Foundation
import UIKit
import SnapKit

final class BikesCell: UITableViewCell {
    
    static let identifier = "BikesCell"
    
    private let backView = UIView()
    private let titleLabel = UILabel()
    private let emptySlotsLabel = UILabel()
    private let freeBikesLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ viewModel: BikesCellViewModel) {
        titleLabel.text = viewModel.title
        emptySlotsLabel.text = viewModel.emptySlots
        freeBikesLabel.text = viewModel.freeBikes
    }
    
}

extension BikesCell {
    
    private func setupView() {
        addSubview(backView)
        backView.accessibilityIdentifier = "backView"
        backView.layer.cornerRadius = 8.0
        backView.layer.borderWidth = 2.0
        backView.layer.borderColor = Asset.borderColor.color.cgColor
        backView.backgroundColor = Asset.backgroundColor.color
        backView.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
        }
        
        backView.addSubview(titleLabel)
        titleLabel.accessibilityIdentifier = "titleLabel"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = Asset.titleColor.color
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
        }
        
        backView.addSubview(emptySlotsLabel)
        emptySlotsLabel.accessibilityIdentifier = "emptySlotsLabel"
        emptySlotsLabel.numberOfLines = 0
        emptySlotsLabel.textAlignment = .left
        emptySlotsLabel.textColor = Asset.textColor.color
        emptySlotsLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        emptySlotsLabel.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
        }
        
        backView.addSubview(freeBikesLabel)
        freeBikesLabel.accessibilityIdentifier = "freeBikesLabel"
        freeBikesLabel.numberOfLines = 0
        freeBikesLabel.textAlignment = .left
        freeBikesLabel.textColor = Asset.textColor.color
        freeBikesLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        freeBikesLabel.snp.makeConstraints{make in
            make.top.equalTo(emptySlotsLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }
    
}
