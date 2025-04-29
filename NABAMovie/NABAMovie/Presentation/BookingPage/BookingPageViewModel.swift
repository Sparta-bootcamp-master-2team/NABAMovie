//
//  BookingPageViewModel.swift
//  NABAMovie
//
//  Created by 정근호 on 4/29/25.
//

import Foundation

class BookingPageViewModel {
    
    private let movieDetail: MovieEntity
    
    let theaterText = "Zep 내일배움캠프 iOS 6기 매니저관"
    let notificationTexts = ["· 주차 공간이 혼잡하오니 여유시간을 두고 대중교통 이용 부탁드립니다.",
                             "· 입장 지연에 따른 관람 불편을 최소화하기 위해 본 영화는 10분 후 상영이 시작됩니다."]
    
    var onPersonnelChanged: ((Int, String) -> Void)?
    var onTotalPriceChanged: ((String) -> Void)?
    
    let moviePrice = 12000
    var personnel = 1 {
        didSet {
            let total = (moviePrice * personnel).formattedWithComma + " 원"
            onPersonnelChanged?(personnel, total)
            onTotalPriceChanged?(total)
        }
    }
    
    var totalPriceText: String = 12000.formattedWithComma + " 원"
    
    init(movieDetail: MovieEntity) {
        self.movieDetail = movieDetail
    }
    
    var titleText: String {
        movieDetail.title
    }
}

private extension Int {
    var formattedWithComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
