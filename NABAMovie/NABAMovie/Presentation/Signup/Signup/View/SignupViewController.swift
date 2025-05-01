//
//  SignupViewController.swift
//  NABAMovie
//
//  Created by 양원식 on 4/30/25.
//

import UIKit

final class SignupViewController: UIViewController {

    private let signupView = SignupView()
    private let viewModel: SignupViewModel

    init(viewModel: SignupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        self.view = signupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        bindView()
        bindViewModel()
    }

    private func bindView() {
        signupView.onInputChanged = { [weak self] username, email, pw, confirm, agreed in
            self?.viewModel.updateInput(
                username: username,
                email: email,
                password: pw,
                confirmPassword: confirm,
                isTermsAgreed: agreed
            )
        }

        signupView.onSignupButtonTapped = { [weak self] in
            self?.viewModel.signup()
        }

        signupView.onUsernameCheckTapped = { [weak self] username in
            self?.viewModel.checkUsernameDuplication(username)
        }

        signupView.onEmailCheckTapped = { [weak self] email in
            self?.viewModel.checkEmailDuplication(email)
        }
    }

    private func bindViewModel() {
        viewModel.isFormValidChanged = { [weak self] isValid in
            self?.signupView.signupButton.isEnabled = isValid
            self?.signupView.signupButton.backgroundColor = isValid ? .brand : .lightGray
        }

        viewModel.usernameErrorChanged = { [weak self] msg, isValid in
            self?.signupView.showUsernameError(msg, isValid: isValid)
        }

        viewModel.emailErrorChanged = { [weak self] msg, isValid in
            self?.signupView.showEmailError(msg, isValid: isValid)
        }

        viewModel.passwordErrorChanged = { [weak self] msg in
            self?.signupView.showPasswordError(msg)
        }

        viewModel.confirmPasswordErrorChanged = { [weak self] msg in
            self?.signupView.showConfirmPasswordError(msg)
        }

        viewModel.onSignupSuccess = { [weak self] in
            print("회원가입 성공")
//            self?.navigateToHome()
        }

        viewModel.onSignupError = { [weak self] msg in
            print("회원가입 실패: \(msg)")
        }
    }

}
