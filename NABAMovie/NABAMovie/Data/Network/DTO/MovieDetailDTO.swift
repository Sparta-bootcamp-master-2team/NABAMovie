//
//  MovieDetailDTO.swift
//  NABAMovie
//
//  Created by 박주성 on 4/25/25.
//

import Foundation

// MARK: - MovieDetailDTO

struct MovieDetailDTO: Decodable {
    let id: Int
    let title: String
    let genres: [Genre]
    let credits: Credits
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let runtime: Int
    let voteAverage: Double
    let voteCount: Int
    let releaseDates: ReleaseDates?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres
        case credits
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDates = "release_dates"
    }
}

// MARK: - Genre

struct Genre: Decodable {
    let id: Int
    let name: String
}

// MARK: - Credits

struct Credits: Decodable {
    let cast, crew: [Cast]
}

struct Cast: Decodable {
    let name: String
    let job: String?
}

// MARK: - ReleaseDates

struct ReleaseDates: Decodable {
    let results: [ReleaseDatesResult]?
}

struct ReleaseDatesResult: Decodable {
    let iso3166_1: String?
    let releaseDates: [ReleaseDate]?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case releaseDates = "release_dates"
    }
}

struct ReleaseDate: Codable {
    let certification: String?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case certification
        case releaseDate = "release_date"
    }
}

// MARK: - Extension

extension MovieDetailDTO {
    func toEntity() -> MovieEntity {
        // 장르 이름만 3개까지만 추출
        let genreNames = genres.prefix(3).map { $0.name }
        
        // 감독 찾기
        let director = credits.crew.first(where: { $0.job == "Director" })?.name
        
        // 출연 배우 3명까지만 추출
        let actorsName = credits.cast.prefix(3).compactMap { $0.name }
        
        // 평점 소수점 둘째자리까지만
        let roundedVoteAverage = Double(round(100 * voteAverage) / 100)
        
        // 포스터 URL
        let fullPosterURL: String? = {
            guard !posterPath.isEmpty else { return nil }
            return TMDB.posterBaseURL + posterPath
        }()
        
        // 관람등급 필터링
        let certification = {
            let cert = releaseDates?.results?
                .first(where: { $0.iso3166_1 == "KR" })?
                .releaseDates?
                .first?
                .certification
            return (cert?.isEmpty == true) ? nil : cert
        }()
        
        return MovieEntity(
            movieID: id,
            title: title,
            genre: genreNames,
            director: director ?? "감독 정보 없음",
            actors: actorsName,
            releaseDate: findFormattedReleaseDate(from: releaseDates?.results) ?? "출시일 정보 없음",
            runtime: runtime,
            voteAverage: roundedVoteAverage,
            voteCount: voteCount,
            overview: overview.isEmpty ? "줄거리 정보 없음" : overview,
            posterImageURL: fullPosterURL ?? "",
            certification: certification ?? "관람 등급 정보 없음",
        )
    }
    
    private func findFormattedReleaseDate(from releaseDates: [ReleaseDatesResult]?) -> String? {
        guard let dateString = releaseDates?
            .first(where: { $0.iso3166_1 == "KR" })?
            .releaseDates?
            .first?
            .releaseDate else {
            return nil
        }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
