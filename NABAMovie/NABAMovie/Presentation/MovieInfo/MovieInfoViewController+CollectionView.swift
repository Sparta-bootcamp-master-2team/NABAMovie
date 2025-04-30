//
//  MovieInfoViewController+CollectionView.swift
//  NABAMovie
//
//  Created by 정근호 on 4/29/25.
//

import UIKit

extension MovieInfoViewController {
    
    enum StillCutSection {
        case main
    }
    
    struct StillCutItem: Hashable {
        let id = UUID()
        let image: URL
    }
    
    func setupStillCutCollectionView() {
        // 셀 등록
        stillCutCollectionView.register(StillCutCell.self, forCellWithReuseIdentifier: StillCutCell.reuseIdentifier)
        
        // 데이터 소스 만들기
        stillCutDataSource = UICollectionViewDiffableDataSource<StillCutSection, StillCutItem>(collectionView: stillCutCollectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StillCutCell.reuseIdentifier, for: indexPath) as? StillCutCell else {
                return UICollectionViewCell()
            }
            cell.imageView.kf.setImage(with: item.image)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<StillCutSection, StillCutItem>()
        snapshot.appendSections([.main])
        let items = viewModel.stillImages.map { StillCutItem(image: $0) }
        snapshot.appendItems(items)
        stillCutDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateStillCutCollectionView() {
        var snapshot = stillCutDataSource.snapshot()
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        let items = viewModel.stillImages.map { StillCutItem(image: $0) }
        snapshot.appendItems(items, toSection: .main)
        stillCutDataSource.apply(snapshot, animatingDifferences: true)
    }
}
