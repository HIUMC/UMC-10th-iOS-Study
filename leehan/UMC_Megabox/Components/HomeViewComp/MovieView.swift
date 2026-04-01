//
//  MovieView.swift
//  leehan
//
//  Created by 이한결 on 3/31/26.
//

import SwiftUI

struct MovieView: View {
    var movieInfo: MovieModel
    
    var body: some View {
        VStack {
            Image(movieInfo.moviePoster)
                .resizable()
                .scaledToFit()
                .frame(height: 209)
            
            Spacer()
                .frame(height: 12)
                
            Button( action: { } ) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.purple03, lineWidth: 1)
                    .overlay(
                        Text("바로 예매")
                            .font(.PretendardMedium(size: 16))
                            .foregroundStyle(.purple03)
                    )
            }.frame(height: 36)
            
            Spacer()
                .frame(height: 12)
            
            HStack {
                Text(movieInfo.movieName)
                    .font(.PretendardBold(size: 22))
                Spacer()
            }
            
            HStack {
                Text("누적관객수 \(movieInfo.movieViews)만")
                    .font(.PretendardMedium(size: 16))
                Spacer()
            }
        }.frame(width: 148)
    }
}


#Preview {
    MovieView(movieInfo: MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500))
}

