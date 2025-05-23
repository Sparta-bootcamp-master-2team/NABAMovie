//
//  MovieItemCollectionViewCell.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/29/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieItemCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = .user
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.posterImageView.image = .user
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.backgroundColor = .clear
        posterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5).priority(.low)
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(model: CellConfigurable) {
        if model is MovieEntity {
            let model = model as! MovieEntity
            guard let url = URL(string: model.posterImageURL) else { return }
            self.posterImageView.kf.setImage(with: url)
        }
        if model is Reservation {
            let model = model as! Reservation
            guard let url = URL(string: model.posterURL) else { return }
            self.posterImageView.kf.setImage(with: url)
        }
    }
    
}
