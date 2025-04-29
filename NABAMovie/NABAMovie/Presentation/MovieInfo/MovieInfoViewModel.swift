//
//  MovieInfoViewModel.swift
//  NABAMovie
//
//  Created by 정근호 on 4/28/25.
//

import Foundation
import UIKit
import Kingfisher

class MovieInfoViewModel {
    
    let movieDetail: MovieEntity
    
    var stillImages: [URL] = []
    
    var isFavorite: Bool = false
    
    private let usecase = FetchMovieStillsUseCase(repository: MovieRepositoryImpl(networkManager: MovieNetworkManager()))
    
    init(movieDetail: MovieEntity) {
        self.movieDetail = movieDetail
    }
    
    var titleText: String {
        movieDetail.title
    }
    
    var posterURL: URL? {
        guard let posterURLString = movieDetail.posterImageURL else { return nil }
        return URL(string: posterURLString)
    }
    
    var infoText: String {
        let runtime = "\(Int(movieDetail.runtime) / 60)시간 \(Int(movieDetail.runtime) % 60)분"
        return "\(movieDetail.releaseDate!) · \(runtime) · \(movieDetail.genre.joined(separator: ", "))"
    }
    
    var voteAverageText: String {
        String(format: "%.1f", movieDetail.voteAverage)
    }
    
    var certificationText: String {
        movieDetail.certification ?? "정보 없음"
    }
    
    var directorText: String {
        movieDetail.director ?? "정보 없음"
    }
    
    var castText: String {
        movieDetail.actors.joined(separator: ", ")
    }
    
    var overviewText: String {
        movieDetail.overview ?? "정보 없음"
    }
    
    func setStillImages(completion: @escaping () -> Void) {
        Task {
            let result = await usecase.execute(for: movieDetail.movieID)
            switch result {
            case .success(let movies):
                print(movies.count)
                stillImages = movies.map { $0.imageURL }
                await MainActor.run {
                    completion()
                }
            case .failure(let error):
                print("에러 발생: \(error.localizedDescription)")
            }
        }
    }
}
