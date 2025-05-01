//
//  TabBarFactory.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import Foundation

final class TabBarFactory {
    func makeHomeFactory() -> HomeFactory {
        return HomeFactory()
    }

    func makeSearchFactory() -> SearchFactory {
        return SearchFactory()
    }

    func makeMyPageFactory() -> MyPageFactory {
        return MyPageFactory()
    }
}
