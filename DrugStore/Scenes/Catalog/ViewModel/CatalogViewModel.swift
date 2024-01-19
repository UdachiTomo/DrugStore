import UIKit

protocol CatalogViewModelProtocol {
    var drugs: [DrugModel] { get }
    var drugsObservable: Observable<[DrugModel]> { get }
    var filtredDrugs: [DrugModel] {get set}
    var newModelDrugs: DrugModel? {get set}
}

final class CatalogViewModel: CatalogViewModelProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    @Observable
    private (set) var drugs: [DrugModel] = []
    
    var filtredDrugs: [DrugModel] = []
    var newModelDrugs: DrugModel?
    var drugsObservable: Observable<[DrugModel]> { $drugs }
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        getDrugsCatalog()
    }
    
    private func getDrugsCatalog() {
        networkService.fetchDrugs { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(drugs):
                    self.drugs = drugs
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
