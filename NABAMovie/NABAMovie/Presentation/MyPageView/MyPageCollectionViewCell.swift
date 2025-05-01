//
//  MyPageCollectionViewCell.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/28/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MyPageCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: UI Property
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.image = .user
        imageView.backgroundColor = .brown
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var genreStackView: UIStackView = {
        let stackView = UIStackView()
        let imageView = UIImageView()
        imageView.image = .video
        imageView.snp.makeConstraints{ $0.width.height.equalTo(16) }
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        [imageView, genreLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView =  UIStackView()
        let imageView = UIImageView()
        imageView.image = .calendar
        imageView.snp.makeConstraints{ $0.width.height.equalTo(16) }
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        [imageView, timeLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        
        [movieTitleLabel, genreStackView, timeStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        [posterImageView, labelStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func setUpUI() {
        contentView.addSubview(movieStackView)
        
        movieStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        posterImageView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.width.equalTo(80)
        }
    }
    
    func configure(model: CellConfigurable) {
        if model is MovieEntity {
            let model = model as! MovieEntity
            self.movieTitleLabel.text = model.title
            self.timeLabel.text = model.releaseDate
            self.genreLabel.text = model.genre.joined(separator: ",")
            let url = URL(string: model.posterImageURL)
            self.posterImageView.kf.setImage(with: url)
        }
        if model is Reservation {
            let model = model as! Reservation
            self.movieTitleLabel.text = model.title
            self.timeLabel.text = model.reservationTime
            self.genreLabel.text = model.genre.joined(separator: ",")
            let url = URL(string: model.posterURL)
            self.posterImageView.kf.setImage(with: url)
        }
    }
 
}

