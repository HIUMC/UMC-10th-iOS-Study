import SwiftUI

// 1. 메인 껍데기 뷰
struct ReservationView: View {
    @StateObject private var vm = ReservationViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.megaPurple.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Color.clear.frame(height: 10) // 상단 여백
                    
                    // 콘텐츠 영역 시작
                    MainContentView(vm: vm)
                        .background(Color.white)
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                }
            }
            .navigationTitle("영화별 예매")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.megaPurple, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// 2. 내부 스크롤 콘텐츠 뷰
struct MainContentView: View {
    @ObservedObject var vm: ReservationViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                MovieSelectionSection(vm: vm)    // 영화 섹션
                TheaterSelectionSection(vm: vm)  // 극장 섹션
                DateSelectionSection(vm: vm)     // 날짜 섹션
                
                if vm.canShowTimetable {
                    TimetableSection(vm: vm)     // 시간표 섹션
                }
                
                Spacer(minLength: 50)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
    }
}

// 3. 영화 선택 섹션
// 1. 이미지 카드만 따로 분리 (컴파일러의 짐을 덜어주는 핵심!)
struct MoviePosterCard: View {
    let movie: ReservationModel
    let isSelected: Bool
    
    var body: some View {
        movie.movieImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 115)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.megaPurple : Color.clear, lineWidth: 3)
            )
    }
}

// 2. 수정된 MovieSelectionSection
struct MovieSelectionSection: View {
    @ObservedObject var vm: ReservationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(vm.selectedMovie?.title ?? "영화를 선택해주세요")
                    .font(.title3).bold()
                Spacer()
                Button("전체보기") { /* 2번 과제 시트 연결 */ }
                    .font(.caption).foregroundColor(.gray)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // MovieSelectionSection 내부의 ForEach 부분 수정
                    ForEach(vm.movies) { movie in
                        MoviePosterCard(
                            movie: movie,
                            isSelected: vm.selectedMovie?.id == movie.id
                        )
                        .onTapGesture {
                            // 함수 호출 대신 직접 값을 꽂아주면 컴파일러가 훨씬 좋아합니다!
                            if vm.selectedMovie?.id == movie.id {
                                vm.selectedMovie = nil
                            } else {
                                vm.selectedMovie = movie
                            }
                            // 선택 시 다른 항목 초기화
                            vm.selectedTheater = nil
                            vm.selectedDate = nil
                        }
                    }
                }
            }
        }
    }
}

// 4. 극장 선택 섹션
struct TheaterSelectionSection: View {
    @ObservedObject var vm: ReservationViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(Theater.allCases, id: \.self) { theater in
                Button(action: { vm.selectedTheater = theater }) {
                    Text(theater.rawValue)
                        .font(.system(size: 15, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(vm.selectedTheater == theater ? Color.megaPurple : Color.gray.opacity(0.1))
                        .foregroundColor(vm.selectedTheater == theater ? .white : .black)
                        .cornerRadius(10)
                }
                .disabled(!vm.isTheaterEnabled)
                .opacity(vm.isTheaterEnabled ? 1.0 : 0.3)
            }
        }
    }
}

// 5. 날짜 선택 섹션
struct DateSelectionSection: View {
    @ObservedObject var vm: ReservationViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(vm.dates, id: \.self) { date in
                    DateCell(date: date, isSelected: Calendar.current.isDate(vm.selectedDate ?? .distantPast, inSameDayAs: date))
                        .onTapGesture {
                            if vm.isDateEnabled { vm.selectedDate = date }
                        }
                }
            }
        }
        .disabled(!vm.isDateEnabled)
        .opacity(vm.isDateEnabled ? 1.0 : 0.3)
    }
}

// 6. 날짜 개별 셀
struct DateCell: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 18, weight: .bold))
            Text(getDayName(date))
                .font(.system(size: 12))
        }
        .frame(width: 48, height: 65)
        .background(isSelected ? Color.megaPurple : Color.clear)
        .foregroundColor(isSelected ? .white : .black.opacity(0.6))
        .cornerRadius(10)
    }
    
    func getDayName(_ date: Date) -> String {
        let f = DateFormatter(); f.locale = Locale(identifier: "ko_KR"); f.dateFormat = "E"
        return f.string(from: date)
    }
}

// 7. 시간표 섹션
struct TimetableSection: View {
    @ObservedObject var vm: ReservationViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 필터링된 결과가 없으면 안내 문구 노출
            if vm.filteredSchedules.isEmpty {
                Text("선택한 조건에 상영시간표가 없습니다")
                    .font(.subheadline).foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center).padding(.vertical, 20)
            } else {
                // 1. 선택된 극장 이름 표시
                Text(vm.selectedTheater?.rawValue ?? "").font(.headline)
                
                // 2. 상영관(auditorium)별로 반복
                ForEach(vm.filteredSchedules, id: \.auditorium) { auditorium in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(auditorium.auditorium) (\(auditorium.format))")
                            .font(.caption).bold().foregroundColor(.megaPurple)
                        
                        // 3. 해당 상영관의 시간표(showtimes) 표시
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(auditorium.showtimes, id: \.start) { session in
                                VStack(spacing: 4) {
                                    Text(session.start).font(.system(size: 14, weight: .bold))
                                    Text("\(session.available) / \(session.total)")
                                        .font(.system(size: 10)).foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(Color.gray.opacity(0.1)).cornerRadius(8)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Helpers (모서리 확장)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


#Preview{
    ReservationView()
}
