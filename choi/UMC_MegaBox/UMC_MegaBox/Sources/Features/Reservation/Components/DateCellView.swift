import SwiftUI

/// 날짜 선택 셀 (날짜 숫자 + 요일 텍스트)
struct DateCellView: View {
    let day: CalendarDay
    let isSelected: Bool
    let isEnabled: Bool
    let onSelect: () -> Void

    var body: some View {
        Button {
            guard isEnabled else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                onSelect()
            }
        } label: {
            VStack(spacing: 4) {
                // 날짜 숫자 (월.일 형태 for 오늘, 아니면 숫자만)
                if day.isToday {
                    Text("\(Calendar.current.component(.month, from: day.date)).\(day.day)")
                        .font(.pretendardBold18)
                        .foregroundStyle(dayNumberColor)
                } else {
                    Text("\(day.day)")
                        .font(.pretendardBold18)
                        .foregroundStyle(dayNumberColor)
                }

                // 요일 (오늘은 "오늘", 내일은 "내일")
                Text(weekdayString)
                    .font(.pretendardSemiBold14)
                    .foregroundStyle(weekdayColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(isSelected ? Color(.purple03) : Color.clear)
            .cornerRadius(8)
        }
        .disabled(!isEnabled)
    }

    // MARK: - Private

    private var weekdayString: String {
        if day.isToday { return "오늘" }
        if day.isTomorrow { return "내일" }
        return day.weekdaySymbol
    }

    private var weekdayColor: Color {
        if !isEnabled { return Color(.gray02) }
        if isSelected { return .white }
        return Color(.gray07)
    }

    private var dayNumberColor: Color {
        if !isEnabled { return Color(.gray02) }
        if isSelected { return .white }
        if day.isSunday { return Color(.sunday) }
        if day.isSaturday { return Color(.saturday) }
        return Color(.gray07)
    }
}
