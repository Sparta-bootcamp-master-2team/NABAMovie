//
//  MyInformationView.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/28/25.
//

import UIKit

// 상단 유저 정보 뷰
final class MyInformationView: UIView {
    
    private var username = "사용자"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .user
        return imageView
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.username) 님,\n반갑습니다."
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle( "로그아웃 >", for: .normal)
        button.setTitleColor(.brand, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        [profileImageView, greetingLabel, logoutButton].forEach { view in
            addSubview(view)
        }
        
        greetingLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(greetingLabel.snp.leading).offset(-15)
            $0.width.height.equalTo(85)
        }
        
        logoutButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    @objc func logoutButtonTapped() {
        print("logoutButton Tapped")
    }
    
}
