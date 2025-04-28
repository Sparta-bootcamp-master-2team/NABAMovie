//
//  MovieRepository.swift
//  NABAMovie
//
//  Created by 박주성 on 4/27/25.
//

import Foundation

protocol MovieRepository {
    func fetchNowPlayingMoviesDetail() async throws -> [MovieEntity]
    func fetchUpComingMoviesDetail() async throws -> [MovieEntity]
    func fetchSearchMoviesDetail(for keyword: String) async throws -> [MovieEntity]
}
