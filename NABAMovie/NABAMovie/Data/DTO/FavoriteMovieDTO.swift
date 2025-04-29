//
//  FavoriteMovieDTO.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import Foundation

struct FavoriteMovieDTO: Codable {
    let movieID: Int
    let title: String
    let genre: [String]
    let director: String?
    let actors: [String]
    let releaseDate: String?
    let runtime: Int
    let voteAverage: Double
    let voteCount: Int
    let overview: String?
    let posterImageURL: String?
    let certification: String?

    func toEntity() -> MovieEntity {
        return MovieEntity(
            movieID: movieID,
            title: title,
            genre: genre,
            director: director,
            actors: actors,
            releaseDate: releaseDate,
            runtime: runtime,
            voteAverage: voteAverage,
            voteCount: voteCount,
            overview: overview,
            posterImageURL: posterImageURL,
            certification: certification
        )
    }
}
extension FavoriteMovieDTO {
    init(entity: MovieEntity) {
        self.movieID = entity.movieID
        self.title = entity.title
        self.genre = entity.genre
        self.director = entity.director
        self.actors = entity.actors
        self.releaseDate = entity.releaseDate
        self.runtime = entity.runtime
        self.voteAverage = entity.voteAverage
        self.voteCount = entity.voteCount
        self.overview = entity.overview
        self.posterImageURL = entity.posterImageURL
        self.certification = entity.certification
    }
}
