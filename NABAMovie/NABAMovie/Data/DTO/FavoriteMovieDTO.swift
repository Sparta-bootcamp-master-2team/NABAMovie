//
//  FavoriteMovieDTO.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import Foundation

// MARK: - FavoriteMovieDTO
/// Firestore에 저장하거나 불러올 영화 데이터 모델 (DTO)
struct FavoriteMovieDTO: Codable {
    let movieID: Int            // 영화 ID
    let title: String           // 영화 제목
    let genre: [String]         // 장르 리스트
    let director: String?       // 감독
    let actors: [String]        // 배우 리스트
    let releaseDate: String?    // 개봉일
    let runtime: Int            // 상영 시간 (분)
    let voteAverage: Double     // 평점
    let voteCount: Int          // 평가 수
    let overview: String?       // 줄거리
    let posterImageURL: String? // 포스터 이미지 URL
    let certification: String?  // 관람 등급

    // MARK: - Entity 변환
    /// DTO를 앱 내부 모델(MovieEntity)로 변환하는 메소드
    /// Firestore에서 FavoriteMovieDTO로 가져온 데이터를 MovieEntity로 변환해서 앱 화면에 뿌릴 때 사용
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

// MARK: - FavoriteMovieDTO Extension
extension FavoriteMovieDTO {
    /// 앱 내부 모델(MovieEntity)을 DTO로 변환하는 이니셜라이저
    /// 사용자가 앱 안에서 영화를 선택하거나 찜 버튼을 누를 때 MovieEntity를 FavoriteMovieDTO로 변환해서 Firestore에 저장할 때 사용
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

