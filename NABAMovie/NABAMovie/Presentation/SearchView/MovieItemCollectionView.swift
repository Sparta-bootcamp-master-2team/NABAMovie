//
//  MovieItemCollectionView.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/29/25.
//

import UIKit

final class MovieItemCollectionView: UICollectionView {
    
    enum Section { case main }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieEntity>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, MovieEntity>
    
    private var movieItemCollectionDataSource: DataSource?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.backgroundColor = .white
        configureDataSource()
        self.configureFlowLayout(with: UIScreen.main.bounds.width)
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
        newLayout.itemSize = CGSize(width: width, height: width * 1.8)
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
        let cellRegistration = UICollectionView.CellRegistration<MovieItemCollectionViewCell, [MovieEntity]> { cell,indexPath,itemIdentifier in }
        
        movieItemCollectionDataSource = DataSource(collectionView: self) { collectionView, indexPath, item in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: [item])
            cell.configure(model: item)
            return cell
        }
    }
    
    // Item 스냅샷 생성
    private func makeSnapShot(item: [MovieEntity]) -> SnapShot {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        return snapshot
    }
    // Item 스냅샷 적용
    private func apply(item: [MovieEntity]) {
        movieItemCollectionDataSource?.apply(makeSnapShot(item: item), animatingDifferences: true)
    }
    // 키워드에 맞는 영화 적용
    func fetchCellItems(item: [MovieEntity]) {
        apply(item: item)
    }
    
}
