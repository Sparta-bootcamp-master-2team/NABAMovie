//
//  MovieRepositoryImpl.swift
//  NABAMovie
//
//  Created by 박주성 on 4/26/25.
//

import Foundation

final class MovieRepositoryImpl: MovieRepository {
    
    private let networkManager: MovieNetworkManager
    
    init(networkManager: MovieNetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchNowPlayingMoviesDetail() async throws -> [MovieEntity] {
        let dto = try await networkManager.fetchNowPlayingMovies()
        let nowPlayingMoviesDetail = try await fetchMoviesDetail(moviesID: dto.limitedIDs())
        return nowPlayingMoviesDetail.map { $0.toEntity() }
    }
    
    func fetchUpComingMoviesDetail() async throws -> [MovieEntity] {
        let dto = try await networkManager.fetchUpComingMovies()
        let nowPlayingMoviesDetail = try await fetchMoviesDetail(moviesID: dto.limitedIDs())
        return nowPlayingMoviesDetail.map { $0.toEntity() }
    }
    
    func fetchSearchMoviesDetail(for keyword: String) async throws -> [MovieEntity] {
        let dto = try await networkManager.fetchSearchMovies(keyword: keyword)
        let searchMoviesDetail = try await fetchMoviesDetail(moviesID: dto.toIDs())
        return searchMoviesDetail.map { $0.toEntity() }
    }
    
    private func fetchMoviesDetail(moviesID: [Int]) async throws -> [MovieDetailDTO] {
        return try await withThrowingTaskGroup(of: (Int, MovieDetailDTO).self) { group in
            var movies: [(Int, MovieDetailDTO)] = []
            
            for (index, movieID) in moviesID.enumerated() {
                group.addTask {
                    let movieDetail = try await self.networkManager.fetchMovieDetail(movieID: movieID)
                    return (index, movieDetail)
                }
            }
            
            for try await movie in group {
                movies.append(movie)
            }
            
            return movies
                .sorted { $0.0 < $1.0 }
                .map { $0.1 }
        }
    }
    
    func fetchMoviesStills(for movieID: Int) async throws -> [MovieStillsEntity] {
        let dto = try await networkManager.fetchMovieImages(movieID: movieID)
        return dto.toEntity()
    }
}
