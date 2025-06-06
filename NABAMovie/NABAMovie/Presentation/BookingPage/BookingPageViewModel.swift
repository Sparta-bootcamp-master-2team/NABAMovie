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
        self.setTimeList()
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
    let moviePrice = 12000
    let firstStartTime = "12:25"
    let restTime = 20
    
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
    var movieTimes = [String]()

    
    func createReservation() -> Reservation {
        return Reservation(
            reservationID: "",
            genre: movieDetail.genre,
            member: personnel,
            posterURL: movieDetail.posterImageURL,
            reservationTime: selectedTime,
            title: movieDetail.title
        )
    }

    /// 예약 실행
    func executeReservationTask(_ reservation: Reservation) {
        Task {
            do {
                let userId = try firebaseService.getCurrentUserId()
                let result = await makeReservationUseCase.execute(userId: userId, reservation: reservation)
                switch result {
                case .success:
                    print("예약 성공: \(reservation)")
                    await onSuccessReservation?(reservation)
                case .failure(let error):
                    print("예약 실패: \(error.localizedDescription)")
                }
            } catch {
                print("유저 ID 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    /// 시작시간 ~ 종료시간 으로 변환
    private func convertTimeToRange(startTime: String) -> String {
        let startTime = startTime
        let startHour = Int(startTime.split(separator: ":")[0])!
        let startMinute = Int(startTime.split(separator: ":")[1])!
        
        let runtimeHour = movieDetail.runtime / 60
        let runtimeMinute = movieDetail.runtime % 60
        
        let endHour = startHour + runtimeHour + (startMinute + runtimeMinute) / 60
        let endMinute = (startMinute + runtimeMinute) % 60
        
        let endTime = String(format: "%02d:%02d", endHour, endMinute)
        
        let timeRange = startTime + "~" + endTime
        
        return timeRange
    }
    
    /// 영화 시간 선택 버튼의 시간 정보 리스트 재설정
    private func setTimeList() {
        if movieDetail.runtime != 0 {
            self.movieTimes.append(convertTimeToRange(startTime: firstStartTime))
            let firstEndTime = movieTimes[0].split(separator: "~").last!
            
            self.movieTimes.append(convertTimeToRange(startTime: addRestTime(endTime: String(firstEndTime), restTime: restTime)))
            let secondEndTime = movieTimes[1].split(separator: "~").last!
            
            self.movieTimes.append(convertTimeToRange(startTime: addRestTime(endTime: String(secondEndTime), restTime: restTime)))
        } else {
            movieTimes =  ["12:25~15:25", "15:45~18:45", "19:05~22:05"]
        }
        print(movieTimes)
    }
    
    /// 쉬는 시간 추가 (현재 20분)
    private func addRestTime(endTime: String, restTime: Int) -> String {
        var hour = Int(endTime.split(separator: ":")[0])!
        var minute = Int(endTime.split(separator: ":")[1])!
        
        minute = minute + restTime % 60
        hour = hour + minute / 60
        
        let time = String(format: "%02d:%02d", hour, minute)
        
        return time
    }
}

private extension Int {
    var formattedWithComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
