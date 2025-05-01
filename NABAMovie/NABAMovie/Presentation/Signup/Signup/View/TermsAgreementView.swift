//
//  TermsAgreementView.swift
//  NABAMovie
//
//  Created by 양원식 on 4/30/25.
//

import UIKit
import SnapKit

final class TermsAgreementView: UIView {

    // MARK: - Callback
    /// 체크 상태 변경 시 외부에 알리기 위한 핸들러
    var checkChangedHandler: ((Bool) -> Void)?

    // MARK: - Properties

    private let isRequired: Bool
    private let contentText: String

    private var isExpanded: Bool = false {
        didSet {
            contentLabel.isHidden = !isExpanded
            detailButton.setTitle(isExpanded ? "내용 숨기기" : "내용 보기", for: .normal)

            contentLabel.snp.updateConstraints {
                $0.height.equalTo(isExpanded ? contentLabel.intrinsicContentSize.height : 0)
            }

            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        }
    }

    private(set) var isChecked: Bool = false {
        didSet {
            updateCheckButtonImage()
            checkChangedHandler?(isChecked)  // ✅ 상태가 바뀔 때 콜백 호출
        }
    }

    // MARK: - UI Components

    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = .brand
        button.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()

    private let detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("내용 보기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        return button
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [checkButton, titleLabel, UIView(), detailButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    // MARK: - Init

    init(title: String, isRequired: Bool, content: String) {
        self.isRequired = isRequired
        self.contentText = content
        super.init(frame: .zero)

        titleLabel.text = (isRequired ? "(필수) " : "(선택) ") + title
        contentLabel.text = content
        detailButton.addTarget(self, action: #selector(toggleContent), for: .touchUpInside)

        addSubview(hStack)
        addSubview(contentLabel)
        addSubview(divider)

        setupConstraints()
        updateCheckButtonImage()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout

    private func setupConstraints() {
        hStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }

        divider.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    // MARK: - Actions

    @objc private func toggleContent() {
        isExpanded.toggle()
    }

    @objc private func toggleCheck() {
        isChecked.toggle()
    }

    private func updateCheckButtonImage() {
        let imageName = isChecked ? "checkmark.circle.fill" : "checkmark.circle"
        checkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
