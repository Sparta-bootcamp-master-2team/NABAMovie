//
//  StillCutCell.swift
//  NABAMovie
//
//  Created by 정근호 on 4/29/25.
//

import UIKit

class StillCutCell: UICollectionViewCell {
    static let reuseIdentifier = "StillCutCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
