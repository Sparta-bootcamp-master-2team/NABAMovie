//
//  TabBarCoordinator.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    let tabBarController = UITabBarController()
    private let factory: TabBarFactory

    private(set) weak var parentCoordinator: AppCoordinator?
    private var childCoordinators: [Coordinator] = []


    init(
        factory: TabBarFactory,
        parent: AppCoordinator
    ) {
        self.factory = factory
        self.parentCoordinator = parent
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }

    func start() {
        // 각 탭의 navigationController
        let homeNav = UINavigationController()
        let searchNav = UINavigationController()
        let myPageNav = UINavigationController()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brand
        appearance.shadowColor = .clear // 테두리 없애기
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        [homeNav, searchNav, myPageNav].forEach { nav in
            nav.navigationBar.tintColor = .white
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance
            nav.navigationItem.backButtonTitle = ""
        }

        // 탭별 Coordinator 생성 및 DI 주입
        let homeCoordinator = HomeCoordinator(
            navigationController: homeNav,
            factory: factory.makeHomeFactory(),
            parent: self
        )

        let searchCoordinator = SearchCoordinator(
            navigationController: searchNav,
            factory: factory.makeSearchFactory(),
            parent: self
        )

        let myPageCoordinator = MyPageCoordinator(
            navigationController: myPageNav,
            factory: factory.makeMyPageFactory(),
            parent: self
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
