//
//  ReservationDetailViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import UIKit
import SnapKit

class ReservationDetailViewController: UIViewController {

    private let reservationDetailView = ReservationDetailView()
    private let viewModel: ReservationDetailViewModel
    private let reservationItem: Reservation
    
    init(viewModel: ReservationDetailViewModel, reservationItem: Reservation) {
        self.viewModel = viewModel
        self.reservationItem = reservationItem
        reservationDetailView.configure(model: self.reservationItem)
        super.init(nibName: nil, bundle: nil)
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
    
    private func configureLayout() {
        reservationDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
