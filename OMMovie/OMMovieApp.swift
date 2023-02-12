//
//  OMMovieApp.swift
//  OMMovie
//
//  Created by Trung A on 12/02/2023.
//

import SwiftUI

@main
struct OMMovieApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: MovieListViewModel())
        }
    }
}
