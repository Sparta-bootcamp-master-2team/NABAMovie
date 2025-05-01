//
//  MyInformationView.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/28/25.
//

import UIKit

protocol MyInformationViewDelegate: AnyObject {
    func logoutButtonTapped()
}
// 상단 유저 정보 뷰
final class MyInformationView: UIView {
    
    weak var delegate: MyInformationViewDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .user
        return imageView
    }()
    
    var greetingLabel: UILabel = {
        let label = UILabel()
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
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(20)
        }
        
        logoutButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    @objc func logoutButtonTapped() {
        delegate?.logoutButtonTapped()
    }
    
}
