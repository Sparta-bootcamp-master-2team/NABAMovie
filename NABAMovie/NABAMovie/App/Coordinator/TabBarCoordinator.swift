//
//  TabBarCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    let tabBarController = UITabBarController()
    private let tabBarDIContainer: TabBarDIContainer

    init(tabBarDIContainer: TabBarDIContainer) {
        self.tabBarDIContainer = tabBarDIContainer
    }

    func start() {
        // 각 탭의 navigationController
        let homeNav = UINavigationController()
        let searchNav = UINavigationController()
        let myPageNav = UINavigationController()

        // 탭별 Coordinator 생성 및 DI 주입
        let homeCoordinator = HomeCoordinator(
            navigationController: homeNav,
            diContainer: tabBarDIContainer.makeHomeDIContainer()
        )

        let searchCoordinator = SearchCoordinator(
            navigationController: searchNav,
            diContainer: tabBarDIContainer.makeSearchDIContainer()
        )

        let myPageCoordinator = MyPageCoordinator(
            navigationController: myPageNav,
            diContainer: tabBarDIContainer.makeMyPageDIContainer()
        )

        // Coordinator들 start
        homeCoordinator.start()
        searchCoordinator.start()
        myPageCoordinator.start()

        // childCoordinators에 보관 (retain)
        childCoordinators = [homeCoordinator, searchCoordinator, myPageCoordinator]

        // 탭바에 연결
        tabBarController.setViewControllers([homeNav, searchNav, myPageNav], animated: false)

        // 탭바 설정
        tabBarController.tabBar.backgroundColor = .brand
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .white
        
        homeNav.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        searchNav.tabBarItem = UITabBarItem(
            title: "영화 검색",
            image: UIImage(named: "magnifyingglass"),
            selectedImage: UIImage(named: "magnifyingglass.fill")
        )
        
        myPageNav.tabBarItem = UITabBarItem(
            title: "마이 페이지",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
    }
}
