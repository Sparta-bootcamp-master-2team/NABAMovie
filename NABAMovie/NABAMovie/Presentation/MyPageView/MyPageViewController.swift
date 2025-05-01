//
//  MyPageViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {
    
    private weak var coordinator: MyPageCoordinator?
    
    private let headerView = HeaderView()
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    
    init(viewModel: MyPageViewModel, coordinator: MyPageCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        myPageView.delegate = self
        bind()
    }   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false) // 뷰 컨트롤러가 나타날 때 숨기기
        tabBarController?.tabBar.isHidden = false
        viewModel.fetchMyPageItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews([headerView, myPageView])
        view.backgroundColor = .white
        configureLayout()
    }
    
    private func configureLayout() {
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalToSuperview()
        }
        
        myPageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(headerView.snp.bottom)
        }
    }
    // ViewModel 클로저 바인딩
    private func bind() {
        viewModel.successFetchMyPageItem = { [weak self] reservations, favorites  in
            self?.myPageView.fetchItems(reservations: reservations, favorites: favorites)
            self?.viewModel.savePageItems(reseravations: reservations, favorites: favorites)
        }
        viewModel.failedFetchMyPageItem = { [weak self] in
            self?.showAlert(title: "오류", message: "내 정보 불러오기 실패하였습니다.\n네트워크를 확인해주세요.")
        }
        viewModel.failedLogout = { [weak self] in
            self?.showAlert(title: "로그아웃 실패", message: "로그아웃에 실패하였습니다.")
        }
    }
}

// MARK: MyPageViewDelegate
extension MyPageViewController: MyPageViewDelegate {
    // 예매 내역 더보기 버튼 클릭 시
    func reservationMoreButtonTapped() {
        coordinator?.showMore(item: self.viewModel.reservations)
    }
    // 찜 목록 더보기 버튼 클릭 시
    func favoriteMoreButtonTapped() {
        coordinator?.showMore(item: self.viewModel.favorites)
    }
    
    // 로그아웃 버튼 클릭 시
    func logoutButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", cancellable: true, completionHandler: {
                self?.viewModel.logout()
            })
        }
    }
    
    // 셀 선택 시
    func didSelectedItem(item: any CellConfigurable) {
        // 찜 항목 셀 선택한 경우
        if item is MovieEntity {
            let item = item as! MovieEntity
            coordinator?.showMovieInfo(movie: item)
        }
        // 예매 내역 셀 선택한 경우
        if item is Reservation {
            let item = item as! Reservation
            let usecase = CancelReservationUseCase(repository: ReservationRepositoryImpl(firebaseService: FirebaseService()))
            let reservationDetailViewModel = ReservationDetailViewModel(cancelReservationUseCase: usecase, reservationItem: item)
            let reservationDetailVC = ReservationDetailViewController(viewModel: reservationDetailViewModel)
            self.present(reservationDetailVC, animated: true)
        }
    }
    
}
