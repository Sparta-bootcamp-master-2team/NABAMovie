//
//  MyPageDIContainer.swift
//  NABAMovie
//
//  Created by 박주성 on 4/30/25.
//

import UIKit

final class MyPageDIContainer {
    func makeMyPageViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray
        vc.title = "마이페이지"
        return vc
    }
}
