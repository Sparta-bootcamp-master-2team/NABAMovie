//
//  NowPlayingCell.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//

import UIKit
import SnapKit
import Kingfisher

final class NowPlayingCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        String(describing: NowPlayingCell.self)
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(movie: MovieEntity) {
        guard let url = URL(string: movie.posterImageURL) else { return }
        imageView.kf.setImage(with: url)
    }
}

private extension NowPlayingCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        self.contentView.addSubview(imageView)
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
