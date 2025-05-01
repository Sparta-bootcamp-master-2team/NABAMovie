//
//  BookingPageViewController.swift
//  NABAMovie
//
//  Created by 정근호 on 4/29/25.
//

import UIKit
import SnapKit
import Kingfisher

class BookingPageViewController: UIViewController {
    
    var viewModel: BookingPageViewModel
    
    /// #333333
    private let paymentContainerViewColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    
    private var selectedTimeButton: UIButton?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var theaterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var timeSelectionButton1: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = UIColor(named: "brandColor")
        button.addTarget(self, action: #selector(timeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeSelectionButton2: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(timeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeSelectionButton3: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(timeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var screenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "screenImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var paymentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = paymentContainerViewColor
        return view
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 초기화", for: .normal)
        button.setImage(UIImage(systemName: "return.right"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var personnelTitle: UILabel = {
        let label = UILabel()
        label.text = "인원"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var personnelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(named: "brandColor")
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(minusPersonnel), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(named: "brandColor")
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(plusPersonnel), for: .touchUpInside)
        return button
    }()
    
    private lazy var personnelCountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "1"
        label.textColor = .white
        return label
    }()
    
    private lazy var totalPriceTitle: UILabel = {
        let label = UILabel()
        label.text = "총 가격"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.text = "12,000 원"
        label.textColor = .white
        return label
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("결제하기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(named: "brandColor")
        button.addTarget(self, action: #selector(proceedToPayment), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Initializers
    init(viewModel: BookingPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        paymentButton.layer.cornerRadius = paymentButton.frame.height / 2
        timeSelectionButton1.layer.cornerRadius = timeSelectionButton1.frame.height / 2
        timeSelectionButton2.layer.cornerRadius = timeSelectionButton2.frame.height / 2
        timeSelectionButton3.layer.cornerRadius = timeSelectionButton3.frame.height / 2
    }
    
    // MARK: - UI & Layout
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        view.addSubview(paymentContainerView)
        
        [titleLabel, theaterLabel, buttonStackView, screenImageView, notificationLabel].forEach {
            containerView.addSubview($0)
        }
        
        [timeSelectionButton1, timeSelectionButton2, timeSelectionButton3].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [resetButton, personnelTitle, personnelStackView, totalPriceTitle, totalPriceLabel, paymentButton].forEach {
            paymentContainerView.addSubview($0)
        }
        
        [minusButton, personnelCountLabel, plusButton].forEach {
            personnelStackView.addArrangedSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.bottom.equalTo(paymentContainerView.snp.top)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        paymentContainerView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom)
            $0.height.equalToSuperview().multipliedBy(0.3)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        theaterLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(theaterLabel.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
        }
        
        timeSelectionButton1.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(50)
        }
        
        timeSelectionButton2.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(50)
        }
        
        timeSelectionButton3.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(50)
        }
        
        screenImageView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
        }
        
        notificationLabel.snp.makeConstraints {
            $0.top.equalTo(screenImageView.snp.bottom).offset(28)
            $0.horizontalEdges.equalTo(buttonStackView)
        }
        
        resetButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        personnelTitle.snp.makeConstraints {
            $0.top.equalTo(resetButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        personnelStackView.snp.makeConstraints {
            $0.centerY.equalTo(personnelTitle)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        minusButton.snp.makeConstraints {
            $0.height.equalTo(22)
        }
        
        plusButton.snp.makeConstraints {
            $0.height.equalTo(22)
        }
        
        totalPriceTitle.snp.makeConstraints {
            $0.top.equalTo(personnelTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(personnelTitle.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        paymentButton.snp.makeConstraints {
            $0.top.equalTo(totalPriceTitle.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Action
    @objc private func timeButtonTapped(_ sender: UIButton) {
        viewModel.selectedTime = (sender.titleLabel?.text)!
        guard sender != selectedTimeButton else { return }
        
        selectedTimeButton?.backgroundColor = .clear
        selectedTimeButton?.layer.borderColor = UIColor.lightGray.cgColor
        selectedTimeButton?.setTitleColor(.black, for: .normal)
        
        sender.backgroundColor = UIColor(named: "brandColor")
        sender.layer.borderColor = UIColor.clear.cgColor
        sender.setTitleColor(.white, for: .normal)
        selectedTimeButton = sender
    }
    
    @objc private func resetButtonClicked() {
        viewModel.personnel = 1
    }
    
    @objc private func minusPersonnel() {
        if viewModel.personnel > 1 {
            viewModel.personnel -= 1
        }
    }
    
    @objc private func plusPersonnel() {
        viewModel.personnel += 1
    }
    
    @objc private func proceedToPayment() {
        let paymentAlert = UIAlertController(title: "결제하시겠습니까?", message: nil, preferredStyle: .alert)
        
        paymentAlert.addAction(
            UIAlertAction(title: "아니오", style: .destructive))
        
        paymentAlert.addAction(
            UIAlertAction(title: "네", style: .default, handler: { [weak self] _ in
                
                self?.viewModel.makeReservation()
                let completionAlert = UIAlertController(title: "결제 완료", message: "결제가 완료되었습니다.", preferredStyle: .alert)
                
                completionAlert.addAction(
                    UIAlertAction(title: "확인", style: .default))
                
                self?.present(completionAlert, animated: true)
            }))
        
        present(paymentAlert, animated: true)
    }
    
    
    // MARK: - Private Methods
    private func transformNotificationTexts() {
        let attributedText = NSMutableAttributedString()
        
        for text in viewModel.notificationTexts {
            let bullet = "·  "
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = (bullet as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 10, weight: .black)]).width
            
            let bulletAttr = NSAttributedString(string: bullet, attributes: [
                .font: UIFont.systemFont(ofSize: 10, weight: .black),
                .paragraphStyle: paragraphStyle
            ])
            let messageAttr = NSAttributedString(string: text + "\n", attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .paragraphStyle: paragraphStyle
            ])
            
            attributedText.append(bulletAttr)
            attributedText.append(messageAttr)
        }
        
        notificationLabel.attributedText = attributedText
    }
    
    private func transformTheaterText() {
        let attributedText = NSMutableAttributedString()
        
        let fullText = viewModel.theaterText
        guard let brandText = fullText.split(separator: " ").first else { return }
        let otherText = fullText.dropFirst(brandText.count)
        
        let brandAttr = NSAttributedString(string: String(brandText), attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ])
        let otherAttr = NSAttributedString(string: String(otherText), attributes: [
            .font: UIFont.systemFont(ofSize: 16)
        ])
        
        attributedText.append(brandAttr)
        attributedText.append(otherAttr)
        
        theaterLabel.attributedText = attributedText
    }
        
    private func configure() {
        titleLabel.text = viewModel.titleText
        theaterLabel.text = viewModel.theaterText
        notificationLabel.text = viewModel.notificationTexts.joined()
        
        transformTheaterText()
        transformNotificationTexts()
        
        timeSelectionButton1.setTitle(viewModel.movieTimes[0], for: .normal)
        timeSelectionButton2.setTitle(viewModel.movieTimes[1], for: .normal)
        timeSelectionButton3.setTitle(viewModel.movieTimes[2], for: .normal)

        // 기본 설정 시간 첫번째로 설정
        selectedTimeButton = timeSelectionButton1
        viewModel.selectedTime = (selectedTimeButton?.titleLabel!.text)!
        
        viewModel.onPersonnelChanged = { [weak self] count, _ in
            self?.personnelCountLabel.text = "\(count)"
        }
        
        viewModel.onTotalPriceChanged = { [weak self] total in
            self?.totalPriceLabel.text = total
        }
    }
}
