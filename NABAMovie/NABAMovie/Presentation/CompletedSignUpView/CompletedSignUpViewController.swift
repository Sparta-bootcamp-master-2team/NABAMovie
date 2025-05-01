//
//  CompletedSignUpViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 5/1/25.
//

import UIKit
import SnapKit

final class CompletedSignUpViewController: UIViewController {

    private let logoImageView = UIImageView(image: .NABAMOVIE_LOGO)
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = "사용자님, 환영합니다!"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(welcomeLabel)
        return stackView
    }()
    
    private let completeSignUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .brand
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.welcomeLabel.text = "\(username)님, 환영합니다!"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews([stackView, completeSignUpButton])
        configureLayout()
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().dividedBy(1.2)
        }
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(249)
            $0.height.equalTo(156)
        }
        completeSignUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
    }
}
