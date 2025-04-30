//
//  HomeViewModel.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//

import Foundation

final class HomeViewModel {
    
    typealias State = MainViewState
    typealias Action = MainViewAction
    
    enum MainViewState {
        case HomeScreenMovies(([MovieEntity], [MovieEntity]))
        case networkError(Error)
    }
    
    enum MainViewAction {
        case fetch
    }

    // MARK: - Properties
    
    var state: State {
        didSet {
            Task { @MainActor in
                onStateChange?(state)
            }
        }
    }
    
    var action: ((Action) -> Void)?
    var onStateChange: ((State) -> Void)?
    
    private let usecase: FetchHomeScreenMoviesUseCase
    
    // MARK: - Initializer
    
    init(usecase: FetchHomeScreenMoviesUseCase) {
        self.usecase = usecase
        self.state = .HomeScreenMovies(([], []))
        bindAction()
    }
    
    // MARK: - Action Handling

    private func bindAction() {
        self.action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .fetch:
                self.performFetch()
            }
        }
    }
    
    private func performFetch() {
        Task {
            let result = await usecase.execute()
            
            switch result {
            case .success(let (nowPlaying, upComing)):
                state = .HomeScreenMovies((nowPlaying, upComing))
            case .failure(let error):
                state = .networkError(error)
            }
        }
    }
}
