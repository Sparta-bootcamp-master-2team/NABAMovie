//
//  MovieItemCollectionView.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/29/25.
//

import UIKit

final class MovieItemCollectionView: UICollectionView {
    
    enum Section { case main }
    enum ItemWrapper: Hashable {
        case movieEntity(MovieEntity)
        case reservationEntity(Reservation)
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ItemWrapper>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, ItemWrapper>
    
    private(set) var movieItemCollectionDataSource: DataSource?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        configureDataSource()
        self.configureFlowLayout(with: UIScreen.main.bounds.width)
        self.keyboardDismissMode = .onDrag
        self.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 계산된 셀 너비 적용
    private func configureFlowLayout(with width: CGFloat) {
        let newLayout = UICollectionViewFlowLayout()
        newLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        newLayout.scrollDirection = .vertical
        let width = collectionViewWidth(width: width, layout: newLayout)
        newLayout.itemSize = CGSize(width: width, height: width * 1.5)
        self.collectionViewLayout = newLayout
        self.reloadData()
    }
    
    // 2개의 가로 셀을 구성하기 위해 현재 너비 기준으로 셀 너비 계산
    private func collectionViewWidth(width: CGFloat, layout: UICollectionViewFlowLayout) -> CGFloat {
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = layout.minimumLineSpacing
        let sectionInsets = layout.sectionInset
        
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing + sectionInsets.left + sectionInsets.right
        let availableWidth = width - totalSpacing
        
        let cellWidth = availableWidth / numberOfItemsPerRow
        return cellWidth
    }
    
    // DiffableDataSource 구성
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MovieItemCollectionViewCell, [ItemWrapper]> { cell,indexPath,itemIdentifier in }
        
        movieItemCollectionDataSource = DataSource(collectionView: self) { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: [item])
            switch item {
            case .movieEntity(let movieEntity):
                cell.configure(model: movieEntity)
            case .reservationEntity(let reservationEntity):
                cell.configure(model: reservationEntity)
            }
            return cell
        }
    }
    
    // Item 스냅샷 생성
    private func makeSnapShot(item: [CellConfigurable]) -> SnapShot {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        if item is [MovieEntity] {
            snapshot.appendItems(item.map{ItemWrapper.movieEntity($0 as! MovieEntity)})
        }
        if item is [Reservation] {
            snapshot.appendItems(item.map{ItemWrapper.reservationEntity($0 as! Reservation)})
        }
        
        return snapshot
    }
    // Item 스냅샷 적용
    private func apply(item: [CellConfigurable]) {
        movieItemCollectionDataSource?.apply(makeSnapShot(item: item), animatingDifferences: true)
    }
    // 키워드에 맞는 영화 적용
    func fetchCellItems(item: [CellConfigurable]) {
        apply(item: item)
    }
    
}
