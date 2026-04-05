import SwiftUI
import Foundation

struct MovieView: View {
    // 1. 뷰모델을 이 화면의 주인으로서 생성합니다. (@State 사용)
    @State private var viewModel = MovieViewModel()
    @AppStorage("mainMovie") private var mainMovie: String = "대표 영화를 설정해주세요"
    var body: some View {
            VStack(spacing: 30) {
                MovieCard(movieInfo: viewModel.movieModel[viewModel.currentIndex])
                Spacer()
                    .frame(maxHeight: 50)
                MovieController(movieViewModel : viewModel)
                Spacer()
                
                /*
                 MainMovieSettingButton으로 이름 지어야겠다.
                 
                 */
                
                MainMovieSettingButton(movieViewModel: viewModel)
                
                // @AppStorage에 저장된 영화
                Text("@AppStorage에 저장된 영화")
                    .font(.title)
                // 현재 저장된 영화 : 호퍼스
                Text("현재 저장된 영화 : \(mainMovie)")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
            }
            .padding()
        
    }
}

#Preview() {
    MovieView()
}
