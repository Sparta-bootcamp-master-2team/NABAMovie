//
//  MovieSearchViewController.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/29/25.
//

import UIKit
import SnapKit

final class MovieSearchViewController: UIViewController {

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private let collectionView: MovieItemCollectionView
    private let viewModel: MovieSearchViewModel
    
    init(collectionView: MovieItemCollectionView, viewModel: MovieSearchViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
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
}
