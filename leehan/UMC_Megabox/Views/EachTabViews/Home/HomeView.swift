//
//  HomeView.swift
//  leehan
//
//  Created by 이한결 on 3/31/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(HomeViewModel.self) private var homeVM
    @Environment(NavigationRouter.self) private var router
    @State private var isMovieChartSelected: Bool = true
    // 선택된 특별관 id를 저장하는 상태변수
    @State private var selectedId: UUID? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                // MARK: 상단 버튼 섹션
                HStack(spacing: 5) {
                    Button1(text: "무비차트",
                            isMovieChartSelected: isMovieChartSelected,
                            onTap: { isMovieChartSelected = true })
                    Spacer().frame(width: 18)
                    Button1(text: "상영예정",
                            isMovieChartSelected: !isMovieChartSelected,
                            onTap: { isMovieChartSelected = false })
                    Spacer()
                }.padding(.top, 15)
                    .padding(.bottom, 13)
                
                // MARK: 영화 가로스크롤
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(homeVM.movieDummyList) { movie in
                            MovieView(movieInfo: movie)
                                .padding(.trailing)
                                .onTapGesture {
                                    router.push(.movieSpec(movie))
                                }
                        }
                    }
                }.scrollIndicators(.hidden)
                    .padding(.bottom, 10)
                
                // MARK: 메가박스의 모든 특별관
                HStack {
                    Text("메가박스의 모든 특별관")
                        .font(.PretendardBold(size: 24))
                    Spacer()
                    Button( action: {} ) {
                        RoundedRectangle(cornerRadius: 48)
                            .frame(width: 48, height: 48)
                            .foregroundStyle(.clear)
                            .overlay(
                                Image(systemName: "chevron.right")
                                    .frame(width: 22)
                                    .foregroundStyle(.black)
                                    .buttonStyle(.glass)
                            )
                    }
                }
                
                // MARK: 특별관 가로스크롤
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(homeVM.specialTheaterDummyList) { theater in
                            
                            VStack(spacing: 5) {
                                Button( action: { withAnimation(.easeInOut(duration: 0.1)) {
                                    selectedId = theater.id }
                                }) {
                                    Image(theater.specialImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .opacity(selectedId == theater.id ? 1.0 : 0.4)
                                }
                                
                                Circle()
                                    .foregroundStyle(selectedId == theater.id ? .purple04 : .clear)
                                    .frame(width: 10, height: 10)
                            }
                            
                        }
                    }
                    
                }.scrollIndicators(.hidden)
                
                // MARK: 특별관 하단 이미지
                Image("Special_Theater_Image")
                
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("logo_megabox2")
                }.sharedBackgroundVisibility(.hidden)
            }
            .safeAreaBar(edge: .top) {
                TopButtonSection()
            }
            .safeAreaPadding(.horizontal)
        }.onAppear() {
            self.isMovieChartSelected = true
            self.selectedId = nil
        }
    }
}



#Preview {
    HomeView()
        .environment(HomeViewModel())
        .environment(NavigationRouter())
}
