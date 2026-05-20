import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    let movie: MovieModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                backdropImage

                VStack(alignment: .leading, spacing: 16) {
                    Text(movie.title)
                        .font(.system(size: 28, weight: .bold))
                        .lineLimit(2)

                    HStack(spacing: 12) {
                        Text("\(movie.ageRating)세 관람가")
                        Text(movie.releaseDate.isEmpty ? "개봉일 미정" : movie.releaseDate)
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)

                    detailSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var backdropImage: some View {
        if let backdropURL = movie.backdropURL {
            KFImage(backdropURL)
                .placeholder {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 240)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 240)
                .clipped()
        } else {
            Image(movie.posterImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 240)
                .clipped()
        }
    }

    private var detailSection: some View {
        HStack(alignment: .top, spacing: 16) {
            posterThumbnail

            VStack(alignment: .leading, spacing: 12) {
                labeledText(title: "원제목", value: movie.originalTitle)
                labeledText(title: "개봉일", value: movie.releaseDate)
                labeledText(title: "개요", value: movie.overview)
            }
        }
    }

    @ViewBuilder
    private var posterThumbnail: some View {
        if let posterURL = movie.posterURL {
            KFImage(posterURL)
                .placeholder {
                    ProgressView()
                        .frame(width: 110, height: 158)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 110, height: 158)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            Image(movie.posterImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 110, height: 158)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private func labeledText(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.secondary)
            Text(value.isEmpty ? "-" : value)
                .font(.system(size: 15))
                .foregroundStyle(.primary)
        }
    }
}
