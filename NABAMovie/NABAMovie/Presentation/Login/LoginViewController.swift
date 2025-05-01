//
//  LoginViewController.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private weak var coordinator: LoginCoordinator?
    
    private let loginView: LoginView
    private let viewModel: LoginViewModel

    init(viewModel: LoginViewModel, coordinator: LoginCoordinator) {
        self.viewModel = viewModel
        self.loginView = LoginView()
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    private func setupActions() {
        loginView.onLoginButtonTapped = { [weak self] in
            self?.handleLogin()
        }
        
        loginView.onSignupButtonTapped = { [weak self] in
            self?.handleSignup()
        }
    }

    private func handleLogin() {
        guard let email = loginView.getIdText(),
              let password = loginView.getPasswordText() else {
            showErrorAlert(message: "아이디와 비밀번호를 입력해주세요.")
            return
        }
        
        viewModel.email = email
        viewModel.password = password
        
        Task { [weak self] in
            let result = await self?.viewModel.login()
            
            switch result {
            case .success(let user):
                print("로그인 성공: \(user.username)")
                self?.coordinator?.didLogin()
            case .failure(let error):
                self?.showErrorAlert(message: "아이디 또는 비밀번호가 잘못되었습니다.")
            case .none:
                break
            }
        }
    }
    
    private func handleSignup() {
        coordinator?.showSignUp()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
