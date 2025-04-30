//
//  FetchMovieStillsUseCase.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//

import Foundation

final class FetchMovieStillsUseCase {
    private let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(for movieID: Int) async -> Result<[MovieStillsEntity], Error> {
        do {
            let stills = try await repository.fetchMoviesStills(for: movieID)
            return .success(stills)
        } catch {
            return .failure(error)
        }
    }
}
