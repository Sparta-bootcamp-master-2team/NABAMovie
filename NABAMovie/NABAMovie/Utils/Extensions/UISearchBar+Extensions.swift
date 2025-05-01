//
//  UISearchBar+Extensions.swift
//  NABAMovie
//
//  Created by MJ Dev on 5/1/25.
//

import Foundation
import UIKit

extension UISearchBar {
    func setTextFieldColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                for subSubSubView in subSubView.subviews {
                    let textField = subSubSubView as? UITextField
                    textField?.backgroundColor = color
                    break
                }
            }
        }
    }
}
