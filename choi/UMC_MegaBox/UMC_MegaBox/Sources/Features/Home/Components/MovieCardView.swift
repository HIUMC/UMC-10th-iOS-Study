import Kingfisher
import SwiftUI

/// 홈 화면 영화 카드 (포스터 + 바로예매 + 제목 + 관객수)
struct MovieCardView: View {
    let movie: MovieModel
    let onBookTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            posterImage
                .frame(width: 140, height: 200)
                .clipped()
                .cornerRadius(8)

            Button(action: onBookTap) {
                Text("바로 예매")
                    .font(.pretendardSemiBold12)
                    .foregroundStyle(Color(.purple03))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.purple03), lineWidth: 1)
                    )
            }
            .padding(.top, 8)

            Text(movie.title)
                .font(.pretendardSemiBold14)
                .foregroundStyle(Color(.gray07))
                .lineLimit(1)
                .padding(.top, 8)

            Text(movie.formattedAudienceCount)
                .font(.pretendardRegular12)
                .foregroundStyle(Color(.gray03))
                .padding(.top, 2)
        }
        .frame(width: 140)
    }

    @ViewBuilder
    private var posterImage: some View {
        if let posterURL = movie.posterURL {
            KFImage(posterURL)
                .placeholder {
                    ProgressView()
                        .frame(width: 140, height: 200)
                }
                .fade(duration: 0.2)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else if !movie.posterImage.isEmpty {
            Image(movie.posterImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.gray02))
                .overlay {
                    Text(movie.title)
                        .font(.pretendardSemiBold14)
                        .foregroundStyle(Color(.gray06))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.horizontal, 8)
                }
        }
    }
}
