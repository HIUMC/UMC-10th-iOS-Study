//
//  TicketView.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct TicketView: View {
    @Environment(TicketViewModel.self) private var vm
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 상단 보라 영역
            ZStack {
                Rectangle()
                    .foregroundStyle(.purple03)
                
                VStack {
                    Spacer()
                    Text("영화별 예매")
                        .foregroundStyle(.white)
                        .font(.PretendardBold(size: 22))
                        .padding(.bottom, 17)
                    
                }
            }.frame(maxWidth: .infinity)
                .frame(height: 125)
                .padding(.bottom, 0)
                .ignoresSafeArea(edges: .top)
            
            // MARK: 영화 정보 섹션
            ScrollView {
                HStack {
                    if let movie = vm.selectedMovie {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .frame(maxWidth: 35)
                                .frame(height: 24)
                                .foregroundStyle(.orange)
                            Text(movie.age)
                                .foregroundStyle(.white)
                                .font(.PretendardBold(size: 18))
                        }
                        
                        HStack{
                            Text(movie.movieName)
                                .foregroundStyle(.black)
                                .font(.PretendardBold(size: 18))
                            Spacer()
                        }
                        
                        Button( action: { } ) {
                            Text("전체영화")
                                .foregroundStyle(.black)
                                .font(.PretendardSemiBold(size: 14))
                        }
                    }
                }.padding(.trailing)
                    .frame(minHeight: 30)
                
                Spacer().frame(height: 20)
                
                // MARK: 영화 포스터 가로스크롤
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(vm.allMovies) { movie in
                            Button ( action: { vm.selectedMovie = movie } ) {
                                Image(movie.moviePoster)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 86)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(vm.selectedMovie == movie ? .purple03 : .clear, lineWidth: 2)
                                    )
                            }
                        }
                    }
                }.scrollIndicators(.hidden)
                    .frame(height: 89)
                
                Spacer().frame(height: 20)
                
                // MARK: 영화관 선택 - 영화가 선택되었을 때에 노출
                if (vm.selectedMovie != nil) {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(vm.allTheaters) { theater in
                                Button ( action: { vm.toggleTheaterSelection(theater: theater) } ) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: 55, height: 35)
                                            .foregroundStyle(vm.selectedTheaters.contains(theater) ? .purple03 : .gray01)
                                        
                                        Text(theater.name)
                                            .font(.PretendardSemiBold(size: 16))
                                            .foregroundStyle(vm.selectedTheaters.contains(theater) ? .white : .gray03)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 20)
                
                // MARK: 캘린더 뷰 - 영화관이 선택되었을 때에 노출
                if (vm.selectedMovie != nil && !vm.selectedTheaters.isEmpty) {
                    DateSelectionView(selectedDate: vm.selectedDate) { newDate in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            vm.selectedDate = newDate
                        }
                    }
                }
                
                Spacer().frame(height: 20)
                
                // MARK: 스케줄 목록 - 영화, 영화관, 날짜 모두 선택되었을 때에 노출
                if (vm.selectedMovie != nil && !vm.selectedTheaters.isEmpty && vm.selectedDate != nil) {
                    VStack(spacing: 20) {
                        ForEach(vm.groupedSchedules) { theater in
                            ScheduleView(theaterInfo: theater).padding(.trailing)
                        }
                    }
                }
            }.padding(.leading)
                .scrollIndicators(.hidden)
                .padding(.top, -50)
            
            
            
            
            
        }
    }
}

#Preview {
    TicketView()
        .environment(TicketViewModel())
}
