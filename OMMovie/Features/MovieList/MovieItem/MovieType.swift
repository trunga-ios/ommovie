//
//  MovieItem.swift
//  OMMovie
//
//  Created by Trung A on 12/02/2023.
//

import Foundation

protocol MovieType {
    var title: String { get }
    var posterUrl: URL? { get }
}

struct MovieItem: MovieType {
    var title: String
    var posterUrl: URL?
    var index: Int
    
    init(title: String, posterUrl: URL?, index: Int) {
        self.title = title
        self.posterUrl = posterUrl
        self.index = index
    }
    
    init(movie: Movie, index: Int) {
        self.title = movie.title
        self.posterUrl = URL(string: movie.poster)
        self.index = index
    }
}

extension MovieItem: Identifiable {
    var id: String {
        title
    }
}
