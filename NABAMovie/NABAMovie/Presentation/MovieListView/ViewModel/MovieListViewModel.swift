//
//  MovieListViewModel.swift
//  NABAMovie
//
//  Created by MJ Dev on 5/1/25.
//

import Foundation

class MovieListViewModel {
    
    var item: [CellConfigurable]
    
    init(item: [CellConfigurable]) {
        self.item = item
    }
}
