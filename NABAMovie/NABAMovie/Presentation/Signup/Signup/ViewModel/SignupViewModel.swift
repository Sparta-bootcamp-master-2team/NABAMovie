//
//  SignupViewModel.swift
//  NABAMovie
//
//  Created by 양원식 on 5/1/25.
//

import Foundation

final class SignupViewModel {

    // MARK: - Bindings
    var onSignupSuccess: (() -> Void)?
    var onSignupError: ((String) -> Void)?
    var isFormValidChanged: ((Bool) -> Void)?
    var usernameErrorChanged: ((String?, Bool) -> Void)?
    var emailErrorChanged: ((String?, Bool) -> Void)?
    var passwordErrorChanged: ((String?) -> Void)?
    var confirmPasswordErrorChanged: ((String?) -> Void)?

    // MARK: - State
    private(set) var username = "" { didSet { validateAll() } }
    private(set) var email = "" { didSet { validateAll() } }
    private(set) var password = "" { didSet { validateAll() } }
    private(set) var confirmPassword = "" { didSet { validateAll() } }
    private(set) var isTermsAgreed = false { didSet { validateAll() } }

    // 중복 확인 여부 저장
    private var didCheckUsernameDuplication = false
    private var didCheckEmailDuplication = false
    private var lastCheckedUsername: String = ""
    private var lastCheckedEmail: String = ""

    // MARK: - Dependencies
    private let registerUseCase: RegisterUseCase
    private let loginUseCase: LoginUseCase
    private let userRepository: UserRepository

    init(
        registerUseCase: RegisterUseCase,
        loginUseCase: LoginUseCase,
        userRepository: UserRepository
    ) {
        self.registerUseCase = registerUseCase
        self.loginUseCase = loginUseCase
        self.userRepository = userRepository
    }

    // MARK: - Input 업데이트
    func updateInput(username: String, email: String, password: String, confirmPassword: String, isTermsAgreed: Bool) {
        self.username = username
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.isTermsAgreed = isTermsAgreed
    }

    // MARK: - 회원가입
    func signup() {
        Task {
            do {
                await registerUseCase.execute(email: email, password: password, nickname: username)
                try await loginUseCase.execute(email: email, password: password)
                onSignupSuccess?()
            } catch {
                onSignupError?(error.localizedDescription)
            }
        }
    }

    // MARK: - 중복 확인
    func checkUsernameDuplication(_ nickname: String) {
        Task {
            do {
                if try await userRepository.isNicknameTaken(nickname) {
                    didCheckUsernameDuplication = false
                    usernameErrorChanged?("이미 사용 중인 닉네임입니다.", false)
                } else {
                    didCheckUsernameDuplication = true
                    lastCheckedUsername = nickname
                    usernameErrorChanged?("사용 가능한 닉네임입니다.", true)
                }
            } catch {
                didCheckUsernameDuplication = false
                usernameErrorChanged?("닉네임 중복 확인 실패", false)
            }
        }
    }

    func checkEmailDuplication(_ email: String) {
        Task {
            do {
                if try await userRepository.isEmailTaken(email) {
                    didCheckEmailDuplication = false
                    emailErrorChanged?("이미 사용 중인 이메일입니다.", false)
                } else {
                    didCheckEmailDuplication = true
                    lastCheckedEmail = email
                    emailErrorChanged?("사용 가능한 이메일입니다.", true)
                }
            } catch {
                didCheckEmailDuplication = false
                emailErrorChanged?("이메일 중복 확인 실패", false)
            }
        }
    }

    // MARK: - 검증
    private func validateAll() {
        var isValid = true

        if username.trimmingCharacters(in: .whitespaces).isEmpty {
            usernameErrorChanged?("닉네임은 필수입니다.", false)
            isValid = false
        } else if !didCheckUsernameDuplication || username != lastCheckedUsername {
            usernameErrorChanged?(nil, true)
            isValid = false
        } else {
            usernameErrorChanged?("사용 가능한 닉네임입니다.", true)
        }

        if !email.contains("@") || !email.contains(".") {
            emailErrorChanged?("유효한 이메일 주소를 입력해주세요.", false)
            isValid = false
        } else if !didCheckEmailDuplication || email != lastCheckedEmail {
            emailErrorChanged?(nil, true)
            isValid = false
        } else {
            emailErrorChanged?("사용 가능한 이메일입니다.", true)
        }

        if !isValidPassword(password) {
            passwordErrorChanged?("영문, 숫자, 특수문자 조합으로 8자 이상 입력해주세요.")
            isValid = false
        } else {
            passwordErrorChanged?(nil)
        }

        if confirmPassword != password {
            confirmPasswordErrorChanged?("비밀번호가 일치하지 않습니다.")
            isValid = false
        } else {
            confirmPasswordErrorChanged?(nil)
        }

        if !isTermsAgreed {
            isValid = false
        }

        isFormValidChanged?(isValid)
    }

    private func isValidPassword(_ text: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

