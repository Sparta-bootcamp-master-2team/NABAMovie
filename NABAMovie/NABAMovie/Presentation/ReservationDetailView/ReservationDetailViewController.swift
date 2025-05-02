//
//  ReservationDetailViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import UIKit
import SnapKit

final class ReservationDetailViewController: UIViewController {
    
    private weak var coordinator: MyPageCoordinator?

    private let reservationDetailView = ReservationDetailView()
    private let viewModel: ReservationDetailViewModel
    
    init(
        viewModel: ReservationDetailViewModel,
        coordinator: MyPageCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        reservationDetailView.configure(model: viewModel.reservationItem)
        super.init(nibName: nil, bundle: nil)
        bind()
        self.reservationDetailView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubviews([reservationDetailView])
        configureLayout()
    }
    
    private func configureLayout() {
        reservationDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // ViewModel 바인딩
    private func bind() {
        viewModel.failedCancelReservation = { [unowned self] in
            self.showAlert(title: "오류", message: "예매 취소 실패하였습니다.\n잠시후 다시 시도해주세요.")
        }
        viewModel.successCancelReservation = { [unowned self] in
            self.showAlert(title: "예매 취소", message: "성공적으로 예매 취소되었습니다.") {
                self.coordinator?.didCancelReservation()
            }
        }
    }
}

// 예매버튼 취소 클릭 Delegate
extension ReservationDetailViewController: ReservationDetailViewDelegate {
    func reservationCancelButtonTapped() {
        self.showAlert(title: "취소 확인", message: "예매 취소하시겠습니까?", cancellable: true) { [unowned self] in
            viewModel.cancelReservation()
        }
    }
}
