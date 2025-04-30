//
//  MovieInfoViewController.swift
//  NABAMovie
//
//  Created by 정근호 on 4/28/25.
//

import UIKit
import SnapKit
import Kingfisher

class MovieInfoViewController: UIViewController {
    
    var viewModel: MovieInfoViewModel
    
    var stillCutDataSource: UICollectionViewDiffableDataSource<StillCutSection, StillCutItem>!
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
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
    
    private let voteAverageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let voteAverageLabelAndImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private let voteAverageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let voteAverageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.text = "4.8"
        label.largeContentImage = UIImage(systemName: "star.fill")
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let certificationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let certificationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관람등급"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let certificationLabel: UILabel = {
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
    
    private let overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "줄거리"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let overviewLabel: UILabel = {
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
    
    // 스틸컷 콜렉션 뷰
    let stillCutCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 210, height: 140)
        
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
    init(viewModel: MovieInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        viewModel.setStillImages { [weak self] in
            self?.updateStillCutCollectionView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        reserveButton.layer.cornerRadius =  reserveButton.frame.height / 2
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
            overviewTitleLabel,
            overviewLabel,
            stillCutTitleLabel,
            stillCutCollectionView
        ].forEach { contentView.addSubview($0) }
        
        ratingAndAgeStackView.addArrangedSubview(voteAverageStackView)
        ratingAndAgeStackView.addArrangedSubview(certificationStackView)
        
        [
            posterImageView,
            darkOverlayView,
            titleLabel,
            infoLabel
        ].forEach { imageContainerView.addSubview($0) }
        
        voteAverageStackView.addArrangedSubview(voteAverageLabelAndImageStackView)
        voteAverageStackView.addArrangedSubview(voteAverageTitleLabel)
        
        voteAverageLabelAndImageStackView.addArrangedSubview(voteAverageImage)
        voteAverageLabelAndImageStackView.addArrangedSubview(voteAverageLabel)
        
        certificationStackView.addArrangedSubview(certificationLabel)
        certificationStackView.addArrangedSubview(certificationTitleLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        reserveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(reserveButton.snp.top).offset(-24)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
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
            $0.centerY.equalTo(voteAverageLabel)
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
        
        overviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(castLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(overviewTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        stillCutTitleLabel.snp.makeConstraints {
            $0.top.equalTo(overviewLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        stillCutCollectionView.snp.makeConstraints {
            $0.top.equalTo(stillCutTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(140)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        setupStillCutCollectionView()
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
        let bottomSheet = BookingPageViewController(viewModel: BookingPageViewModel(movieDetail: viewModel.movieDetail))
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.9
            })]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        
        present(bottomSheet, animated: true)
    }
    
    // MARK: - Internal Methods
    func configure() {
        titleLabel.text = viewModel.titleText
        if let posterURL = viewModel.posterURL {
            posterImageView.kf.setImage(with: posterURL)
        }
        infoLabel.text = viewModel.infoText
        voteAverageLabel.text = viewModel.voteAverageText
        certificationLabel.text = viewModel.certificationText
        directorLabel.text = viewModel.directorText
        castLabel.text = viewModel.castText
        overviewLabel.text = viewModel.overviewText
    }
}
