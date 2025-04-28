//
//  Constants.swift
//  NABAMovie
//
//  Created by 박주성 on 4/28/25.
//


import Foundation

enum TMDB {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as! String
    static let language = "ko-KR"
    static let posterBaseURL = "https://image.tmdb.org/t/p/w780"
    static let backDropBaseURL = "https://image.tmdb.org/t/p/w1280"
    
    enum NowPlaying {
        static let path = "/movie/now_playing"
    }
    
    enum UpComing {
        static let path = "/movie/upcoming"
    }
    
    enum Search {
        static let path = "/search/movie"
    }
    
    enum Detail {
        static func path(movieID: Int) -> String {
            return "/movie/\(movieID)"
        }
        static let appendToResponse = "credits,release_dates"
    }
    
    enum Images {
        static func path(movieID: Int) -> String {
            return "/movie/\(movieID)/images"
        }
    }
}
