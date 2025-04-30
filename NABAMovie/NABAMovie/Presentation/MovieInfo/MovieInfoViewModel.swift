//
//  MovieInfoViewModel.swift
//  NABAMovie
//
//  Created by 정근호 on 4/28/25.
//

import Foundation
import UIKit

final class MovieInfoViewModel {
    
    let movieDetail: MovieEntity
    
    private let firebaseService = FirebaseService()
    private let movieStillsUseCase: FetchMovieStillsUseCase
    private let addFavoriteMovieUseCase: AddFavoriteMovieUseCase
    private let removeFavoriteMovieUseCase: RemoveFavoriteMovieUseCase
    
    init(movieDetail: MovieEntity, movieStillsUseCase: FetchMovieStillsUseCase, addFavoriteMovieUseCase: AddFavoriteMovieUseCase, removeFavoriteMovieUseCase: RemoveFavoriteMovieUseCase) {
        self.movieDetail = movieDetail
        self.movieStillsUseCase = movieStillsUseCase
        self.addFavoriteMovieUseCase = addFavoriteMovieUseCase
        self.removeFavoriteMovieUseCase = removeFavoriteMovieUseCase
    }
    
    var stillImages: [URL] = []
    var firstStillImageUrl: URL?
    
    var isFavorite: Bool = false

    var titleText: String {
        movieDetail.title
    }
        
    var infoText: String {
        let runtime = "\(Int(movieDetail.runtime) / 60)시간 \(Int(movieDetail.runtime) % 60)분"
        return "\(movieDetail.releaseDate) · \(runtime) · \(movieDetail.genre.joined(separator: ", "))"
    }
    
    var voteAverageText: String {
        String(format: "%.1f", movieDetail.voteAverage)
    }
    
    var certificationText: String {
        movieDetail.certification
    }
    
    var directorText: String {
        movieDetail.director
    }
    
    var castText: String {
        movieDetail.actors.joined(separator: ", ")
    }
    
    var overviewText: String {
        movieDetail.overview
    }
    
    /// 스틸컷 받아오기
    func setStillImages(completion: @escaping () -> Void) {
        Task {
            let result = await movieStillsUseCase.execute(for: movieDetail.movieID)
            await MainActor.run {
                switch result {
                case .success(let movies):
                    print(movies.count)
                    // 스틸컷 저장
                    stillImages = movies.map { $0.imageURL }
                    // 첫 번째 스틸컷 저장
                    firstStillImageUrl = stillImages.first
                    completion()
                case .failure(let error):
                    print("스틸 컷 저장 에러: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func addFavoriteMovie() {
        Task {
            let userId = try firebaseService.getCurrentUserId()
            let result = await addFavoriteMovieUseCase.execute(userId: userId, movie: movieDetail)
            switch result {
            case .success(_):
                print("찜 추가 성공")
            case .failure(let error):
                print("찜 추가 에러: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFavoriteMovie() {
        Task {
            let userId = try firebaseService.getCurrentUserId()
            let result = await removeFavoriteMovieUseCase.execute(userID: userId, movieID: movieDetail.movieID)
            switch result {
            case .success(_):
                print("찜 삭제 성공")
            case .failure(let error):
                print("찜 삭제 에러: \(error.localizedDescription)")
            }
        }
    }
}
