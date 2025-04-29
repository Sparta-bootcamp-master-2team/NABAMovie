import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    
    enum Section: Int, CaseIterable {
        case nowPlaying
        case upComing
    }
    
    enum Item: Hashable {
        case upcoming(MovieEntity)
        case nowPlaying(MovieEntity)
    }
    
    private var datasource: UICollectionViewDiffableDataSource<Section, Item>?
    
    // MARK: - UI Components
    
    private let headerView = HeaderView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Initailizer
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureCollectionView()
        viewModel.action?(.fetch)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    // MARK: - Configure CollectionView
    
    private func configureCollectionView() {
        setCollectionViewAttributes()
        setDatasoruce()
    }
    
    private func setCollectionViewAttributes() {
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.reuseIdentifier)
        collectionView.register(UpComingCell.self, forCellWithReuseIdentifier: UpComingCell.reuseIdentifier)
        collectionView.register(
            HomeCollectionViewHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeCollectionViewHeaderView.reuseIdentifier
        )
    }
    
    // MARK: - DataSource
    
    private func setDatasoruce() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView)
        { collectionView, indexPath, item in
            switch item {
            case .nowPlaying(let movie):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NowPlayingCell.reuseIdentifier,
                    for: indexPath
                ) as! NowPlayingCell
                
                cell.update(movie: movie)
                
                return cell
            case .upcoming(let movie):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UpComingCell.reuseIdentifier,
                    for: indexPath
                ) as! UpComingCell
                
                cell.update(movie: movie)
                
                return cell
            }
        }
        
        datasource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeCollectionViewHeaderView.reuseIdentifier,
                for: indexPath
            ) as? HomeCollectionViewHeaderView
            
            if let section = Section(rawValue: indexPath.section) {
                switch section {
                case .nowPlaying:
                    headerView?.update(with: "현재 상영작")
                case .upComing:
                    headerView?.update(with: "상영 예정")
                }
            }
            
            return headerView
        }
    }
    
    // MARK: - CollectionView Layout
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .nowPlaying:
                return self.makeNowPlayingSection()
            case .upComing:
                return self.makeUpcomingSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        return UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: config
        )
    }
    
    // MARK: - NowPlaying Section Layout
    
    private func makeNowPlayingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalWidth(0.6)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        setupCollectionViewCarousel(to: section)
        
        section.boundarySupplementaryItems = [makeHeaderItem(for: .nowPlaying)]
        
        return section
    }
    
    /// Carousel 을 적용하기 위해 셀 아이템에 중심부 부터의 거리를 계산 해 transform 을 적용
    private func setupCollectionViewCarousel(to section: NSCollectionLayoutSection) {
        section.visibleItemsInvalidationHandler = { visibleItems, offset, environment in
            
            // 헤더가 아닌 셀 아이템들
            let cellItems = visibleItems.filter {
                $0.representedElementKind != UICollectionView.elementKindSectionHeader
            }
            let containerWidth = environment.container.contentSize.width
            
            cellItems.forEach { item in
                let itemCenterRelativeToOffset = item.frame.midX - offset.x
                
                // 셀이 컬렉션 뷰의 중앙에서 얼마나 떨어져 있는지
                let distanceFromCenter = abs(itemCenterRelativeToOffset - containerWidth / 2.0)
                
                // 셀이 커지고 작아질 때의 최대 스케일, 최소 스케일
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / containerWidth), minScale)
                
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
    
    // MARK: - UpComing Section Layout
    
    private func makeUpcomingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .fractionalWidth(0.7)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        section.boundarySupplementaryItems = [makeHeaderItem(for: .upComing)]
        
        return section
    }
    
    // MARK: - Header View
    
    private func makeHeaderItem(for section: Section) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        switch section {
        case .nowPlaying:
            headerItem.contentInsets = .zero
        case .upComing:
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: -20)
        }
        return headerItem
    }
    
    // MARK: - Snapshot
    
    private func updateSnapshot(nowPlaying: [MovieEntity], upComing: [MovieEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        
        let nowPlayingItems = nowPlaying.map { Item.nowPlaying($0)}
        snapshot.appendItems(nowPlayingItems, toSection: .nowPlaying)
        
        let upComingItems = upComing.map { Item.upcoming($0)}
        snapshot.appendItems(upComingItems, toSection: .upComing)
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
}

// MARK: - Configure

private extension HomeViewController {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }
    
    func setAttributes() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    func setHierarchy() {
        [headerView, collectionView].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setBindings() {
        viewModel.onStateChange = { [weak self] state in
            switch state {
            case .HomeScreenMovies(let (nowPlaying, upComing)):
                self?.updateSnapshot(nowPlaying: nowPlaying, upComing: upComing)
            case .networkError(let error):
                self?.showNetworkErrorAlert(for: error)
            }
        }
    }
}
