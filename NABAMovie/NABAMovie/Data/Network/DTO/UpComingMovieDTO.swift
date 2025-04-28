//
//  UpComingMovieDTO.swift
//  NABAMovie
//
//  Created by 박주성 on 4/25/25.
//

import Foundation

struct UpComingMovieDTO: Decodable {
    let results: [UpComingMoviesID]
}

struct UpComingMoviesID: Decodable {
    let id: Int
}

extension UpComingMovieDTO {
    func limitedIDs(limit: Int = 10) -> [Int] {
        results.prefix(limit).map { $0.id }
    }
}
