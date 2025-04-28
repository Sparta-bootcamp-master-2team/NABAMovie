//
//  MovieImageDTO.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//

import Foundation

struct MovieImageDTO: Decodable {
    let backdrops: [Backdrop]
}

// MARK: - Backdrop
struct Backdrop: Decodable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

extension MovieImageDTO {
    func toEntity() -> [MovieStillsEntity] {
        backdrops
            .prefix(10)
            .compactMap {
            guard let url = URL(string: TMDB.backDropBaseURL + $0.filePath) else { return nil }
            return MovieStillsEntity(imageURL: url)
        }
    }
}
