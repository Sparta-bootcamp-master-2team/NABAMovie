//
//  ReservationDetailView.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import UIKit
import SnapKit
import Kingfisher

// Delegate
protocol ReservationDetailViewDelegate: AnyObject {
    func reservationCancelButtonTapped()
}

final class ReservationDetailView: UIView {

    weak var delegate: ReservationDetailViewDelegate?
    
    // MARK: UI Property
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let memberNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var reservationCancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매취소", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .brand
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(reservationCancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let calendarImageView = UIImageView(image: UIImage(resource: .calendar))
    private let qrcodeImageView = UIImageView(image: UIImage(resource: .qrcode))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([posterImageView,
                          movieTitleLabel,
                          memberNumberLabel,
                          timeLabel,
                          reservationCancelButton,
                          calendarImageView,
                          qrcodeImageView])
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    @objc func reservationCancelButtonTapped() {
        delegate?.reservationCancelButtonTapped()
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2.5)
        }
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.lessThanOrEqualToSuperview().dividedBy(1.5)
        }
        memberNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(movieTitleLabel.snp.trailing).offset(20)
            $0.centerY.equalTo(movieTitleLabel)
        }
        calendarImageView.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(15)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(calendarImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        qrcodeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(reservationCancelButton.snp.top).offset(-30)
            $0.width.height.equalTo(200)
        }
        reservationCancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
    }
    
    func configure(model: Reservation) {
        self.movieTitleLabel.text = model.title
        self.timeLabel.text = model.reservationTime
        self.memberNumberLabel.text = "\(String(model.member))매"
        guard let url = URL(string: model.posterURL) else { return }
        self.posterImageView.kf.setImage(with: url)
    }
    
}
