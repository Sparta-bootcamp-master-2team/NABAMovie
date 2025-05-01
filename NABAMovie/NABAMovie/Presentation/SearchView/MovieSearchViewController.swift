//
//  MovieSearchViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/29/25.
//

import UIKit
import SnapKit

final class MovieSearchViewController: UIViewController {
    
    private weak var coordinator: SearchCoordinatorProtocol?

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .brand
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.setTextFieldColor(.systemBackground)
        return searchBar
    }()
    
    private let collectionView = MovieItemCollectionView()
    private let viewModel: MovieSearchViewModel
    
    init(viewModel: MovieSearchViewModel, coordinator: SearchCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) // 뷰 컨트롤러가 나타날 때 숨기기
        tabBarController?.tabBar.isHidden = false
    }
    private func setupUI() {
        [searchBar, collectionView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }
    

}
extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.collectionView.movieItemCollectionDataSource?.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .movieEntity(let movie):
            coordinator?.showMovieInfo(movie: movie)
        case .reservationEntity(_):
            break
        }
    }
}

// MARK: UISearchBarDelegate
extension MovieSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            do {
                let item = try await viewModel.fetchSearchItem(text: searchText)
                await MainActor.run {
                    collectionView.fetchCellItems(item: item)
                }
            } catch {
                print("UISearchBarDelegate ERROR")
                print(error.localizedDescription)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
