import UIKit
import Kingfisher

final class DrugViewController: UIViewController {
    private var viewModel: DrugViewModelProtocol
    private var drugURL: URL? {
        didSet {
            guard let url = drugURL else {
                return imageDrug.kf.cancelDownloadTask()
            }

            imageDrug.kf.setImage(with: URL(string: "http://shans.d2.i-partner.ru/\(url)"))
        }
    }
    
    private var leftIconURL: URL? {
        didSet {
            guard let url = leftIconURL else {
                return leftIcon.kf.cancelDownloadTask()
            }

            leftIcon.kf.setImage(with: URL(string: "http://shans.d2.i-partner.ru/\(url)"))
        }
    }
    
    init(viewModel: DrugViewModelProtocol = DrugViewModel(id: Int())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .systemBackground
        addView()
        applyConstraints()
        bind()
    }
    
    private lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageDrug: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nameDrug: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Где купить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.937, green: 0.937, blue: 0.941, alpha: 1).cgColor
        button.setImage(UIImage(named: "map_pin"), for: .normal)
        return button
    }()
    
    private lazy var leftIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var addFavorites: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star"), for: .normal)
        button.addTarget(self, action: #selector(method), for: .touchUpInside)
        return button
    }()
    
    private func addView() {
        [imageDrug, mainView, nameDrug, leftIcon, addFavorites, descriptionLabel, buyButton].forEach(view.setupView(_:))
        mainView.addSubview(imageDrug)
        mainView.addSubview(leftIcon)
        mainView.addSubview(addFavorites)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            imageDrug.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 90),
            imageDrug.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -90),
            imageDrug.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            imageDrug.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),
            leftIcon.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            leftIcon.topAnchor.constraint(equalTo: imageDrug.topAnchor),
            leftIcon.heightAnchor.constraint(equalToConstant: 32),
            leftIcon.widthAnchor.constraint(equalToConstant: 32),
            addFavorites.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            addFavorites.topAnchor.constraint(equalTo: imageDrug.topAnchor),
            addFavorites.heightAnchor.constraint(equalToConstant: 32),
            addFavorites.widthAnchor.constraint(equalToConstant: 32),
            nameDrug.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            nameDrug.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameDrug.bottomAnchor, constant: 8),
            buyButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            buyButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            buyButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            buyButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func bind() {
        viewModel.drugObservable.bind { [weak self] _ in
            guard let self else { return }
            setupUI()
        }
    }
    
    private func setupUI() {
        drugURL = viewModel.drug?.image
        leftIconURL = viewModel.drug?.categories.icon
        nameDrug.text = viewModel.drug?.name
        descriptionLabel.text = viewModel.drug?.description
    }
}
