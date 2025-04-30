//
//  MyPageViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {
    
    private let headerView = HeaderView()
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        }
        viewModel.failedFetchMyPageItem = { [weak self] in
            self?.showAlert(title: "오류", message: "내 정보 불러오기 실패하였습니다.\n네트워크를 확인해주세요.")
        }
    }
}
