//
//  CellConfigurable.swift
//  NABAMovie
//
//  Created by MJ Dev on 5/1/25.
//

import Foundation
// DiffableDataSource 셀의 데이터모델이 여러가지 인 경우 해당 프로토콜을 채택하고 configure(model: CellConfigureable)을 통해
// 다양한 데이터모델을 유연하게 파라미터로 전달하기 위해서 생성
protocol CellConfigurable { }
