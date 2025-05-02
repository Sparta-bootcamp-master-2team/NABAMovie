//
//  LoginView.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import UIKit
import SnapKit

final class LoginView: UIView, UITextFieldDelegate {

    // MARK: - UI Components

    private var nbcLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .nbcLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var navaLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .NABAMOVIE_LOGO
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var idContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 25
        return view
    }()
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private var idTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "입력",
            attributes: [
                .foregroundColor: UIColor.gray
            ]
        )
        textField.textColor = .darkGray
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.setLeftPadding(2)
        return textField
    }()
    
    private var passwordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 25
        return view
    }()
    
    private var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "입력",
            attributes: [
                .foregroundColor: UIColor.gray
            ]
        )
        textField.textColor = .darkGray
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.setLeftPadding(2)
        return textField
    }()
    
    private lazy var passwordToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(didTapPasswordToggle), for: .touchUpInside)
        return button
    }()
    
    private var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .brand
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    // MARK: - Callbacks

    var onLoginButtonTapped: (() -> Void)?
    var onSignupButtonTapped: (() -> Void)?
    var setTextFieldDelegates: ((UITextFieldDelegate) -> Void)?
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        
        setTextFieldDelegates?(self)
        
        addSubviews([
            nbcLogoImageView,
            navaLogoImageView,
            idContainerView,
            passwordContainerView,
            loginButton,
            signupButton
        ])
        
        idContainerView.addSubviews([
            idLabel,
            idTextField
        ])
        
        passwordContainerView.addSubviews([
            passwordLabel,
            passwordTextField,
            passwordToggleButton
        ])
        
        
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        nbcLogoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(26)
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(34)
        }
        
        navaLogoImageView.snp.makeConstraints {
            $0.top.equalTo(nbcLogoImageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(249)
            $0.height.equalTo(156)
        }
        
        idContainerView.snp.makeConstraints {
            $0.top.equalTo(navaLogoImageView.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        idLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
        }
        
        idTextField.snp.makeConstraints {
            $0.leading.equalTo(idLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        passwordContainerView.snp.makeConstraints {
            $0.top.equalTo(idContainerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.leading.equalTo(passwordLabel.snp.trailing).offset(8)
            $0.trailing.equalTo(passwordToggleButton.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        passwordToggleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordContainerView.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
    }
    
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(didTapSignupButton), for: .touchUpInside)
    }
    
    @objc private func didTapPasswordToggle() {
        passwordTextField.isSecureTextEntry.toggle()
        let iconName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggleButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @objc private func didTapLoginButton() {
        onLoginButtonTapped?()
    }
    
    @objc private func didTapSignupButton() {
        onSignupButtonTapped?()
    }
    
    // MARK: - Functions
    
    func getIdText() -> String? {
        return idTextField.text
    }
    
    func getPasswordText() -> String? {
        return passwordTextField.text
    }
    
    func setTextFieldDelegates(_ delegate: UITextFieldDelegate) {
        idTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }

}
