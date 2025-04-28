//
//  SearchMovieDTO.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//


import Foundation

struct SearchMovieDTO: Decodable {
    let results: [SearchMovieIds]
}

struct SearchMovieIds: Decodable {
    let id: Int
}

extension SearchMovieDTO {
    func toIDs() -> [Int] {
        results.map { $0.id }
    }
}
