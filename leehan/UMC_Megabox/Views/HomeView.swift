//
//  HomeView.swift
//  leehan
//
//  Created by 이한결 on 3/31/26.
//

import SwiftUI

struct HomeView: View {
    @State private var homeVM: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(spacing: 5) {
                    Button1(text: "무비차트")
                    Button1(text: "상영예정")
                    Spacer()
                }.padding(.top, 6)
                    .padding(.bottom, 6)
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(homeVM.movieDummyList) { movie in
                            MovieView(movieInfo: movie)
                                .padding(.trailing)
                        }
                    }
                }.scrollIndicators(.hidden)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("logo_megabox2").buttonStyle(.borderless)
                }
            }
            .safeAreaBar(edge: .top) {
                HStack {
                    Button( action: { } ) {
                        Text("홈")
                            .font(.PretendardSemiBold(size: 24))
                            .foregroundStyle(.black)
                            .padding(.trailing, 20)
                    }
                    
                    Button( action: { } ) {
                        Text("이벤트")
                            .font(.PretendardSemiBold(size: 24))
                            .foregroundStyle(.black)
                            .padding(.trailing, 20)
                    }
                    
                    Button( action: { } ) {
                        Text("스토어")
                            .font(.PretendardSemiBold(size: 24))
                            .foregroundStyle(.black)
                            .padding(.trailing, 20)
                    }
                    
                    Button( action: { } ) {
                        Text("선호극장")
                            .font(.PretendardSemiBold(size: 24))
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                }
            }
            .safeAreaPadding(.horizontal)
        }
    }
}

struct Button1: View {
    var text: String
    
    var body: some View {
        Button( action: { } ) {
            RoundedRectangle(cornerRadius: 24)
                .frame(width: 84, height: 38)
                .foregroundStyle(.gray08)
                .overlay(
                    Text(text)
                        .font(.PretendardSemiBold(size: 15))
                        .foregroundStyle(.white)
                )
        }.buttonStyle(.glass)
            .buttonStyle(.borderless)
    }
}

#Preview {
    HomeView()
}
