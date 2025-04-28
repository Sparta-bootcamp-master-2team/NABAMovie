//
//  NowPlayingDTO.swift
//  NABAMovie
//
//  Created by 박주성 on 4/25/25.
//

import Foundation

struct NowPlayingMovieDTO: Decodable {
    let results: [NowPlayingMoviesID]
}

struct NowPlayingMoviesID: Decodable {
    let id: Int
}

extension NowPlayingMovieDTO {
    func limitedIDs(limit: Int = 10) -> [Int] {
        results.prefix(limit).map { $0.id }
    }
}
