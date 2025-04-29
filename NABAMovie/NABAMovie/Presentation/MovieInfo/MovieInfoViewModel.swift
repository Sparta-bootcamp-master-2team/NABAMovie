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
    
    var stillImages: [URL] = []
    
    private let usecase = FetchMovieStillsUseCase(repository: MovieRepositoryImpl(networkManager: MovieNetworkManager()))
    
    func setStillImages(completion: @escaping () -> Void) {
        Task {
            let result = await usecase.execute(for: 1197306)
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
    
    // MOCK DATA
    let movieImage = UIImage(named: "mockPoster")
    let title = "어벤져스: 인피니티 워"
    let info = "2022﹒2시간 30분﹒액션, SF"
    let rating = 4.8
    let age = 12
    let director = "Anthony Russo, Joe Russo"
    let cast = "Robert Downey Jr., Chris Hemsworth, Chris Evans"
    let description = "As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos."
    var isFavorite: Bool = false
    
}
