//
//  ContentView.swift
//  Week2
//
//  Created by 김민지 on 3/31/26.
//

import SwiftUI
import Observation  // 변화를 바로 감지하고 UI에 반영하도록 하는 기능

struct MovieView: View {
    
    // 사용자가 설정한 영화 이름을 기기의 저장소에 보관
    @AppStorage("movieName") private var movieName: String = ""
    
    // ViewModel 환경으로 주입
    private var viewModel: MovieViewModel = .init()
    
    
    var body: some View {
        VStack(spacing: 56) {
            // MovieCard는 구조체(View)를 생성.
            // 현재 인덱스의 영화 데이터 하나"만 콕 집어서 전달해주어야 해당 뷰를 만들 수 있음.
            MovieCard(movieInfo: viewModel.movieModel[viewModel.currentIndex])
            
            leftRightChange
            
            settingMovie
            
            printAppStorageValue
        }
        .padding()
    }
    
    /// 영화 전환 버튼
    private var leftRightChange: some View {
        HStack {
            Group {
                makeChevron(name: "chevron.left", action: viewModel.previousMovie)
                
                Spacer()
                
                Text("영화 바꾸기")
                    .font(.system(size: 20, weight: .regular))
                
                Spacer()
                
                makeChevron(name: "chevron.right", action: viewModel.nextMovie)
            }
            .foregroundStyle(Color.black)
        }
        .frame(width: 256)
        .padding(.vertical, 17)     // 위(Top)와 아래(Bottom)에 각각 17만큼의 안쪽 여백을 추가
        .padding(.horizontal, 22)   // 왼쪽(Leading)과 오른쪽(Trailing)에 각각 22만큼의 안쪽 여백을 추가
    }
    
    /// 화살표 재사용하기 위한 하위 뷰
    /// - Parameters:
    ///   - name: 이미지 이름 설정
    ///   - action: 버튼이 가지는 액션 기능 넣기,
    /// - Returns: some View 타입 반환
    //  함수가 종료된 후에도 이 action이 메모리에 남아있다가 실행되어야 하므로 @escaping이 필요
    private func makeChevron(name: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: name)
                .resizable()
                .frame(width: 17.47, height: 29.73)
        })
    }
    
    /// 대표 영화 설정
    private var settingMovie: some View {
        Button(action: {
            /* 현재 인덱스의 영화 이름을 AppStorage에 저장 */
            self.movieName = viewModel.movieModel[viewModel.currentIndex].movieName
        }, label: {
            Text("대표 영화로 설정")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(Color.black)
                .padding(.top, 21)
                .padding(.bottom, 20)
                .padding(.leading, 53)
                .padding(.trailing, 52)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.clear)
                        .stroke(Color.black, style: .init(lineWidth: 1))
                })
        })
    }
    
    /// 하단 AppStorage에 저장된 영화 확인 텍스트
    private var printAppStorageValue: some View {
        VStack(spacing: 17) {
            Text("@AppStorage에 저장된 영화")
                .font(.system(size: 30, weight: .regular))
                .foregroundStyle(Color.black)
            
            Text("현재 저장된 영화 : \(movieName)")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(Color.red)
        }
    }
}

#Preview {
    MovieView()
}
