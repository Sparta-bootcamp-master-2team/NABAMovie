//
//  Divider.swift
//  NABAMovie
//
//  Created by 정근호 on 4/30/25.
//

import UIKit
import SnapKit

final class Divider: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.separator
        
        self.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
