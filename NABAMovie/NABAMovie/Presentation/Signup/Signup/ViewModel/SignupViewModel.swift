//
//  SignupViewModel.swift
//  NABAMovie
//
//  Created by 양원식 on 5/1/25.
//

import Foundation

final class SignupViewModel {

    // MARK: - Bindings
    var onSignupSuccess: (@MainActor(String) -> Void)?
    var onSignupError: (@MainActor(String) -> Void)?
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
            let result = await registerUseCase.execute(email: email, password: password, username: username)
            switch result {
            case .success(_):
                await login()
            case .failure(let error):
                await onSignupError?(error.localizedDescription)
            }
        }
    }
    
    func login() async {
        do {
            let user = try await loginUseCase.execute(email: email, password: password)
            await onSignupSuccess?(user.username)
        } catch {
            await onSignupError?(error.localizedDescription)
        }
    }

    // MARK: - 중복 확인
    func checkUsernameDuplication(_ nickname: String) {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)

        guard !trimmed.isEmpty else {
            didCheckUsernameDuplication = false
            usernameErrorChanged?("닉네임을 입력해주세요.", false)
            return
        }

        Task {
            do {
                if try await userRepository.isNicknameTaken(trimmed) {
                    didCheckUsernameDuplication = false
                    usernameErrorChanged?("이미 사용 중인 닉네임입니다.", false)
                } else {
                    didCheckUsernameDuplication = true
                    lastCheckedUsername = trimmed
                    usernameErrorChanged?("사용 가능한 닉네임입니다.", true)
                }
                validateAll()
            } catch {
                didCheckUsernameDuplication = false
                usernameErrorChanged?("닉네임 중복 확인 실패", false)
                validateAll()
            }
        }
    }

    func checkEmailDuplication(_ email: String) {
        let trimmed = email.trimmingCharacters(in: .whitespaces)

        guard !trimmed.isEmpty else {
            didCheckEmailDuplication = false
            emailErrorChanged?("이메일을 입력해주세요.", false)
            return
        }

        guard isValidEmail(trimmed) else {
            didCheckEmailDuplication = false
            emailErrorChanged?("유효한 이메일 형식을 입력해주세요.", false)
            return
        }

        Task {
            do {
                if try await userRepository.isEmailTaken(trimmed) {
                    didCheckEmailDuplication = false
                    emailErrorChanged?("이미 사용 중인 이메일입니다.", false)
                    validateAll()
                } else {
                    didCheckEmailDuplication = true
                    lastCheckedEmail = trimmed
                    emailErrorChanged?("사용 가능한 이메일입니다.", true)
                }
                validateAll()
            } catch {
                didCheckEmailDuplication = false
                emailErrorChanged?("이메일 중복 확인 실패", false)
                validateAll()
            }
        }
    }

    // MARK: - 검증
    private func validateAll() {
        var isValid = true

        if !isValidUsername(username) {
            usernameErrorChanged?("닉네임은 공백 없이 2자 이상 입력해주세요.", false)
            isValid = false
        } else if !didCheckUsernameDuplication || username != lastCheckedUsername {
            usernameErrorChanged?("닉네임 중복 확인을 해주세요.", false)
            isValid = false
        } else {
            usernameErrorChanged?("사용 가능한 닉네임입니다.", true)
        }

        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            emailErrorChanged?("이메일은 필수입니다.", false)
            isValid = false
        } else if !isValidEmail(email) {
            emailErrorChanged?("유효한 이메일 형식을 입력해주세요.", false)
            isValid = false
        } else if !didCheckEmailDuplication || email != lastCheckedEmail {
            emailErrorChanged?("이메일 중복 확인을 해주세요.", false)
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
        DispatchQueue.main.async {
            self.isFormValidChanged?(isValid)
        }
    }

    private func isValidUsername(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= 2 else { return false }
        return !trimmed.contains(" ")
    }

    private func isValidEmail(_ text: String) -> Bool {
        let koreanRegex = ".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*"
        let containsKorean = NSPredicate(format: "SELF MATCHES %@", koreanRegex).evaluate(with: text)
        if containsKorean { return false }

        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: text)
    }

    private func isValidPassword(_ text: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}


