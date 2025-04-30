//
//  MovieSearchViewModel.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/29/25.
//

import Foundation

final class MovieSearchViewModel {
    private let fetchSearchUseCase: FetchSearchMoviesUseCase
    
    init(fetchSearchUseCase: FetchSearchMoviesUseCase) {
        self.fetchSearchUseCase = fetchSearchUseCase
    }
    // 키워드 영화 API 호출
    func fetchSearchItem(text: String) async throws -> [MovieEntity] {
        return try await fetchSearchUseCase.execute(for: text).get()
    }
}
