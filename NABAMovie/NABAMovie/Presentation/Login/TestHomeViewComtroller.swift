//
//  TestHomeViewComtroller.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import UIKit
import SnapKit
import FirebaseAuth

final class TestHomeViewController: UIViewController {

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    private let userInfoLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    private let reservationsLabel = UILabel()
    private let favoritesLabel = UILabel()

    // MARK: - Services

    private let firebaseService = FirebaseService()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchAllUserData()
        setupActions()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 24
        contentView.alignment = .fill
        contentView.distribution = .fill
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()

        }

        // User Info Label
        userInfoLabel.font = .systemFont(ofSize: 18)
        userInfoLabel.numberOfLines = 0
        userInfoLabel.textAlignment = .center
        contentView.addArrangedSubview(userInfoLabel)

        // Logout Button
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius = 8
        logoutButton.snp.makeConstraints { $0.height.equalTo(44) }
        contentView.addArrangedSubview(logoutButton)

        // Reservations Label
        reservationsLabel.font = .systemFont(ofSize: 16)
        reservationsLabel.numberOfLines = 0
        reservationsLabel.textAlignment = .left
        contentView.addArrangedSubview(reservationsLabel)

        // Favorites Label
        favoritesLabel.font = .systemFont(ofSize: 16)
        favoritesLabel.numberOfLines = 0
        favoritesLabel.textAlignment = .left
        contentView.addArrangedSubview(favoritesLabel)
    }

    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }

    // MARK: - Fetch Data

    private func fetchAllUserData() {
        Task {
            do {
                let userId = try firebaseService.getCurrentUserId()
                let user = try await firebaseService.fetchUser(uid: userId)
                let reservations = try await firebaseService.fetchReservations(for: userId)
                let favorites = try await firebaseService.fetchFavoriteMovies(for: userId)

                let reservationDetails = reservations.map {
                    """
                    [\($0.title)]
                    - 예약 시간: \($0.reservationTime)
                    - 인원: \($0.member)명
                    - 장르: \($0.genre.joined(separator: ", "))
                    - 포스터: \($0.posterURL)
                    """
                }.joined(separator: "\n\n")

                let favoriteDetails = favorites.map {
                    """
                    [\($0.title)]
                    - 장르: \($0.genre.joined(separator: ", "))
                    - 감독: \($0.director ?? "정보 없음")
                    - 배우: \($0.actors.joined(separator: ", "))
                    - 개봉일: \($0.releaseDate ?? "정보 없음")
                    - 러닝타임: \($0.runtime)분
                    - 평점: \($0.voteAverage) (\($0.voteCount)명)
                    - 관람 등급: \($0.certification ?? "정보 없음")
                    - 줄거리: \($0.overview ?? "없음")
                    - 포스터: \($0.posterImageURL ?? "없음")
                    """
                }.joined(separator: "\n\n")

                DispatchQueue.main.async {
                    self.userInfoLabel.text = """
                    사용자 정보
                    - ID: \(user.id)
                    - 닉네임: \(user.username)
                    """

                    self.reservationsLabel.text = """
                    예매 내역 (\(reservations.count)개)

                    \(reservationDetails)
                    """

                    self.favoritesLabel.text = """
                    찜한 영화 (\(favorites.count)개)

                    \(favoriteDetails)
                    """
                }

            } catch {
                DispatchQueue.main.async {
                    self.userInfoLabel.text = "데이터 가져오기 실패: \(error.localizedDescription)"
                    self.reservationsLabel.text = ""
                    self.favoritesLabel.text = ""
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func didTapLogout() {
        do {
            try firebaseService.signOut()
            self.navigateToLogin()
        } catch {
            showErrorAlert(message: error.localizedDescription)
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
