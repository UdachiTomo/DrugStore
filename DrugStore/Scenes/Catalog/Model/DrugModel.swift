import UIKit

// MARK: - DrugModel
struct DrugModel: Codable {
    let id: Int
    let image: URL
    let categories: Categories
    let name, description: String
}

// MARK: - Categories
struct Categories: Codable {
    let id: Int
    let icon, image: URL
    let name: String
}

