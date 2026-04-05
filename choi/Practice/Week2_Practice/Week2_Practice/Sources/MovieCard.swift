//
//  MovieCard.swift
//  Week2_Practice
//
//  Created by 최민혁 on 3/24/26.
//
import SwiftUI

struct MovieCard: View {
    let movieInfo : MovieModel
    
    init(movieInfo: MovieModel){
        self.movieInfo = movieInfo
    }
    var body: some View{
        VStack{
            movieInfo.movieImage
                
            Text(movieInfo.movieName)
                .font(.system(size:20, weight: .bold))
                .foregroundStyle(Color.black)
            
            HStack{
                movieLike
                
                Spacer()
                
                Text("예매율 \(movieInfo.movieReserCount.formatted(.number.precision(.fractionLength(1))))%")
                    .font(.system(size: 9,weight:.regular))
                    .foregroundStyle(Color.black)
                    
            }
            
            }
        .frame(width: 120, height: 216)

    }
    
    private var movieLike: some View {
        HStack(spacing: 6){
            Image(systemName: "heart.fill")
                .foregroundStyle(Color.red)
                .frame(width: 15, height: 14)
            
            Text("\(movieInfo.movieLike)")
                .font(.system(size: 9,weight: .regular))
                .foregroundStyle(Color.black)
        }
        
    }
    
}


#Preview {
    MovieCard(movieInfo: .init(movieImage: .init(.kingsWarden), movieName: "왕과 사는 남자", movieLike: 972, movieReserCount: 30.8))
}
