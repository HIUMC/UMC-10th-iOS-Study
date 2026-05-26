import SwiftUI

struct MobileOrderDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let item: MenuItemModel
    let branchName: String

    private let columns = [
        GridItem(.flexible(), spacing: 15, alignment: .top),
        GridItem(.flexible(), spacing: 15, alignment: .top)
    ]

    var body: some View {
        VStack(spacing: 0) {
            TheaterChangeBar(branchName: branchName)
                .theaterChangeBarStyle(.detail)

            Divider()
                .background(Color(.gray02))

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 30) {
                    ForEach(orderItems) { orderItem in
                        MenuItemCardView(item: orderItem)
                            .menuItemCardPresentation(.grid)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .padding(.bottom, 60)
            }
        }
        .background(Color(.white).ignoresSafeArea())
        .navigationTitle("바로주문")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(.black))
                        .frame(width: 44, height: 44)
                        .liquidGlassButton(
                            fillColor: .white.opacity(0.65),
                            strokeColor: Color(.gray02).opacity(0.70),
                            shadowColor: Color(red: 221 / 255, green: 221 / 255, blue: 221 / 255).opacity(0.28)
                        )
                }
                .buttonStyle(.plain)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "cart")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(.black))
                        .frame(width: 44, height: 44)
                        .liquidGlassButton(
                            fillColor: .white.opacity(0.65),
                            strokeColor: Color(.gray02).opacity(0.70),
                            shadowColor: Color(red: 221 / 255, green: 221 / 255, blue: 221 / 255).opacity(0.28)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var orderItems: [MenuItemModel] {
        MobileOrderMenuStore.directOrderItems
    }
}

#Preview {
    NavigationStack {
        MobileOrderDetailView(item: MobileOrderMenuStore.featuredItem, branchName: "강남")
    }
}
