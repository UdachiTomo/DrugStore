import UIKit

final class TabBarViewController: UITabBarController {

    private func generateTabBar() {
        viewControllers = [
            generateVC(viewController: CatalogViewController(), title: "", image: UIImage(systemName: ""))
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
}
