//
//  BookingPageViewModel.swift
//  NABAMovie
//
//  Created by 정근호 on 4/29/25.
//

import Foundation

class BookingPageViewModel {
        
    private let firebaseService = FirebaseService()

    private let movieDetail: MovieEntity
    private let makeReservationUseCase: MakeReservationUseCase
    
    init(movieDetail: MovieEntity, useCase: MakeReservationUseCase) {
        self.movieDetail = movieDetail
        self.makeReservationUseCase = useCase
    }
    
    // callBack
    var onPersonnelChanged: ((Int, String) -> Void)?
    var onTotalPriceChanged: ((String) -> Void)?
    var onSelectedTimeChanged: ((String) -> Void)?
    var onSuccessReservation: (@MainActor (Reservation) -> Void)?
    
    // rawValue
    let theaterText = "Zep 내일배움캠프 iOS 6기 매니저관"
    let notificationTexts = [
        "주차 공간이 혼잡하오니 여유시간을 두고 대중교통 이용 부탁드립니다.",
        "입장 지연에 따른 관람 불편을 최소화하기 위해 본 영화는 10분 후 상영이 시작됩니다."
    ]
    let movieTimes = ["12:25", "15:55", "18:35"]
    let moviePrice = 12000
    
    // 예약 페이지 변수
    var personnel = 1 {
        didSet {
            let total = (moviePrice * personnel).formattedWithComma + " 원"
            onPersonnelChanged?(personnel, total)
            onTotalPriceChanged?(total)
        }
    }
    var selectedTime = ""
    var titleText: String {
        movieDetail.title
    }

    /// 예약 실행
    func makeReservation() {
        let reservation = Reservation(
            reservationID: "",
            genre: movieDetail.genre,
            member: personnel,
            posterURL: movieDetail.posterImageURL,
            reservationTime: convertTimeToRange(startTime: selectedTime),
            title: movieDetail.title)
        Task {
            let userId = try firebaseService.getCurrentUserId()
            let result = await makeReservationUseCase.execute(userId: userId, reservation: reservation)
            switch result {
            case .success(_):
                print("예약 성공: \(reservation)")
                await onSuccessReservation?(reservation)
            case .failure(let error):
                print("예약 실패: \(error.localizedDescription)")
            }
        }
    }
    
    /// 시작시간 ~ 종료시간 으로 변환
    private func convertTimeToRange(startTime: String) -> String {
        let startHour = Int(startTime.split(separator: ":")[0])!
        let startMinute = Int(startTime.split(separator: ":")[1])!
        
        let runtimeHour = movieDetail.runtime / 60
        let runtimeMinute = movieDetail.runtime % 60
        
        let endHour = startHour + runtimeHour + (startMinute + runtimeMinute) / 60
        let endMinute = (startMinute + runtimeMinute) % 60
        
        let endTime = String(format: "%02d:%02d", endHour, endMinute)
        
        let timeRange = startTime + " ~ " + endTime
        
        return timeRange
    }
}

private extension Int {
    var formattedWithComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
