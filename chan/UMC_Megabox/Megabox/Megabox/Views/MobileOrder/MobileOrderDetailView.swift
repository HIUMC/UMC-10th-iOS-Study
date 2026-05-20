import SwiftUI

struct MobileOrderDetailView: View {
    let items: [MenuItemModel]
    let selectedTheater: String

    @Environment(\.dismiss) private var dismiss
    @State private var isTheaterPickerPresented = false

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                TheaterChangeBar(selectedTheater: selectedTheater) {
                    isTheaterPickerPresented = true
                }
                .theaterBarStyle(
                    foreground: .black,
                    background: .white,
                    border: Color.gray.opacity(0.18)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                Divider()

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(items) { item in
                            MenuItemCard(item: item)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog("극장 선택", isPresented: $isTheaterPickerPresented, titleVisibility: .visible) {
            Button("강남") { }
            Button("홍대") { }
            Button("신촌") { }
        }
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }

            Spacer()

            Text("바로주문")
                .font(.system(size: 16, weight: .bold))

            Spacer()

            Button { } label: {
                Image(systemName: "cart")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 14)
    }
}

#Preview {
    NavigationStack {
        MobileOrderDetailView(
            items: MobileOrderViewModel().items,
            selectedTheater: "강남"
        )
    }
}
