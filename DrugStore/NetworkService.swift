import UIKit

enum Constants {
    static let getDrugURL: String = "http://shans.d2.i-partner.ru/api/ppp/item/?id="
    static let getDrugsURL: String = "http://shans.d2.i-partner.ru/api/ppp/index/"
}

protocol NetworkServiceProtocol {
    func fetchDrug(id: Int, completion: @escaping(Result<DrugModel, Error>) -> Void)
    func fetchDrugs(completion: @escaping(Result<[DrugModel], Error>) -> Void)
}

final class NetworkService:NetworkServiceProtocol {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchDrug(id: Int, completion: @escaping(Result<DrugModel, Error>) -> Void) {
        getDrug(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(drugs):
                    completion(.success(drugs))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchDrugs(completion: @escaping(Result<[DrugModel], Error>) -> Void) {
        getDrugs { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(drugs):
                    completion(.success(drugs))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func getDrug(id: Int, completion: @escaping (Result<DrugModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: URL(string:Constants.getDrugURL + "\(id)"), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: DrugModel.self, onResponse: completion)
    }
    
    private func getDrugs(completion: @escaping (Result<[DrugModel], Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: URL(string:Constants.getDrugsURL), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: [DrugModel].self, onResponse: completion)
    }
}
