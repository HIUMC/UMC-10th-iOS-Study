
import SwiftUI

// viewModel에 있는 currentIndex를 바꾸려고 함

struct MovieController : View{
    // 1. 모델 데이터 선언
    let movieViewModel: MovieViewModel
    
    // 2. 초기화 함수 (직접 작성하신 버전)
    init(movieViewModel: MovieViewModel) {
        self.movieViewModel = movieViewModel
    }
    
    var body : some View{
        HStack{
            Button{
                movieViewModel.previousMovie()
            } label: {
                Image(systemName:"chevron.left")
                    .font(.system(size: 40, weight:.bold))
                    .foregroundStyle(Color.black)
            }
            
            Text("영화 바꾸기")
                .padding(.horizontal,61)
            
            
            Button{
                movieViewModel.nextMovie()
            } label: {
                Image(systemName:"chevron.right")
                    .font(.system(size: 40, weight:.bold))
                    .foregroundStyle(Color.black)
            }
        }
        .padding(.horizontal, 22) //
        .padding(.vertical, 17)   //
        .background(Color.white)   //
    }
    
}
