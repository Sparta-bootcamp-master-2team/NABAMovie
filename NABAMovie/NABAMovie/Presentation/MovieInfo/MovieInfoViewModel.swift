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
    
    var stillImages: [URL] = []
    var firstStillImageUrl: URL?
    
    var isFavorite: Bool = false
    
    private let usecase = FetchMovieStillsUseCase(repository: MovieRepositoryImpl(networkManager: MovieNetworkManager()))
    
    init(movieDetail: MovieEntity) {
        self.movieDetail = movieDetail
    }
    
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
            let result = await usecase.execute(for: movieDetail.movieID)
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
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
        }
        
    }
}
