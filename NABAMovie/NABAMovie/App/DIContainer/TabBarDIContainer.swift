//
//  TabBarDIContainer.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import Foundation

final class TabBarDIContainer {
    func makeHomeDIContainer() -> HomeDIContainer {
        return HomeDIContainer()
    }

    func makeSearchDIContainer() -> SearchDIContainer {
        return SearchDIContainer()
    }

    func makeMyPageDIContainer() -> MyPageDIContainer {
        return MyPageDIContainer()
    }
}
