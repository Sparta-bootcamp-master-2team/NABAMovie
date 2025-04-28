//
//  FetchSearchMoviesUseCase.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//

import Foundation

final class FetchSearchMoviesUseCase {
    let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(for keyword: String) async -> Result<[MovieEntity], Error> {
        do {
            let searchResults = try await repository.fetchSearchMoviesDetail(for: keyword)
            return .success(searchResults)
        } catch {
            return .failure(error)
        }
    }
}
