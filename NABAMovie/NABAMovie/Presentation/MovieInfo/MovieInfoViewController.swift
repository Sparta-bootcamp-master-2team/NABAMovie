//
//  MovieInfoViewController.swift
//  NABAMovie
//
//  Created by 정근호 on 4/28/25.
//

import UIKit
import SnapKit

class MovieInfoViewController: UIViewController {
    
    private let viewModel = MovieInfoViewModel()
    
    private enum StillCutSection {
        case main
    }
    
    private struct StillCutItem: Hashable {
        let id = UUID()
        let image: UIImage
    }
    
    private var stillCutDataSource: UICollectionViewDiffableDataSource<StillCutSection, StillCutItem>!
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let darkOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let ratingLabelAndImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private let ratingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let ratingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.8"
        label.largeContentImage = UIImage(systemName: "star.fill")
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let ageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let ageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관련등급"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let ratingAndAgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.alignment = .center
        return stackView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24)
        button.setImage(UIImage(systemName: "heart")?.withConfiguration(largeConfig), for: .normal)
        button.tintColor = UIColor(named: "brandColor")
        button.addTarget(self, action: #selector(addFavorite(_:)), for: .touchUpInside)
        return button
    }()
    
    private let directorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "감독"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let castTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "출연"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let castLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "줄거리"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let stillCutTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "스틸컷"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let stillCutCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 120, height: 180)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let reserveButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(named: "brandColor")
        button.addTarget(self, action: #selector(transitToBookingPage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        viewModel.configure { [weak self] in
            self?.updateStillCutCollectionView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reserveButton.layer.cornerRadius = reserveButton.frame.height / 2
    }
    
    
    
    // MARK: - UI & Layout
    private func setupUI() {
        navigationItem.title = "상세 정보"
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        containerView.addSubview(scrollView)
        containerView.addSubview(reserveButton)
        scrollView.addSubview(contentView)
        
        [
            imageContainerView,
            ratingAndAgeStackView,
            favoriteButton,
            directorTitleLabel,
            directorLabel,
            castTitleLabel,
            castLabel,
            descriptionTitleLabel,
            descriptionLabel,
            stillCutTitleLabel,
            stillCutCollectionView
        ].forEach { contentView.addSubview($0) }
        
        ratingAndAgeStackView.addArrangedSubview(ratingStackView)
        ratingAndAgeStackView.addArrangedSubview(ageStackView)
        
        [
            posterImageView,
            darkOverlayView,
            titleLabel,
            infoLabel
        ].forEach { imageContainerView.addSubview($0) }
        
        ratingStackView.addArrangedSubview(ratingLabelAndImageStackView)
        ratingStackView.addArrangedSubview(ratingTitleLabel)
        
        ratingLabelAndImageStackView.addArrangedSubview(ratingImage)
        ratingLabelAndImageStackView.addArrangedSubview(ratingLabel)
        
        ageStackView.addArrangedSubview(ageLabel)
        ageStackView.addArrangedSubview(ageTitleLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        reserveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(reserveButton.snp.top).offset(-8)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.bottom.equalTo(scrollView)
        }
        
        imageContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageContainerView.snp.width).multipliedBy(2.0 / 3.0)
        }
        
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        darkOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(infoLabel.snp.top).offset(-8)
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        ratingAndAgeStackView.snp.makeConstraints {
            $0.top.equalTo(imageContainerView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalTo(ratingLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        directorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(ratingAndAgeStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(directorTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        castTitleLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        castLabel.snp.makeConstraints {
            $0.top.equalTo(castTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        descriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(castLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        stillCutTitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        stillCutCollectionView.snp.makeConstraints {
            $0.top.equalTo(stillCutTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        setupStillCutCollectionView()
    }
    
    private func setupStillCutCollectionView() {
        stillCutCollectionView.register(StillCutCell.self, forCellWithReuseIdentifier: StillCutCell.reuseIdentifier)
        
        stillCutDataSource = UICollectionViewDiffableDataSource<StillCutSection, StillCutItem>(collectionView: stillCutCollectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StillCutCell.reuseIdentifier, for: indexPath) as? StillCutCell else {
                return UICollectionViewCell()
            }
            cell.imageView.image = item.image
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<StillCutSection, StillCutItem>()
        snapshot.appendSections([.main])
        let items = viewModel.stillImages.map { StillCutItem(image: $0) }
        snapshot.appendItems(items)
        stillCutDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private class StillCutCell: UICollectionViewCell {
        static let reuseIdentifier = "StillCutCell"
        
        let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: - Action
    @objc func addFavorite(_ sender: UIButton) {
        viewModel.isFavorite.toggle()
        let imageName = viewModel.isFavorite ? "heart.fill" : "heart"
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24)
        favoriteButton.setImage(UIImage(systemName: imageName)?.withConfiguration(largeConfig), for: .normal)
        print("Favorite status: \(viewModel.isFavorite)")
    }
    
    @objc func transitToBookingPage() {
        print(#function)
    }
    
    // MARK: - Private Methods
    private func updateStillCutCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<StillCutSection, StillCutItem>()
        snapshot.appendSections([.main])
        let items = viewModel.stillImages.map { StillCutItem(image: $0) }
        snapshot.appendItems(items)
        stillCutDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Internal Methods
    func configure() {
        titleLabel.text = viewModel.title
        posterImageView.image = viewModel.movieImage
        infoLabel.text = viewModel.info
        ratingLabel.text = "\(viewModel.rating)"
        ageLabel.text = "\(viewModel.age)세"
        directorLabel.text = viewModel.director
        castLabel.text = viewModel.cast
        descriptionLabel.text = viewModel.description
    }
}
