//
//  HomeView.swift
//  MegaBox
//
//  Created by 김민지 on 4/1/26.
//

import SwiftUI

// MARK: - 1. HomeView (메인 화면)
struct HomeView: View {
    // 💡 뷰모델 연결
    @State private var viewModel = HomeViewModel()
    @State private var selectedTab: String = "홈"
    let tabs = ["홈", "이벤트", "스토어", "선호극장"]
    
    var body: some View {
        NavigationStack {
            // 워크북의 iOS 26.0 설정 유지
            if #available(iOS 26.0, *) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        movieSection
                        specialHallSection
                        bannerSection
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                // [상단 헤더 1] 로고 영역
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image("meboxLogo1")
                            .resizable()
                            .scaledToFit()
                    }
                }
                // [상단 헤더 2] 세그먼트 영역 (애플 공식 수식어인 safeAreaInset 사용)
                .safeAreaInset(edge: .top) {
                    HStack(spacing: 20) {
                        ForEach(tabs, id: \.self) { tab in
                            Button {
                                selectedTab = tab
                            } label: {
                                Text(tab)
                                    .font(.system(size: 18, weight: selectedTab == tab ? .bold : .medium))
                                    .foregroundColor(selectedTab == tab ? .primary : .secondary)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(.background) // 배경색을 지정해야 스크롤 시 뒤가 안 비칩니다
                }
                // 💡 최신 Navigation 연결: 클릭된 영화 정보를 받아 상세 화면으로 이동
                .navigationDestination(for: MovieModel.self) { selectedMovie in
                    MovieDetailView(viewModel: MovieDetailViewModel(movie: selectedMovie))
                }
            } else {
                Text("최신 버전을 지원하는 기기가 필요합니다.")
            }
        }
    }
}

// MARK: - 2. HomeView UI 컴포넌트 분리
private extension HomeView {
    
    // 영화 포스터 가로 스크롤 섹션
    var movieSection: some View {
        VStack(alignment: .leading) {
            HStack {
                // 💡 뷰모델의 상태 변경 함수 연결
                Button("무비차트") { viewModel.selectedChartType = .nowPlaying }
                    .font(.system(size: 16, weight: viewModel.selectedChartType == .nowPlaying ? .bold : .medium))
                    .foregroundColor(viewModel.selectedChartType == .nowPlaying ? .primary : .gray)
                
                Button("상영예정") { viewModel.selectedChartType = .upcoming }
                    .font(.system(size: 16, weight: viewModel.selectedChartType == .upcoming ? .bold : .medium))
                    .foregroundColor(viewModel.selectedChartType == .upcoming ? .primary : .gray)
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    // 💡 하드코딩 삭제 -> ViewModel 데이터 순회
                    ForEach(viewModel.currentMovies) { movie in
                        NavigationLink(value: movie) {
                            MoviePoster(movie: movie)
                        }
                        .buttonStyle(.plain) // 클릭 시 파란색으로 변하는 기본 버튼 효과 방지
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // 빨간 박스로 강조된 특별관 섹션
    var specialHallSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("메가박스의 모든 특별관")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(["Dolby", "Atmos", "MX4D", "DolbyAtmos", "LED"], id: \.self) { name in
                        Circle()
                            .fill(Color(uiColor: .systemGray6))
                            .frame(width: 60, height: 60)
                            .overlay(Text(name).font(.caption2))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // 하단 배너 섹션
    var bannerSection: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.black)
            .frame(height: 200)
            .overlay(
                Text("DOLBY CINEMA")
                    .foregroundColor(.white)
                    .font(.title2).bold()
            )
            .padding(.horizontal)
    }
}

// MARK: - 3. 개별 영화 포스터 컴포넌트
struct MoviePoster: View {
    // 모델 전체를 주입받아 사용합니다.
    let movie: MovieModel
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.3)) // 실제 이미지 사용 시: Image(movie.posterImage).resizable().scaledToFill()
                .frame(width: 140, height: 200)
                .clipped()
            
            Button("바로 예매") { }
                .font(.caption).bold()
                .frame(width: 140)
                .padding(.vertical, 5)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.purple))
            
            Text(movie.title)
                .font(.system(size: 15, weight: .bold))
                .lineLimit(1)
            
            Text(movie.formattedAudienceCount) // 포맷팅된 관객수 문자열 사용
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - 4. Preview
#Preview {
    HomeView()
}
