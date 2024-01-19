import UIKit

protocol DrugViewModelProtocol {
    var id: Int { get }
    var drug: DrugModel? { get }
    var drugObservable: Observable<DrugModel?> { get }
}

final class DrugViewModel: DrugViewModelProtocol {
    private let networkService: NetworkServiceProtocol
    var id: Int
    @Observable
    private (set) var drug: DrugModel?
    
    var drugObservable: Observable<DrugModel?> { $drug }
    
    private func getDrug(){
        networkService.fetchDrug(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(drugs):
                        
                        self.drug = drugs
                    case let .failure(error):
                        print(error)
                    }
                }
            }
    }
    init(networkService: NetworkServiceProtocol = NetworkService(), id: Int) {
        self.id = id
        self.networkService = networkService
        getDrug()
    }
}
