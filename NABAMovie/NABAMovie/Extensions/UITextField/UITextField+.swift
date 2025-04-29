//
//  UITextField+.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import Foundation
import UIKit

// UITextField에 왼쪽 패딩을 쉽게 추가할 수 있도록 확장
extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
