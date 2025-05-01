//
//  MovieInfoViewController.swift
//  NABAMovie
//
//  Created by 정근호 on 4/28/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieInfoViewController: UIViewController {
    
    private weak var coordinator: MovieInfoCoordinatorProtocol?
    
    var viewModel: MovieInfoViewModel
    
    var stillCutDataSource: UICollectionViewDiffableDataSource<StillCutSection, StillCutItem>!
    
    private let heightMargin: CGFloat = 40
    private let dividerInset: CGFloat = 15
    
    private let collectionViewHeight: CGFloat = 200
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var firstImageContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var firstStillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var darkOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var voteAverageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var voteAverageLabelAndImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var voteAverageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var voteAverageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.largeContentImage = UIImage(systemName: "star.fill")
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var certificationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var certificationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관람등급"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var certificationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var ratingAndAgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        button.setImage(UIImage(systemName: "heart")?.withConfiguration(config), for: .normal)
        button.tintColor = UIColor(named: "brandColor")
        button.addTarget(self, action: #selector(favoriteButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var directorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "감독"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var directorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var castTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "출연"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var castLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "줄거리"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stillCutTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "스틸컷"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    // 스틸컷 콜렉션 뷰
    lazy var stillCutCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let stillCutHeight = collectionViewHeight - 20
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: stillCutHeight * 3/2, height: stillCutHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        return collectionView
    }()
    
    private lazy var reserveButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(named: "brandColor")
        button.addTarget(self, action: #selector(transitToBookingPage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Dividers
    private lazy var ratingDivider = Divider()
    
    private lazy var directorDivider = Divider()
    
    private lazy var castDivider = Divider()
    
    private lazy var overviewDivider = Divider()
    
    private lazy var shadowDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.layer.shadowRadius = 2
        return view
    }()
    
    // MARK: - Initializers
    init(viewModel: MovieInfoViewModel, coordinator: MovieInfoCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) // 뷰 컨트롤러가 나타날 때 숨기기
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        reserveButton.layer.cornerRadius =  reserveButton.frame.height / 2
    }
    
    // MARK: - UI & Layout
    private func setupUI() {
        navigationItem.title = "상세 정보"
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        view.addSubview(shadowDivider)
        
        containerView.addSubview(scrollView)
        containerView.addSubview(reserveButton)
        
        scrollView.addSubview(contentView)
        
        [
            firstImageContainerView,
            ratingAndAgeStackView,
            favoriteButton,
            directorTitleLabel,
            directorLabel,
            castTitleLabel,
            castLabel,
            overviewTitleLabel,
            overviewLabel,
            stillCutTitleLabel,
            stillCutCollectionView,
            ratingDivider,
            directorDivider,
            castDivider,
            overviewDivider
        ].forEach { contentView.addSubview($0) }
        
        ratingAndAgeStackView.addArrangedSubview(voteAverageStackView)
        ratingAndAgeStackView.addArrangedSubview(certificationStackView)
        
        [
            firstStillImageView,
            darkOverlayView,
            titleLabel,
            infoLabel
        ].forEach { firstImageContainerView.addSubview($0) }
        
        voteAverageStackView.addArrangedSubview(voteAverageLabelAndImageStackView)
        voteAverageStackView.addArrangedSubview(voteAverageTitleLabel)
        
        voteAverageLabelAndImageStackView.addArrangedSubview(voteAverageImage)
        voteAverageLabelAndImageStackView.addArrangedSubview(voteAverageLabel)
        
        certificationStackView.addArrangedSubview(certificationLabel)
        certificationStackView.addArrangedSubview(certificationTitleLabel)
        
        setupStillCutCollectionView()
        
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(reserveButton.snp.top).offset(-20)
        }
        
        shadowDivider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(scrollView.snp.bottom)
            $0.height.equalTo(0.2)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        firstImageContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(firstImageContainerView.snp.width).multipliedBy(2.0 / 3.0)
        }
        
        firstStillImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        darkOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(infoLabel.snp.top).offset(-10)
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        ratingAndAgeStackView.snp.makeConstraints {
            $0.centerY.equalTo(favoriteButton)
            $0.leading.equalToSuperview().inset(20)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(firstStillImageView.snp.bottom).offset(heightMargin)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        directorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(ratingAndAgeStackView.snp.bottom).offset(heightMargin)
            $0.leading.equalToSuperview().inset(20)
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(directorTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        castTitleLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom).offset(heightMargin)
            $0.leading.equalToSuperview().inset(20)
        }
        
        castLabel.snp.makeConstraints {
            $0.top.equalTo(castTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        overviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(castLabel.snp.bottom).offset(heightMargin)
            $0.leading.equalToSuperview().inset(20)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(overviewTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        stillCutTitleLabel.snp.makeConstraints {
            $0.top.equalTo(overviewLabel.snp.bottom).offset(heightMargin)
            $0.leading.equalToSuperview().inset(20)
        }
        
        stillCutCollectionView.snp.makeConstraints {
            $0.top.equalTo(stillCutTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(collectionViewHeight)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        reserveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
        
        // Divider 제약
        ratingDivider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(dividerInset)
            $0.top.equalTo(ratingAndAgeStackView.snp.bottom).offset(heightMargin/2)
        }
        
        directorDivider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(dividerInset)
            $0.top.equalTo(directorLabel.snp.bottom).offset(heightMargin/2)
        }
        
        castDivider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(dividerInset)
            $0.top.equalTo(castLabel.snp.bottom).offset(heightMargin/2)
        }
        
        overviewDivider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(dividerInset)
            $0.top.equalTo(overviewLabel.snp.bottom).offset(heightMargin/2)
        }
    }
    
    // MARK: - Action
    @objc func favoriteButtonClicked(_ sender: UIButton) {
        viewModel.isFavorite.toggle()
        
        self.setButtonImage()
        
        let message: String
        
        if viewModel.isFavorite {
            viewModel.addFavoriteMovie()
            message = "찜 추가 완료"
        } else {
            viewModel.removeFavoriteMovie()
            message = "찜 삭제 완료"
        }
        
        showToast(message: message)
    }
    
    @objc func transitToBookingPage() {
        coordinator?.showBookingPage(movie: viewModel.movieDetail)
    }
    
    // MARK: - Internal Methods
    func configure() {
        viewModel.setStillImages { [weak self] in
            self?.updateStillCutCollectionView()
            self?.firstStillImageView.kf.setImage(with: self?.viewModel.firstStillImageUrl)
        }
        
        viewModel.setFavoriteStatus { [weak self] in
            self?.setButtonImage()
        }
        
        titleLabel.text = viewModel.titleText
        infoLabel.text = viewModel.infoText
        voteAverageLabel.text = viewModel.voteAverageText
        certificationLabel.text = viewModel.certificationText
        directorLabel.text = viewModel.directorText
        castLabel.text = viewModel.castText
        overviewLabel.text = viewModel.overviewText
    }
    
    // MARK: - Private Methods
    /// 즐겨찾기 버튼 fill 설정
    private func setButtonImage() {
        let image = viewModel.isFavorite ? "heart.fill" : "heart"
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        self.favoriteButton.setImage(UIImage(systemName: image)?.withConfiguration(config), for: .normal)
    }
    
    private func showToast(message: String) {
        // 띄워져 있는 toast 제거
        if let existingToast = view.viewWithTag(9999) {
            existingToast.removeFromSuperview()
        }
        
        let toast = UILabel()
        toast.tag = 9999
        toast.text = message
        toast.textColor = .systemBackground
        toast.backgroundColor = UIColor.separator.withAlphaComponent(0.8)
        toast.textAlignment = .center
        toast.font = .systemFont(ofSize: 14, weight: .bold)
        toast.alpha = 0
        toast.clipsToBounds = true
        toast.numberOfLines = 0
        
        let padding: CGFloat = 20
        let maxWidth = (view.frame.width - padding * 2) / 2
        let size = toast.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        toast.frame = CGRect(x: view.frame.width/2 - (maxWidth/2),
                             y: containerView.frame.maxY - size.height - 100,
                             width: maxWidth,
                             height: size.height + 16)
        
        toast.layer.cornerRadius = toast.frame.height / 2

        
        view.addSubview(toast)
        
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
}
