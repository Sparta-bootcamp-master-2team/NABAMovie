//
//  SignupView.swift
//  NABAMovie
//
//  Created by 양원식 on 4/30/25.
//

import UIKit
import SnapKit

final class SignupView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let topBarView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .brand
        return button
    }()

    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입을 위한 단계입니다 !"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    
    /// 닉네임 라벨과 입력 필드를 수직으로 쌓은 StackView
    private lazy var usernameVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameSubtitleLabel, usernameHStack])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    /// 닉네임 입력 필드와 중복확인 버튼을 수평으로 배치한 StackView
    private lazy var usernameHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameTextField, usernameCheckButton])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    /// "닉네임" 라벨
    private let usernameSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    /// 닉네임 입력 필드
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요."
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        return textField
    }()
    
    /// 닉네임 중복 확인 버튼
    private let usernameCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복 확인", for: .normal)
        button.setTitleColor(.brand, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    /// 닉네임 입력 하단 구분선
    private let usernameDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .brand
        return view
    }()
    
    /// 닉네임 유효성 오류 라벨
    private let usernameErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임은 필수입니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    /// 이메일 라벨과 필드들을 수직으로 쌓은 StackView
    private lazy var idVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [idSubtitleLabel, idHStack])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    /// 이메일 입력 필드 (id@domain.com 형식), 각 요소 수평 배치
    private lazy var idHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        
        // @ 라벨 설정
        let atLabel = UILabel()
        atLabel.text = "@"
        atLabel.font = .systemFont(ofSize: 16)
        atLabel.textColor = .label
        atLabel.setContentHuggingPriority(.required, for: .horizontal)
        atLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // 우선순위 설정 및 하위 뷰 추가
        idPrefixTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        idPrefixTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        domainTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        domainTextField.setContentCompressionResistancePriority(.required, for: .horizontal)
        idCheckButton.setContentHuggingPriority(.required, for: .horizontal)

        stack.addArrangedSubview(idPrefixTextField)
        idPrefixTextField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        stack.addArrangedSubview(atLabel)
        stack.addArrangedSubview(domainMenuButton)
        domainMenuButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        stack.addArrangedSubview(domainTextField)
        
        // Spacer 뷰 (간격 조절용)
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        spacer.snp.makeConstraints {
            $0.width.equalTo(4)
        }
        stack.addArrangedSubview(spacer)
        
        stack.addArrangedSubview(idCheckButton)
        
        return stack
    }()
    
    /// "이메일" 라벨
    private let idSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    /// 이메일 앞부분 입력 필드
    private let idPrefixTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        return textField
    }()
    
    /// 도메인 선택 버튼 (ex. naver.com)
    private let domainMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택해주세요", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    /// 도메인 직접 입력 필드 (선택 시 노출)
    private let domainTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "도메인 입력"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .darkGray
        textField.textAlignment = .left
        textField.autocapitalizationType = .none
        textField.isHidden = true
        return textField
    }()
    
    /// 이메일 중복 확인 버튼
    private let idCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복 확인", for: .normal)
        button.setTitleColor(.brand, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    /// 이메일 입력 하단 구분선
    private let idDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .brand
        return view
    }()
    
    /// 이메일 오류 라벨
    private let idErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "올바른 이메일 형식이 아닙니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    /// 비밀번호 입력 섹션 StackView
    private lazy var passwordVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordSubtitleLabel, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    /// "비밀번호" 라벨
    private let passwordSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    /// 비밀번호 입력 필드
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "영문, 숫자, 특수기호 중 2가지 이상 조합"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        return textField
    }()
    
    /// 비밀번호 하단 구분선
    private let passwordDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .brand
        return view
    }()
    
    /// 비밀번호 오류 라벨
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 형식이 올바르지 않습니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    /// 비밀번호 확인 입력 섹션 StackView
    private lazy var passwordConfirmVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordConfirmSubtitleLabel, passwordConfirmTextField])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    /// "비밀번호 확인" 라벨
    private let passwordConfirmSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    /// 비밀번호 확인 입력 필드
    private let passwordConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 다시 입력해주세요."
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        return textField
    }()
    
    /// 비밀번호 확인 하단 구분선
    private let passwordConfirmDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .brand
        return view
    }()
    
    /// 비밀번호 확인 오류 라벨
    private let passwordConfirmErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    /// 약관 동의 뷰
    private lazy var termsRequiredView: TermsAgreementView = {
        let view = TermsAgreementView(
            title: "본인 인증 이용 약관 전체 동의",
            isRequired: true,
            content: TermsText.required
        )
        return view
    }()
    
    private lazy var termsOptionalView: TermsAgreementView = {
        let view = TermsAgreementView(
            title: "마케팅 개인정보 수집 이용 안내",
            isRequired: false,
            content: TermsText.optional
        )
        return view
    }()
    
    /// 회원가입 버튼
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .brand
        button.isEnabled = false
        button.layer.cornerRadius = 25
        return button
    }()
    
    var onUsernameCheckTapped: ((String) -> Void)?
    var onEmailCheckTapped: ((String) -> Void)?
    /// 사용자 입력 변경 시 호출되는 클로저
    var onInputChanged: ((String, String, String, String, Bool) -> Void)?

    /// 회원가입 버튼 클릭 시 호출되는 클로저
    var onSignupButtonTapped: (() -> Void)?

    
    
    
    // MARK: - Init 및 레이아웃 설정
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDomainMenu()
        backgroundColor = .white
        
        addSubview(topBarView)
        topBarView.addSubviews([backButton, topTitleLabel])
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews([
            titleLabel,
            usernameVStack,
            usernameDivider,
            usernameErrorLabel,
            idVStack,
            idDivider,
            idErrorLabel,
            passwordVStack,
            passwordDivider,
            passwordErrorLabel,
            passwordConfirmVStack,
            passwordConfirmDivider,
            passwordConfirmErrorLabel,
            termsRequiredView,
            termsOptionalView,
            signupButton
        ])

        setupConstraints()
        setupBindings()
        validateForm()
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// 도메인 선택 메뉴 설정 (UIMenu + 직접입력 지원)
    private func configureDomainMenu() {
        domainMenuButton.menu = UIMenu(title: "도메인 선택", children: [
            UIAction(title: "gmail.com") { _ in
                self.domainMenuButton.setTitle("gmail.com", for: .normal)
                self.domainMenuButton.isHidden = false
                self.domainTextField.isHidden = true
                self.domainTextField.resignFirstResponder()
            },
            UIAction(title: "naver.com") { _ in
                self.domainMenuButton.setTitle("naver.com", for: .normal)
                self.domainMenuButton.isHidden = false
                self.domainTextField.isHidden = true
                self.domainTextField.resignFirstResponder()
            },
            UIAction(title: "daum.net") { _ in
                self.domainMenuButton.setTitle("daum.net", for: .normal)
                self.domainMenuButton.isHidden = false
                self.domainTextField.isHidden = true
                self.domainTextField.resignFirstResponder()
            },
            UIAction(title: "직접 입력") { _ in
                self.domainMenuButton.setTitle("", for: .normal)
                self.domainMenuButton.isHidden = true
                self.domainTextField.isHidden = false
                self.domainTextField.becomeFirstResponder()
            }
        ])
        domainMenuButton.showsMenuAsPrimaryAction = true
    }
    
    @objc private func textFieldDidChange() {
        validateForm()

        onInputChanged?(
            usernameTextField.text ?? "",
            fullEmail ?? "",
            passwordTextField.text ?? "",
            passwordConfirmTextField.text ?? "",
            termsRequiredView.isChecked
        )
    }


    
    /// SnapKit을 사용한 제약 조건 설정
    private func setupConstraints() {
        
        topBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        topTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        // MARK: - 닉네임 영역
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        /// 닉네임 입력 영역 StackView
        usernameVStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        /// 닉네임 입력 하단 Divider
        usernameDivider.snp.makeConstraints {
            $0.top.equalTo(usernameVStack.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        /// 닉네임 에러 라벨
        usernameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(usernameDivider.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        // MARK: - 이메일 영역
        /// 이메일 입력 StackView
        idVStack.snp.makeConstraints {
            $0.top.equalTo(usernameErrorLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        /// 이메일 입력 하단 Divider
        idDivider.snp.makeConstraints {
            $0.top.equalTo(idVStack.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        /// 이메일 에러 라벨
        idErrorLabel.snp.makeConstraints {
            $0.top.equalTo(idDivider.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        // MARK: - 비밀번호 영역
        /// 비밀번호 입력 StackView
        passwordVStack.snp.makeConstraints {
            $0.top.equalTo(idErrorLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        /// 비밀번호 입력 하단 Divider
        passwordDivider.snp.makeConstraints {
            $0.top.equalTo(passwordVStack.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        /// 비밀번호 에러 라벨
        passwordErrorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordDivider.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        // MARK: - 비밀번호 확인 영역
        /// 비밀번호 확인 StackView
        passwordConfirmVStack.snp.makeConstraints {
            $0.top.equalTo(passwordErrorLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        /// 비밀번호 확인 하단 Divider
        passwordConfirmDivider.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmVStack.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        /// 비밀번호 확인 에러 라벨
        passwordConfirmErrorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmDivider.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // MARK: - 약관 뷰 제약
        /// 약관 뷰 제약
        termsRequiredView.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmErrorLabel.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        termsOptionalView.snp.makeConstraints {
            $0.top.equalTo(termsRequiredView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // MARK: - 회원가입 버튼
        /// 회원가입 버튼
        signupButton.snp.remakeConstraints {
            $0.top.equalTo(termsOptionalView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    
    /// 이메일 주소 완성 문자열 반환 (prefix@domain)
    var fullEmail: String? {
        guard let prefix = idPrefixTextField.text, !prefix.isEmpty else { return nil }
        let domain: String? = domainTextField.isHidden ? domainMenuButton.title(for: .normal) : domainTextField.text
        guard let domainUnwrapped = domain, !domainUnwrapped.isEmpty else { return nil }
        return "\(prefix)@\(domainUnwrapped)"
    }
    
    private func validateForm() {
        let isUsernameValid = !(usernameTextField.text?.isEmpty ?? true)
        let isEmailValid = fullEmail != nil
        let isPasswordValid = isValidPassword(passwordTextField.text)
        let isPasswordConfirmed = passwordTextField.text == passwordConfirmTextField.text
        let isTermsAgreed = termsRequiredView.isChecked

        let isFormValid = isUsernameValid && isEmailValid && isPasswordValid && isPasswordConfirmed && isTermsAgreed

        signupButton.isEnabled = isFormValid
        signupButton.backgroundColor = isFormValid ? .brand : .lightGray
    }
    
    private func isValidPassword(_ text: String?) -> Bool {
        guard let text = text, text.count >= 8 else { return false }
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d\\S]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }

    private func setupBindings() {
        // 텍스트 필드 변경 시
        [usernameTextField, idPrefixTextField, domainTextField,
         passwordTextField, passwordConfirmTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        // 약관 체크 변경 시
        termsRequiredView.checkChangedHandler = { [weak self] _ in
            self?.validateForm()
        }
        
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        usernameCheckButton.addTarget(self, action: #selector(usernameCheckTapped), for: .touchUpInside)
        idCheckButton.addTarget(self, action: #selector(emailCheckTapped), for: .touchUpInside)

    }
    
    @objc private func signupButtonTapped() {
        onSignupButtonTapped?()
    }
    
    @objc private func usernameCheckTapped() {
        let nickname = usernameTextField.text ?? ""
        onUsernameCheckTapped?(nickname)
    }

    @objc private func emailCheckTapped() {
        let email = fullEmail ?? ""
        onEmailCheckTapped?(email)
    }


}
extension SignupView {

    func showUsernameError(_ message: String?, isValid: Bool) {
        showError(label: usernameErrorLabel, message: message, isValid: isValid)
    }

    func showEmailError(_ message: String?, isValid: Bool) {
        showError(label: idErrorLabel, message: message, isValid: isValid)
    }

    func showPasswordError(_ message: String?) {
        showError(label: passwordErrorLabel, message: message, isValid: false)
    }

    func showConfirmPasswordError(_ message: String?) {
        showError(label: passwordConfirmErrorLabel, message: message, isValid: false)
    }

    private func showError(label: UILabel, message: String?, isValid: Bool) {
        DispatchQueue.main.async {
            label.text = message
            label.textColor = isValid ? .systemGreen : .systemRed
            label.isHidden = (message == nil)
        }
    }
}
