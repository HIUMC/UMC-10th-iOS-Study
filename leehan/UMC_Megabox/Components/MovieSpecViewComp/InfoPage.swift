//
//  InfoPage.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct InfoPage: View {
    var spec: MovieModel
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(spec.moviePoster)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 43, height: 61)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(spacing: 3) {
                    HStack {
                        Text(spec.age)
                            .font(.PretendardSemiBold(size: 14))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    HStack {
                        Text("\(spec.opening) | \(spec.time)")
                            .font(.PretendardSemiBold(size: 14))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray02)
                .padding(.top, 6)
                .padding(.bottom, 14)
            
            VStack(spacing: 7) {
                InfoText(title: "장르", content: spec.genre)
                InfoText(title: "타입", content: spec.type)
                InfoText(title: "감독", content: spec.director)
                InfoText(title: "출연", content: spec.actors)
            }
        }.padding(.horizontal)
            .frame(height: 210)
    }
}
