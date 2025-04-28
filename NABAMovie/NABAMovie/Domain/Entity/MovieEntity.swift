//
//  MovieEntity.swift
//  NABAMovie
//
//  Created by 박주성 on 4/26/25.
//

import Foundation

struct MovieEntity {
    let movieID: Int                // 영화 ID
    let title: String               // 영화 제목
    let genre: [String]             // 장르
    let director: String?           // 영화 감독
    let actors: [String]            // 출연 배우 (3명)
    let releaseDate: String?        // 영화 개봉일
    let runtime: Int                // 상영시간
    let voteAverage: Double         // 평점(소수점 두자리만 사용)
    let voteCount: Int              // 평가 인원 수
    let overview: String?           // 줄거리
    let posterImageURL: String      // 포스터 이미지 URL
    let certification: String?      // 관람 등급
}
