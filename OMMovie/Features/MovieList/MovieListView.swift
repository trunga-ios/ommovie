//
//  MovieListView.swift
//  OMMovie
//
//  Created by Trung A on 12/02/2023.
//

import SwiftUI

struct MovieListView: View {
    enum ViewConstants {
        static let padding: CGFloat = 16
    }
    
    @StateObject var viewModel: MovieListViewModel
    private var gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(viewModel: MovieListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    TextField("Search movie...", text: $viewModel.movieTitleSearch)
                        .font(Font.system(size: 14))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary))
                        .submitLabel(.search)
                        .onSubmit {
                            viewModel.searchSubject.send(())
                        }

                    Spacer()
                    GeometryReader { proxy in
                        ScrollView {
                            LazyVGrid(columns: gridItems, spacing: ViewConstants.padding) {
                                ForEach(viewModel.movies) { item in
                                    MovieItemView(item: item)
                                        .frame(width: (proxy.size.width - ViewConstants.padding) / 2,
                                               height: 3 * (proxy.size.width - ViewConstants.padding) / 4)
                                        .onAppear { viewModel.loadMoreMoviesIfNeeded(currentMovie: item) }
                                }
                            }
                            ProgressView()
                                .tint(Color.black)
                                .isHidden(!viewModel.isLoadingPage)
                        }
                    }
                }
                .padding(ViewConstants.padding)
            }
            .navigationTitle("Film List")
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MovieListViewModel()
        MovieListView(viewModel: viewModel)
    }
}

extension View {
    @ViewBuilder
    public func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

