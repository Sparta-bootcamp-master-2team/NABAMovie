//
//  FetchHomeScreenMoviesUseCase.swift
//  NABAMovie
//
//  Created by 박주성 on 4/26/25.
//

import Foundation

final class FetchHomeScreenMoviesUseCase {
    private let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<([MovieEntity], [MovieEntity]), Error> {
        do {
            async let nowPlayingMovies = repository.fetchNowPlayingMoviesDetail()
            async let upcomingMovies = repository.fetchUpComingMoviesDetail()
            
            let (nowPlaying, upcoming) = try await (nowPlayingMovies, upcomingMovies)
            
            return .success((nowPlaying, upcoming))
        } catch {
            return .failure(error)
        }
    }
}
