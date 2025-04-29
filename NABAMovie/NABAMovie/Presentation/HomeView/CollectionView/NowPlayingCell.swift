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

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(movie: MovieEntity, index: Int) {
        guard let url = URL(string: movie.posterImageURL) else { return }
        posterImageView.kf.setImage(with: url)
        
        let number: Int
        if index < 2 {
            number = index + 9
        } else if index > 11 {
            number = index - 10
        } else {
            number = index - 1
        }
        
        numberLabel.text = "\(number)"
    }
}

private extension NowPlayingCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        self.contentView.addSubview(posterImageView)
        self.contentView.addSubview(numberLabel)
    }
    
    func setConstraints() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView).inset(10)
            $0.leading.equalTo(posterImageView).inset(10)
            $0.size.equalTo(30)
        }
    }
}
