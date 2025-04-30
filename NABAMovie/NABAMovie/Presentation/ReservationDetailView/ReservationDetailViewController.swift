//
//  ReservationDetailViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import UIKit
import SnapKit

final class ReservationDetailViewController: UIViewController {

    private let reservationDetailView = ReservationDetailView()
    private let viewModel: ReservationDetailViewModel
    private let reservationItem: Reservation
    
    init(viewModel: ReservationDetailViewModel, reservationItem: Reservation) {
        self.viewModel = viewModel
        self.reservationItem = reservationItem
        reservationDetailView.configure(model: self.reservationItem)
        super.init(nibName: nil, bundle: nil)
        bind()
        self.reservationDetailView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews([reservationDetailView])
        configureLayout()
    }
    
    private func bind() {
        viewModel.failedCancelReservation = { [unowned self] in
            self.showAlert(title: "오류", message: "예매 취소 실패하였습니다.\n잠시후 다시 시도해주세요.")
        }
        viewModel.successCancelReservation = { [unowned self] in
            self.showAlert(title: "예매 취소", message: "성공적으로 예매 취소되었습니다.")
        }
    }
    
    private func configureLayout() {
        reservationDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension ReservationDetailViewController: ReservationDetailViewDelegate {
    func reservationCancelButtonTapped() {
        self.showAlert(title: "취소 확인", message: "예매 취소하시겠습니까?", cancellable: true) { [unowned self] in
            viewModel.cancelReservation(userID: "임시문자열 (수정에정)", reservationID: reservationItem.reservationID)
        }
    }
}
