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
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var genreStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [genreImageView, genreLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let genreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "videoImage")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
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
            genreStackView,
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
        
        genreStackView.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
