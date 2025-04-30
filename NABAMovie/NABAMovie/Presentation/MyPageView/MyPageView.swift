//
//  MyPageView.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/28/25.
//

import UIKit

// MyPageCollectionSection
enum MyPageCollectionSection {
    case reservation
    case favorite
    
    static var reservationIndex = 0
    static var favoriteIndex = 1
}

enum MyPageCellWrapper: Hashable {
    case favorite(MovieEntity)
    case reservation(Reservation)
}

protocol MyPageViewDelegate: AnyObject {
    func reservationMoreButtonTapped()
    func favoriteMoreButtonTapped()
    func logoutButtonTapped()
    func didSelectedItem(item: CellConfigurable)
}

final class MyPageView: UIView {
    
    var myPageCollectionView = MyPageCollectionView()
    var myInformationView = MyInformationView()
    typealias DataSource = UICollectionViewDiffableDataSource<MyPageCollectionSection, MyPageCellWrapper>
    typealias SnapShot = NSDiffableDataSourceSnapshot<MyPageCollectionSection, MyPageCellWrapper>
    // DiffableDataSource
    var dataSource: DataSource?
    var delegate: MyPageViewDelegate?
    //Reservation Items ,Favorite Items
    var reservations: [Reservation] = []
    var favorites: [MovieEntity] = []
    
    // 마이페이지에서 보이는 아이템은 최대 2개
    var displayedReservationItem: [Reservation] {
        return Array(reservations.prefix(2))
    }
    var displayedFavoritesItem: [MovieEntity] {
        return Array(favorites.prefix(2))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        myPageCollectionView.delegate = self
        myInformationView.delegate = self
        configureDataSource()
        apply()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 설정
    private func setUpUI() {
        [myInformationView, myPageCollectionView].forEach { view in
            addSubview(view)
        }
        
        myInformationView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(5)
        }
        
        myPageCollectionView.snp.makeConstraints{
            $0.top.equalTo(myInformationView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        // DiffableDataSource Cell 설정
        let cellRegistration = UICollectionView.CellRegistration
        <MyPageCollectionViewCell, MyPageCellWrapper>{ cell, indexPath, item in
            switch item {
            case .favorite(let movie):
                cell.configure(model: movie)
            case .reservation(let movie):
                cell.configure(model: movie)
            }
        }
        dataSource = DataSource(collectionView: myPageCollectionView) { collectionView, indexPath, movieEntity in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movieEntity)
        }
        
        // DiffableDataSource Header 설정
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <MyPageCollectionHeaderView>(elementKind: MyPageCollectionHeaderView.elementKind)
        {[unowned self] supplementaryView, elementKind, indexPath in
            if indexPath.section == MyPageCollectionSection.reservationIndex {
                supplementaryView.configure(section: .reservation, count: self.reservations.count)
                supplementaryView.sectionIndex = MyPageCollectionSection.reservationIndex
            } else if indexPath.section == MyPageCollectionSection.favoriteIndex {
                supplementaryView.configure(section: .favorite, count: self.favorites.count)
                supplementaryView.sectionIndex = MyPageCollectionSection.favoriteIndex
            }
            supplementaryView.delegate = self
        }
        dataSource?.supplementaryViewProvider = { [unowned self] collectionView, elementKind, indexPath in
            return self.myPageCollectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    // 스냅샷 생성
    private func makeSnapshot() -> SnapShot {
        var snapshot = SnapShot()
        snapshot.appendSections([.reservation, .favorite])
        snapshot.appendItems(displayedReservationItem.map{ MyPageCellWrapper.reservation($0)}, toSection: .reservation)
        snapshot.appendItems(displayedFavoritesItem.map{ MyPageCellWrapper.favorite($0)}, toSection: .favorite)
        return snapshot
    }
    
    // DataSource에 스냅샷 적용
    private func apply() {
        dataSource?.apply(makeSnapshot(), animatingDifferences: false)
    }
    
    func fetchItems(reservations: [Reservation], favorites: [MovieEntity]) {
        self.reservations = reservations
        self.favorites = favorites
        apply()
    }
}

// MARK: UICollectionViewDelegate
extension MyPageView: UICollectionViewDelegate {
    // 셀 터치시 해당 셀의 데이터를 전달
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == MyPageCollectionSection.reservationIndex {
            delegate?.didSelectedItem(item: displayedReservationItem[indexPath.row])
//            print(displayedReservationItem[indexPath.row])
        } else if indexPath.section == MyPageCollectionSection.favoriteIndex {
//            print(displayedFavoritesItem[indexPath.row])
            delegate?.didSelectedItem(item: displayedFavoritesItem[indexPath.row])
        }
    }
}

// MARK: UICollectionHeaderViewDelegate
extension MyPageView: MyPageCollectionHeaderViewDelegate {
    // 헤더뷰의 더보기 버튼 클릭 이벤트
    func moreButtonTapped(in index: Int) {
        if index == MyPageCollectionSection.reservationIndex {
            delegate?.reservationMoreButtonTapped()
        } else if index == MyPageCollectionSection.favoriteIndex {
            delegate?.favoriteMoreButtonTapped()
        }
    }
}

// MARK: MyInformationViewDelegate
extension MyPageView: MyInformationViewDelegate {
    func logoutButtonTapped() {
        delegate?.logoutButtonTapped()
    }
}
