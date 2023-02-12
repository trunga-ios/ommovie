//
//  MovieItemView.swift
//  OMMovie
//
//  Created by Trung A on 12/02/2023.
//

import SwiftUI

struct MovieItemView: View {
    var item: MovieItem
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
//            AsyncImage(url: item.posterUrl)
            VStack {
                Spacer()
                    .frame(maxHeight: .infinity)
                Text(item.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black)
            }
        }
        .cornerRadius(10)
    }
}

struct MovieItemView_Previews: PreviewProvider {
    static var previews: some View {
        let item = MovieItem(movie: Movie.sampleData[0], index: 0)
        MovieItemView(item: item)
    }
}
