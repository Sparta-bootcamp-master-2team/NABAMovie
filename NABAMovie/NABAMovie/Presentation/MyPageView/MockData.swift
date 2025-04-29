//
//  MockData.swift
//  NABAMovie
//
//  Created by MJ Dev on 4/28/25.
//

import Foundation

struct MyPageMovieEntity: Hashable {
    let movieID: Int
    let title: String
    let genre: [String]
    let director: String
    let actors: [String]
    let releaseDate: String
    let runtime: Int
    let voteAverage: Double
    let voteCount: Int
    let overview: String
    let posterImageURL: String
    let certification: String
}

enum MyPageMockData {
    static var item1: [MyPageMovieEntity] = [
        MyPageMovieEntity(movieID: 1197306,
                    title: "워킹맨",
                    genre: ["액션", "범죄", "스릴러"],
                    director: "데이비드 에이어",
                    actors: ["제이슨 스타뎀", "데이비드 하버", "마이클 페나"],
                    releaseDate: "출시일 정보 없음",
                    runtime: 116,
                    voteAverage: 6.28,
                    voteCount: 446,
                    overview: "전직 블랙 옵스 요원이었던 레본 케이드(제이슨 스타뎀)는 평범한 건설 노동자로 살아가며 딸과 함께 조용한 삶을 추구하고 있었으나 그의 상사의 딸이 인신매매 조직에 의해 납치되면서, 다시 과거의 전투 기술을 사용해 그녀를 구하기 위해 나서게 된다. 이 과정에서 시카고의 범죄 조직과 러시아 마피아와 얽히며, 부패와 폭력으로 가득 찬 어두운 세계를 마주하게 되는데...",
                    posterImageURL: "https://image.tmdb.org/t/p/w780/tK5sCN4cebvTt9MuSlNHehVQnYg.jpg",
                    certification: "관람 등급 정보 없음"),
        MyPageMovieEntity(movieID: 668489,
                    title: "해벅",
                    genre: ["액션", "범죄", "스릴러"],
                    director: "가렛 에반스",
                    actors: ["톰 하디", "제시 메이 리", "티모시 올리펀트"],
                    releaseDate: "25.04.2025",
                    runtime: 105,
                    voteAverage: 6.7,
                    voteCount: 222,
                    overview: "마약 절도 사건이 통제 불능으로 치닫는 상황. 지칠 대로 지친 경찰이 정치가의 아들을 구하기 위해 부패한 도시의 지하 범죄 세계와 싸우며 길을 헤쳐 나간다.",
                    posterImageURL: "https://image.tmdb.org/t/p/w780/oYUJsUlH0aoTNiKWJ78LD0cUVov.jpg",
                    certification: "19"),
        MyPageMovieEntity(movieID: 668489,
                    title: "해벅1",
                    genre: ["액션", "범죄", "스릴러"],
                    director: "가렛 에반스",
                    actors: ["톰 하디", "제시 메이 리", "티모시 올리펀트"],
                    releaseDate: "25.04.2025",
                    runtime: 105,
                    voteAverage: 6.7,
                    voteCount: 222,
                    overview: "마약 절도 사건이 통제 불능으로 치닫는 상황. 지칠 대로 지친 경찰이 정치가의 아들을 구하기 위해 부패한 도시의 지하 범죄 세계와 싸우며 길을 헤쳐 나간다.",
                    posterImageURL: "https://image.tmdb.org/t/p/w780/oYUJsUlH0aoTNiKWJ78LD0cUVov.jpg",
                    certification: "19")
    ]
    static var item2: [MyPageMovieEntity] = [
        MyPageMovieEntity(movieID: 950387,
                    title: "A MINECRAFT MOVIE 마인크래프트 무비",
                    genre: ["가족", "코미디", "모험"],
                    director: "자레드 헤스",
                    actors: ["제이슨 모모아", "잭 블랙", "세바스티안 유진 한센"],
                    releaseDate: "26.04.2025",
                    runtime: 101,
                    voteAverage: 6.2,
                    voteCount: 739,
                    overview: "왕년의 게임 챔피언이었지만 지금은 폐업 직전의 게임샵 주인이 된 \'개릿\'과 엄마를 잃고 낯선 동네로 이사 온 남매 \'헨리\'와 \'나탈리\' 그리고 그들을 돕는 부동산 중개업자 \'던\'. 이들은 ‘개릿’이 수집한 ‘큐브’가 내뿜는 신비한 빛을 따라가다 어느 폐광 속에 열린 포털을 통해 미지의 공간으로 빨려들어간다. 산과 나무, 구름과 달, 심지어 꿀벌까지 상상하는 모든 것이 네모난 현실이 되는 이곳은 바로 ‘오버월드’. 일찍이 이 세계로 넘어와 완벽하게 적응한 ‘스티브’를 만난 네 사람은 지하세계 ‘네더’를 다스리는 마법사 ‘말고샤’의 침공으로 ‘오버월드’가 위험에 빠졌다는 사실을 알게 된다. 현실 세계로 돌아가기 위해서는 일단 살아남아야 하는 법! 다섯 명의 ‘동글이’들은 ‘오버월드’를 구하기 위해 힘을 합치게 되는데…",
                    posterImageURL: "https://image.tmdb.org/t/p/w780/k5aQ2TqKcQFwPoXHkpAGoKNVDLZ.jpg",
                    certification: "12"),
        MyPageMovieEntity(movieID: 324544,
                    title: "인 더 로스트 랜즈",
                    genre: ["판타지", "모험", "액션"],
                    director: "폴 W. S. 앤더슨",
                    actors: ["밀라 요보비치", "데이브 바티스타", "Arly Jover"],
                    releaseDate: "출시일 정보 없음",
                    runtime: 102,
                    voteAverage: 6.32,
                    voteCount: 291,
                    overview: "줄거리 정보 없음",
                    posterImageURL: "https://image.tmdb.org/t/p/w780/t6HJH3gXtUqVinyFKWi7Bjh73TM.jpg",
                    certification: "관람 등급 정보 없음"),
        MyPageMovieEntity(movieID: 668489,
                    title: "해벅1",
                    genre: ["액션", "범죄", "스릴러"],
                    director: "가렛 에반스",
                    actors: ["톰 하디", "제시 메이 리", "티모시 올리펀트"],
                    releaseDate: "25.04.2025",
                    runtime: 105,
                    voteAverage: 6.7,
                    voteCount: 222,
                    overview: "마약 절도 사건이 통제 불능으로 치닫는 상황. 지칠 대로 지친 경찰이 정치가의 아들을 구하기 위해 부패한 도시의 지하 범죄 세계와 싸우며 길을 헤쳐 나간다.",
                    posterImageURL: "https://image.tmdb.org/t/p/w780/oYUJsUlH0aoTNiKWJ78LD0cUVov.jpg",
                    certification: "19")
        
    ]
}
