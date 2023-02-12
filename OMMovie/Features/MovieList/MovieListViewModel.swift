//
//  MovieListViewModel.swift
//  OMMovie
//
//  Created by Trung A on 12/02/2023.
//

import Foundation
import Combine

final class MovieListViewModel: ObservableObject {
    @Published var movies: [MovieItem] = []
    @Published var movieTitleSearch: String = ""
    @Published var isLoadingPage = false
    let searchSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var canLoadMorePages = true
    
    init() {
        searchSubject
            .map { _ in Date() }
            .combineLatest($movieTitleSearch)
            .removeDuplicates { $0.0 == $1.0 }
            .map { $0.1 }
            .sink { [weak self] in
                self?.searchMovie(title: $0)
            }
            .store(in: &cancellables)
    }
    
    private func searchMovie(title: String) {
        self.movies.removeAll()
        currentPage = 1
        
        isLoadingPage = true
        let request: Request<MovieSearchResponse> = .searchMovie(title: title, page: currentPage)
        URLSession.shared.publisher(for: request)
            .map(\.search)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoadingPage = false
                switch completion {
                case .finished:
                    self?.currentPage += 1
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.movies = response.enumerated().map { MovieItem(movie: $0.element, index: $0.offset) }
            })
            .store(in: &cancellables)
    }
    
    private func loadMoreMovies() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        let request: Request<MovieSearchResponse> = .searchMovie(title: movieTitleSearch, page: currentPage)
        URLSession.shared.publisher(for: request)
             .receive(on: DispatchQueue.main)
             .sink(receiveCompletion: { [weak self] completion in
                 self?.isLoadingPage = false
                 switch completion {
                 case .finished:
                     self?.currentPage += 1
                 default:
                     break
                 }
             }, receiveValue: { [weak self] response in
                 guard let self = self else { return }
                 let moviesCount = self.movies.count
                 let responseCount = response.search.count
                 let totalCount = Int(response.totalResults) ?? 0
                 self.canLoadMorePages = (moviesCount + responseCount) < totalCount
                 
                 let mergedMovies = self.movies + response.search.map { MovieItem(movie: $0, index: 0) }
                 self.movies = mergedMovies.enumerated()
                     .map { MovieItem(title: $0.element.title,
                                      posterUrl: $0.element.posterUrl,
                                      index: $0.offset)
                     }
             })
             .store(in: &cancellables)
    }
    
    func loadMoreMoviesIfNeeded(currentMovie movie: MovieItem?) {
        guard let movie = movie else {
            loadMoreMovies()
            return
        }
         
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -2)
        if movies.firstIndex(where: { $0.id == movie.id }) == thresholdIndex {
            loadMoreMovies()
        }
    }
}
