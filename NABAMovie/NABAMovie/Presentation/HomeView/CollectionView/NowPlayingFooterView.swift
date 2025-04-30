//
//  NowPlayingFooterView.swift
//  NABAMovie
//
//  Created by 박주성 on 4/29/25.
//

import UIKit
import SnapKit

final class NowPlayingFooterView: UICollectionReusableView {
    
    static var reuseIdentifier: String {
        String(describing: NowPlayingFooterView.self)
    }
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let runtimeAndGenreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingImageView, ratingLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .brand
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateRatingLabel(voteAverage: Double, voteCount: String) {
        // 1. 문자열 조합
        let avgText = String(voteAverage)                     // 예: "8.5"
        let countText = "(\(voteCount))"                      // 예: "(1,234)"
        let fullText = "\(avgText) \(countText)"              // 예: "8.5 (1234)"
        
        // 2. 기본 폰트로 NSAttributedString 생성
        let defaultFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        let attributed = NSMutableAttributedString(
            string: fullText,
            attributes: [.font: defaultFont]
        )
        
        // 3. voteCount 부분만 작은 폰트로 변경
        if let range = fullText.range(of: countText) {
            let nsRange = NSRange(range, in: fullText)
            let smallFont = UIFont.systemFont(ofSize: 12)
            attributed.addAttribute(.font, value: smallFont, range: nsRange)
        }
        
        // 4. 레이블에 적용
        ratingLabel.attributedText = attributed
    }
    
    func update(with movie: MovieEntity) {
        movieTitleLabel.text = movie.title
        
        let genreString = movie.genre.joined(separator: ",")
        runtimeAndGenreLabel.text = "\(movie.runtime)분 • \(genreString)"
        
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let voteCount = numberFormatter.string(for: movie.voteCount) ?? "0"
        updateRatingLabel(voteAverage: movie.voteAverage, voteCount: voteCount)
    }
}

private extension NowPlayingFooterView {
    func configure() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        [
            movieTitleLabel,
            runtimeAndGenreLabel,
            ratingStackView
        ].forEach { self.addSubview($0) }
    }
    
    func setConstraints() {
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
        }
        
        runtimeAndGenreLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        ratingStackView.snp.makeConstraints {
            $0.top.equalTo(runtimeAndGenreLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        ratingImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
        }
    }
}
