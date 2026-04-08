import SwiftUI

struct QuickActionsRow: View {
    var body: some View {
        HStack(spacing: 0) {
            QuickActionButton(imageName: "영화관예매")
            QuickActionButton(imageName: "극장별예매")
            QuickActionButton(imageName: "특별관예매")
            QuickActionButton(imageName: "모바일오더")
        }
    }
}
