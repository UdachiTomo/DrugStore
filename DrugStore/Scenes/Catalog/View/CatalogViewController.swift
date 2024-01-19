import UIKit

final class CatalogViewController: UIViewController {
    private var viewModel: CatalogViewModelProtocol
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    init(viewModel: CatalogViewModelProtocol = CatalogViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchController()
        drugsCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        applyConstraints()
        bind()
    }
    
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var drugsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 164, height: 225)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: CatalogCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private func bind() {
        viewModel.drugsObservable.bind { [weak self] _ in
            guard let self else { return }
            drugsCollectionView.reloadData()
        }
    }
    
    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func addView() {
        [drugsCollectionView].forEach(view.setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            drugsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            drugsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            drugsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            drugsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.filtredDrugs.count
        }
        return viewModel.drugs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCollectionViewCell.identifier, for: indexPath) as? CatalogCollectionViewCell else { return UICollectionViewCell() }
        if isFiltering {
            viewModel.newModelDrugs = viewModel.filtredDrugs[indexPath.row]
        } else {
            viewModel.newModelDrugs = viewModel.drugs[indexPath.row]
        }
        if let model = viewModel.newModelDrugs {
            cell.configureCells(model: model)
            cell.layer.cornerRadius = 8.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.layer.shadowColor = UIColor(red: 0.282, green: 0.298, blue: 0.298, alpha: 0.15).cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            cell.layer.shadowRadius = 4.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds,
                                                 cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering {
            viewModel.newModelDrugs = viewModel.filtredDrugs[indexPath.row]
        } else {
            viewModel.newModelDrugs = viewModel.drugs[indexPath.row]
        }
        if let id = viewModel.newModelDrugs?.id {
            let vc = DrugViewController(viewModel: DrugViewModel(id: id))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension CatalogViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        viewModel.filtredDrugs = viewModel.drugs.filter({ (drug: DrugModel) -> Bool in
            return drug.name.lowercased().contains(searchText.lowercased())
        })
        drugsCollectionView.reloadData()
    }
}
