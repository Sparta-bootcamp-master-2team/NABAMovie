//
//  UpComingCell.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//

import UIKit
import SnapKit
import Kingfisher

final class UpComingCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        String(describing: UpComingCell.self)
    }

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(movie: MovieEntity) {
        if let url = URL(string: movie.posterImageURL) {
            posterImageView.kf.setImage(with: url)
        }
        movieTitleLabel.text = movie.title
        genreLabel.text = movie.genre.joined(separator: ", ")
    }
}

private extension UpComingCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        [
            posterImageView,
            movieTitleLabel,
            genreLabel,
        ].forEach { contentView.addSubview($0) }
    }
    
    func setConstraints() {
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
        }
    }
}
