//
//  MovieListViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/30/25.
//

import UIKit
import SnapKit

class MovieListViewController: UIViewController {
    
    private weak var coordinator: MyPageCoordinatorProtocol?
    
    private let collectionView = MovieItemCollectionView()
    private let viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel, coordinator: MyPageCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubviews([collectionView])
        configureLayout()
        collectionView.fetchCellItems(item: viewModel.item)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) // 뷰 컨트롤러가 나타날 때 숨기기
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .secondarySystemBackground
        view.subviews.forEach {
            $0.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = .clear
        view.subviews.forEach {
            $0.isHidden = true
        }
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.collectionView.movieItemCollectionDataSource?.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .movieEntity(let movieEntity):
            coordinator?.showMovieInfo(movie: movieEntity)
        case .reservationEntity(let reservation):
            coordinator?.showReservationDetail(movie: reservation)
        }
    }
}
