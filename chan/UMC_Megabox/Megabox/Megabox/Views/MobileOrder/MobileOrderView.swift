import SwiftUI

struct MobileOrderView: View {
    @StateObject private var vm = MobileOrderViewModel()
    @State private var isTheaterPickerPresented = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.white.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        Image("meboxLogo 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .padding(.top, 8)

                        TheaterChangeBar(selectedTheater: vm.selectedTheater) {
                            isTheaterPickerPresented = true
                        }
                        .theaterBarStyle(foreground: .white, background: Color.megaPurple)

                        featureGrid
                        menuSection(title: "추천 메뉴", subtitle: "영화 볼때 뭐먹지 고민될 때 추천 메뉴!", items: vm.recommendedItems)
                        menuSection(title: "베스트 메뉴", subtitle: "영화 볼때 뭐먹지 고민될 때 베스트 메뉴!", items: vm.bestItems)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 110)
                }
            }
            .navigationBarHidden(true)
            .confirmationDialog("극장 선택", isPresented: $isTheaterPickerPresented, titleVisibility: .visible) {
                ForEach(vm.theaters, id: \.self) { theater in
                    Button("메가박스 \(theater)") {
                        vm.selectedTheater = theater
                    }
                }
            }
        }
    }

    private var featureGrid: some View {
        VStack(spacing: 18) {
            HStack(alignment: .top, spacing: 18) {
                NavigationLink {
                    MobileOrderDetailView(items: vm.items, selectedTheater: vm.selectedTheater)
                } label: {
                    FeatureTile(
                        title: "바로 주문",
                        subtitle: "이제 줄서지 말고\n모바일로 주문하고 픽업!",
                        systemImage: "popcorn",
                        size: .large
                    )
                }
                .buttonStyle(.plain)

                VStack(spacing: 18) {
                    FeatureTile(title: "스토어 교환권", subtitle: nil, systemImage: "ticket", size: .small)
                    FeatureTile(title: "선물하기", subtitle: nil, systemImage: "gift", size: .small)
                }
            }

            FeatureTile(
                title: "어디서든 팝콘 만나기",
                subtitle: "팝콘 플라스 스낵 모드 메뉴 배달 가능!",
                systemImage: "truck.box",
                size: .wide
            )
        }
    }

    private func menuSection(title: String, subtitle: String, items: [MenuItemModel]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 22, weight: .black))

                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        MenuItemCard(item: item)
                            .frame(width: 158)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

private struct FeatureTile: View {
    enum TileSize {
        case large
        case small
        case wide
    }

    let title: String
    let subtitle: String?
    let systemImage: String
    let size: TileSize

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: size == .small ? 20 : 22, weight: .black))
                .foregroundStyle(.black)

            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
            }

            Spacer()

            HStack {
                Spacer()
                Image(systemName: systemImage)
                    .font(.system(size: size == .small ? 32 : 38, weight: .semibold))
                    .foregroundStyle(.black)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
    }

    private var height: CGFloat {
        switch size {
        case .large:
            return 310
        case .small:
            return 146
        case .wide:
            return 105
        }
    }
}

#Preview {
    MobileOrderView()
}
