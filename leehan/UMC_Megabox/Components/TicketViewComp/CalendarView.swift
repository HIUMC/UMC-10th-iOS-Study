import SwiftUI

struct DateSelectionView: View {
    // 부모(ViewModel)로부터 현재 선택된 날짜를 받아옵니다.
    let selectedDate: Date?
    
    // 날짜 버튼이 눌렸을 때 부모에게 알려줄 클로저입니다.
    let onDateSelected: (Date) -> Void
    
    let weekDates: [Date] = {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }()
    
    var body: some View {
        // ✨ 전체 캘린더에 대한 좌우 패딩(.padding(.horizontal))을 제거했습니다.
        ScrollView(.horizontal, showsIndicators: false) {
            // ✨ 카드 하나하나의 패딩이 아닌, 카드 사이의 간격(spacing)은 12로 유지합니다.
            HStack(spacing: 12) {
                ForEach(Array(weekDates.enumerated()), id: \.element) { index, date in
                    DateCellButton(
                        date: date,
                        index: index,
                        isSelected: isSameDay(date1: selectedDate, date2: date)
                    ) {
                        onDateSelected(date)
                    }
                }
            }
            // (있던 좌우 패딩 삭제됨)
        }
    }
    
    // MARK: - 로직 도우미
    private func isSameDay(date1: Date?, date2: Date) -> Bool {
        guard let date1 = date1 else { return false }
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

// MARK: - 개별 날짜 버튼 셀
struct DateCellButton: View {
    let date: Date
    let index: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(topDateString(for: date, index: index))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isSelected ? .white : defaultTextColor(for: date))
                
                Text(bottomDayString(for: date, index: index))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : (defaultTextColor(for: date) == .black ? .gray : defaultTextColor(for: date)))
            }
            .frame(width: 56, height: 74)
            .background(isSelected ? Color.purple03 : Color.clear)
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 로직 도우미 함수들 (기존과 동일)
    private func topDateString(for date: Date, index: Int) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        if index == 0 { return "\(month).\(day)" }
        return "\(day)"
    }
    
    private func bottomDayString(for date: Date, index: Int) -> String {
        if index == 0 { return "오늘" }
        if index == 1 { return "내일" }
        let weekdays = ["", "일", "월", "화", "수", "목", "금", "토"]
        let weekdayIndex = Calendar.current.component(.weekday, from: date)
        return weekdays[weekdayIndex]
    }
    
    private func defaultTextColor(for date: Date) -> Color {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 7 { return .cyan }     // 토요일
        if weekday == 1 { return .red }      // 일요일
        return .black                        // 평일
    }
}


#Preview {
    DateSelectionView(selectedDate: Date()) { _ in }
        .background(Color.gray.opacity(0.1))
}
