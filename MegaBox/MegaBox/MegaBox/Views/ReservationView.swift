//
//  MovieReservationView.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//

import SwiftUI
import Observation




// MARK: - 2. ViewModel (비즈니스 로직)
@Observable
class ReservationViewModel {
    // 영화 리스트 더미 데이터
    let movies: [ReservationMovieModel] = [
        ReservationMovieModel(title: "왕과 사는 남자", posterImage: "movie1", ageRating: "12"),
        ReservationMovieModel(title: "프로젝트 헤일메리", posterImage: "movie2", ageRating: "12"),
        ReservationMovieModel(title: "호퍼스", posterImage: "movie3", ageRating: "ALL"),
        ReservationMovieModel(title: "휴민트", posterImage: "movie4", ageRating: "15"),
        ReservationMovieModel(title: "매드댄스오피스", posterImage: "movie5", ageRating: "12")
    ]
    
    // 선택 상태 관리 (Combine의 역할을 이 변수들이 자동으로 수행합니다)
    var selectedMovie: ReservationMovieModel? = nil
    var selectedTheater: String? = nil
    var selectedDate: DateItem? = nil
    
    // 날짜 리스트
    var availableDates: [DateItem] = []
    
    // 극장 리스트
    let theaters = ["강남", "홍대", "신촌"]
    
    init() {
        // 초기화 시 영화 하나를 기본 선택 상태로 만들려면 아래 주석을 해제하세요.
        // self.selectedMovie = movies.first
        generateDates()
    }
    
    // 💡 당일 기준 일주일(7일)의 날짜 데이터를 생성하는 로직
    private func generateDates() {
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                let day = calendar.component(.day, from: date)
                let month = calendar.component(.month, from: date)
                
                var displayDay = "\(day)"
                var displayWeekday = ""
                
                if i == 0 {
                    displayDay = "\(month).\(day)"
                    displayWeekday = "오늘"
                } else if i == 1 {
                    displayWeekday = "내일"
                } else {
                    // "금", "토" 등의 요일 구하기
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ko_KR")
                    formatter.dateFormat = "E"
                    displayWeekday = formatter.string(from: date)
                }
                
                let item = DateItem(date: date, displayDay: displayDay, displayWeekday: displayWeekday)
                availableDates.append(item)
            }
        }
        // 기본값으로 오늘 선택
        self.selectedDate = availableDates.first
    }
}


// MARK: - 3. View (UI 화면)
struct ReservationView: View {
    @State private var viewModel = ReservationViewModel()
    @Environment(\.dismiss) private var dismiss // 뒤로 가기 액션
    
    // 보라색 테마 컬러 (피그마 참고)
    let megaPurple = Color(red: 0.35, green: 0.12, blue: 0.71)
    
    var body: some View {
        VStack(spacing: 30) {
            
            // 1. 영화 선택 섹션 (타이틀 + 가로 스크롤 포스터)
            movieSelectionSection
            
            // 2. 극장 선택 섹션
            theaterSelectionSection
            
            // 3. 날짜 선택 섹션
            dateSelectionSection
            
            Spacer()
        }
        .padding(.top, 20)
        
        // MARK: 네비게이션 바 설정 (체크리스트 완벽 반영)
        .navigationTitle("영화별 예매")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // 기본 Back 버튼 숨기기
        .toolbar {
            // 커스텀 왼쪽 백 버튼
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        // 💡 상태 바까지 보라색으로 꽉 채우는 마법의 모디파이어들
        .toolbarBackground(megaPurple, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar) // 텍스트를 흰색으로
    }
}


// MARK: - 4. Subviews (컴포넌트 분리)
private extension ReservationView {
    
    // 영화 선택 섹션
    var movieSelectionSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 상단 제목 영역 (선택된 영화에 따라 바뀜)
            HStack {
                if let selected = viewModel.selectedMovie {
                    // 연령 뱃지 (주황색 배경)
                    Text(selected.ageRating)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .cornerRadius(4)
                    
                    Text(selected.title)
                        .font(.headline)
                        .fontWeight(.bold)
                } else {
                    Text("영화를 선택해주세요")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 전체영화 버튼
                Button("전체영화") { }
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(Color(white: 0.95))
                    )
            }
            .padding(.horizontal)
            
            // 영화 포스터 가로 스크롤
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.movies) { movie in
                        Button {
                            // 💡 탭하면 해당 영화를 선택 상태로 만듦
                            viewModel.selectedMovie = movie
                            viewModel.selectedTheater = nil // 영화가 바뀌면 극장 선택 초기화
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3)) // Image(movie.posterImage) 로 대체 가능
                                .frame(width: 80, height: 110)
                                .overlay(
                                    // 💡 선택된 영화일 경우 피그마와 동일하게 보라색 테두리 표시
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewModel.selectedMovie == movie ? megaPurple : Color.clear, lineWidth: 3)
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // 극장 선택 섹션
    var theaterSelectionSection: some View {
        HStack(spacing: 15) {
            ForEach(viewModel.theaters, id: \.self) { theater in
                Button {
                    viewModel.selectedTheater = theater
                } label: {
                    Text(theater)
                        .font(.system(size: 14, weight: viewModel.selectedTheater == theater ? .bold : .medium))
                        .foregroundColor(viewModel.selectedTheater == theater ? .white : .black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().fill(viewModel.selectedTheater == theater ? megaPurple : Color(white: 0.9))
                        )
                }
                // 💡 핵심(Combine 대체): 영화를 선택하지 않았다면 버튼을 비활성화(disabled) 합니다!
                .disabled(viewModel.selectedMovie == nil)
                // 비활성화 상태일 때 투명도를 줘서 사용자가 인지하게 함
                .opacity(viewModel.selectedMovie == nil ? 0.4 : 1.0)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    // 날짜 선택 섹션
    var dateSelectionSection: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.availableDates) { dateItem in
                let isSelected = viewModel.selectedDate == dateItem
                
                Button {
                    viewModel.selectedDate = dateItem
                } label: {
                    VStack(spacing: 8) {
                        Text(dateItem.displayDay)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(isSelected ? .white : .black)
                        
                        Text(dateItem.displayWeekday)
                            .font(.caption)
                            .fontWeight(isSelected ? .bold : .medium)
                            .foregroundColor(isSelected ? .white : .gray)
                    }
                    // 스크롤 없이 가로 공간을 7개로 균등 분할
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? megaPurple : Color.clear)
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}


#Preview {
    NavigationStack {
        ReservationView()
    }
}
