//
//  SearchDIContainer.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class SearchDIContainer {
    func makeSearchViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        vc.title = "검색"
        return vc
    }
}
