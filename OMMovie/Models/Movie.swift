//
//  Movie.swift
//  OMMovie
//
//  Created by Trung A on 12/02/2023.
//

import Foundation

struct Movie: Decodable {
    let title: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case poster = "Poster"
    }
    
    static let sampleData: [Movie] = [
        Movie(title: "Captain Marvel", poster: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg"),
        Movie(title: "Marvel One-Shot: Agent Carter", poster: "https://m.media-amazon.com/images/M/MV5BZDIwZTM4M2QtMWFhYy00N2VmLWFlMjItMzI3NjBjYTc0OTMxXkEyXkFqcGdeQXVyNTE1NjY5Mg@@._V1_SX300.jpg"),
        Movie(title: "Marvel One-Shot: All Hail the King", poster: "https://m.media-amazon.com/images/M/MV5BZGFkMTZkMDQtNzM4Yy00YWEwLTkzOWEtZTMyNDRlNmJhYWJhXkEyXkFqcGdeQXVyNTE1NjY5Mg@@._V1_SX300.jpg"),
        Movie(title: "Marvel One-Shot: Item 47", poster: "https://m.media-amazon.com/images/M/MV5BMjNlMzAxNmQtOGEwZi00NTEyLWI0NWYtMTlhNmE2YTA3ZDVhXkEyXkFqcGdeQXVyNTE1NjY5Mg@@._V1_SX300.jpg"),
        Movie(title: "Marvel One-Shot: A Funny Thing Happened on the Way to Thor's Hammer", poster: "https://m.media-amazon.com/images/M/MV5BYmVlYTg3N2QtMWM2OS00YWQyLWI2M2MtMDc0ZjBkZjk1MTY3XkEyXkFqcGdeQXVyNTE1NjY5Mg@@._V1_SX300.jpg"),
        Movie(title: "Marvel One-Shot: The Consultant", poster: "https://m.media-amazon.com/images/M/MV5BNGE4YjU5MDAtYzYzMC00M2RlLTk0NDgtNDU1MjgyMGI0MjI3XkEyXkFqcGdeQXVyNTE1NjY5Mg@@._V1_SX300.jpg"),
    ]
}

struct MovieSearchResponse: Decodable {
    let search: [Movie]
    let totalResults: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
    }
}

extension Request where Response == MovieSearchResponse {
    static func searchMovie(title: String, page: Int) -> Self {
        Request(
            url: URL(string: "http://www.omdbapi.com")!,
            method: .get(
                [.init(name: "apikey", value: "b9bd48a6"),
                 .init(name: "s", value: title),
                 .init(name: "type", value: "movie"),
                 .init(name: "page", value: "\(page)"),
                ]
            )
        )
    }
}
