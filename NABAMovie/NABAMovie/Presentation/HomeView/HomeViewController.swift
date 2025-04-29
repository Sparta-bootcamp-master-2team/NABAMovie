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
        case nowPlaying(MovieEntity, UUID)
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
        collectionView.register(
            NowPlayingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: NowPlayingFooterView.reuseIdentifier
        )
    }
    
    // MARK: - DataSource
    
    private func setDatasoruce() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView)
        { collectionView, indexPath, item in
            switch item {
            case .nowPlaying(let movie, _):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NowPlayingCell.reuseIdentifier,
                    for: indexPath
                ) as! NowPlayingCell
                
                cell.update(movie: movie, index: indexPath.row)
                
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
            if kind == UICollectionView.elementKindSectionHeader,
               let section = Section(rawValue: indexPath.section) {
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HomeCollectionViewHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? HomeCollectionViewHeaderView
                
                switch section {
                case .nowPlaying:
                    headerView?.update(with: "현재 상영작")
                case .upComing:
                    headerView?.update(with: "올해 상영 예정작")
                }
                
                return headerView
            } else if kind == UICollectionView.elementKindSectionFooter,
                      let section = Section(rawValue: indexPath.section),
                      section == .nowPlaying {
                
                let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: NowPlayingFooterView.reuseIdentifier,
                    for: indexPath
                ) as? NowPlayingFooterView
                
                return footerView
            }
            return nil
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
            widthDimension: .fractionalWidth(0.56),
            heightDimension: .fractionalWidth(0.84)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        setupCollectionViewCarousel(to: section)
        
        section.boundarySupplementaryItems = [
            makeHeaderItem(for: .nowPlaying),
            makeFooterItem()
        ]
        
        return section
    }
    
    // MARK: - Carousel
    
    /// Carousel 을 적용하기 위해 셀 아이템에 중심부 부터의 거리를 계산 해 transform 을 적용
    private func setupCollectionViewCarousel(to section: NSCollectionLayoutSection) {
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, offset, env in
            guard let self = self else { return }
            
            // 1) 스케일 변환
            let containerWidth = env.container.contentSize.width
            let centerX = containerWidth / 2
            let cellItems = visibleItems.filter { $0.representedElementKind == nil }
            cellItems.forEach { item in
                let midX = item.frame.midX - offset.x
                let distance = abs(midX - centerX)
                let scale = max(1.0 - (distance / containerWidth), 0.8)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            
            // 2) 무한 스크롤 처리 (완전히 중앙에 왔을 때만)
            let headCount = 2
            let tailCount = 2
            let sectionIndex = Section.nowPlaying.rawValue
            let totalItems = self.collectionView.numberOfItems(inSection: sectionIndex)
            let realCount = totalItems - headCount - tailCount
            
            // 중앙 판단 임계값 (1pt 이내)
            let centerThreshold: CGFloat = 1.0
            
            // 화면 중앙 포인트
            let centerPoint = CGPoint(
                x: self.collectionView.bounds.midX,
                y: self.collectionView.bounds.midY
            )
            guard
                let indexPath = self.collectionView.indexPathForItem(at: centerPoint),
                indexPath.section == sectionIndex,
                let attrs = self.collectionView.layoutAttributesForItem(at: indexPath)
            else { return }
            
            // 셀이 정확히 중앙에 왔는지
            let cellMidX = attrs.frame.midX - offset.x
            let distanceToCenter = abs(cellMidX - centerX)
            guard distanceToCenter < centerThreshold else { return }
            
            let item = indexPath.item
            if item < headCount {
                // 뒤로 무한 스크롤
                let target = IndexPath(item: item + realCount, section: sectionIndex)
                
                self.collectionView.scrollToItem(
                    at: target,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
            else if item >= headCount + realCount {
                // 앞으로 무한 스크롤
                let target = IndexPath(item: item - realCount, section: sectionIndex)
                
                self.collectionView.scrollToItem(
                    at: target,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
            
            // 3) 푸터 업데이트
            if let currentItem = self.datasource?.itemIdentifier(for: indexPath),
               case let .nowPlaying(movie, _) = currentItem,
               let footerView = self.collectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(item: 0, section: sectionIndex)
               ) as? NowPlayingFooterView {
                footerView.update(with: movie)
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
            heightDimension: .fractionalWidth(0.65)
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
    
    private func makeFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        return footerItem
    }
    
    // MARK: - Snapshot
    
    private func updateSnapshot(nowPlaying: [MovieEntity], upComing: [MovieEntity]) {
        let headCount = 2
        let tailCount = 2
        
        // 1) 스냅샷 구성
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        
        let headItems = Array(nowPlaying.suffix(headCount))
        let tailItems = Array(nowPlaying.prefix(tailCount))
        let circular = headItems + nowPlaying + tailItems
        
        let nowItems = circular.map { Item.nowPlaying($0, UUID()) }
        snapshot.appendItems(nowItems, toSection: .nowPlaying)
        let upItems = upComing.map { Item.upcoming($0) }
        snapshot.appendItems(upItems, toSection: .upComing)
        
        // 2) 스냅샷 적용 (completion 블록)
        datasource?.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self = self else { return }
            
            // 3) headCount 만큼 offset 주기
            let initialIndex = IndexPath(
                item: headCount,
                section: Section.nowPlaying.rawValue
            )
            
            self.collectionView.scrollToItem(
                at: initialIndex,
                at: .centeredHorizontally,
                animated: true
            )
            
            // 4) 최초 푸터 업데이트
            if let firstMovie = nowPlaying.first,
               let footer = self.collectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(item: 0, section: Section.nowPlaying.rawValue)
               ) as? NowPlayingFooterView {
                footer.update(with: firstMovie)
            }
        }
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
