import UIKit
import Kingfisher

final class CatalogCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DrugCollectionViewCell"
    private var drugModel: DrugModel?
    private var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return drugImage.kf.cancelDownloadTask()
            }
            drugImage.kf.setImage(with: URL(string: "http://shans.d2.i-partner.ru/\(url)") )
        }
    }
    
    private lazy var collectionView: UIView = {
        let collectionView = UIView()
        return collectionView
    }()
    
    private lazy var drugImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockImageDrug")
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleDrug: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.text = "Болезни зерновых культур"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Системный инсектицид широкого спектра активности с продолжительным периодом действия препарат в процессе регистрации"
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        addConstraints()
        addSubview()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func addSubview() {
        contentView.addSubview(collectionView)
        collectionView.addSubview(drugImage)
        collectionView.addSubview(titleDrug)
        collectionView.addSubview(descriptionLabel)
    }
    private func addView() {
        
        [collectionView, drugImage, titleDrug, descriptionLabel].forEach(setupView(_:))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            drugImage.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 12),
            drugImage.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -12),
            drugImage.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 12),
            drugImage.heightAnchor.constraint(equalTo: collectionView.heightAnchor, multiplier: 0.3),
            titleDrug.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 12),
            titleDrug.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -12),
            titleDrug.topAnchor.constraint(equalTo: drugImage.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -12),
            descriptionLabel.topAnchor.constraint(equalTo: titleDrug.bottomAnchor, constant: 6),
            descriptionLabel.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -12)
        ])
    }
    
    func configureCells(model: DrugModel) {
        drugModel = model
        titleDrug.text = model.name
        descriptionLabel.text = model.description
        imageURL = model.categories.image
    }
    
}

