//
//  MovieNetworkManager.swift
//  NABAMovie
//
//  Created by 박주성 on 4/25/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL       // URL 생성 실패
    case responseError    // 서버 응답 오류
    case decodingError    // JSON 디코딩 실패
}

final class MovieNetworkManager {
    
    // MARK: - 현재 상영작 불러오기
    
    func fetchNowPlayingMovies() async throws -> NowPlayingMovieDTO {
        var components = URLComponents(string: TMDB.baseURL + TMDB.NowPlaying.path)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: TMDB.apiKey),
            URLQueryItem(name: "language", value: TMDB.language)
        ]
        
        guard let urlString = components?.url?.absoluteString,
              let url = URL(string: urlString)
        else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        guard let dto = try? JSONDecoder().decode(NowPlayingMovieDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return dto
    }
    
    // MARK: - 상영 예정작 불러오기
    
    func fetchUpComingMovies() async throws -> UpComingMovieDTO {
        var components = URLComponents(string: TMDB.baseURL + TMDB.UpComing.path)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: TMDB.apiKey),
            URLQueryItem(name: "language", value: TMDB.language)
        ]
        
        guard let urlString = components?.url?.absoluteString,
              let url = URL(string: urlString)
        else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        guard let dto = try? JSONDecoder().decode(UpComingMovieDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return dto
    }
    
    // MARK: - 영화 검색 결과 불러오기
    
    func fetchSearchMovies(keyword: String) async throws -> SearchMovieDTO {
        var components = URLComponents(string: TMDB.baseURL + TMDB.Search.path)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: TMDB.apiKey),
            URLQueryItem(name: "language", value: TMDB.language),
            URLQueryItem(name: "query", value: keyword)
        ]
        
        guard let urlString = components?.url?.absoluteString,
              let url = URL(string: urlString)
        else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        guard let dto = try? JSONDecoder().decode(SearchMovieDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return dto
    }
    
    // MARK: - 영화 상세정보 불러오기
    
    func fetchMovieDetail(movieID: Int) async throws -> MovieDetailDTO {
        var components = URLComponents(string: TMDB.baseURL + TMDB.Detail.path + "\(movieID)")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: TMDB.apiKey),
            URLQueryItem(name: "language", value: TMDB.language),
            URLQueryItem(name: "append_to_response", value: TMDB.Detail.appendToResponse)
        ]
        
        guard let urlString = components?.url?.absoluteString,
              let url = URL(string: urlString)
        else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        guard let dto = try? JSONDecoder().decode(MovieDetailDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return dto
    }
}
