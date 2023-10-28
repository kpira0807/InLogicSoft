import Foundation
import UIKit
import Combine

final class BikesViewModel {
    
    var requestState: AnyPublisher<RequestState, Never> {
        model.requestState.eraseToAnyPublisher()
    }
    
    var reloadInfoData: AnyPublisher<Void, Never> {
        _reloadInfoData.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var cellViewModels: [BikesCellViewModel] = []
    
    private let model: BikesModel
    private let _reloadInfoData = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init(model: BikesModel) {
        self.model = model
        
        setupBindings()
    }
    
    private func setupBindings() {
        model.reloadInfoData.sink { [weak self] _ in
            guard let self = self else { return }
            
            self.buildCellViewModels()
            self._reloadInfoData.send(())
        }.store(in: &subscriptions)
    }
    
    private func buildCellViewModels() {
        cellViewModels = model.stations.map { value in
            BikesCellViewModel(
                title: value.name,
                emptySlots: value.emptySlots ?? 0,
                freeBikes: value.freeBikes ?? 0,
                latitude: value.latitude ?? 48.210033,
                longitude: value.longitude ?? 16.363449
            )
        }
    }
    
}
