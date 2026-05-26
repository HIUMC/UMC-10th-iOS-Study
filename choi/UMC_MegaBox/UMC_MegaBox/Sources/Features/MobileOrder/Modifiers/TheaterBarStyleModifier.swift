import SwiftUI

struct TheaterChangeBarStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let buttonBackgroundColor: Color
    let buttonForegroundColor: Color
    let buttonBorderColor: Color
    let buttonShadowColor: Color
    let shadowColor: Color

    static let primary = TheaterChangeBarStyle(
        backgroundColor: Color(.purple03),
        foregroundColor: .white,
        buttonBackgroundColor: Color(red: 151 / 255, green: 71 / 255, blue: 255 / 255),
        buttonForegroundColor: .white,
        buttonBorderColor: .white.opacity(0.35),
        buttonShadowColor: Color(red: 221 / 255, green: 221 / 255, blue: 221 / 255),
        shadowColor: .clear
    )

    static let detail = TheaterChangeBarStyle(
        backgroundColor: .white,
        foregroundColor: Color(.black),
        buttonBackgroundColor: .white.opacity(0.65),
        buttonForegroundColor: Color(.black),
        buttonBorderColor: Color(.gray02).opacity(0.70),
        buttonShadowColor: Color(red: 221 / 255, green: 221 / 255, blue: 221 / 255),
        shadowColor: .clear
    )
}

private struct TheaterChangeBarStyleKey: EnvironmentKey {
    static let defaultValue = TheaterChangeBarStyle.primary
}

extension EnvironmentValues {
    var theaterChangeBarStyle: TheaterChangeBarStyle {
        get { self[TheaterChangeBarStyleKey.self] }
        set { self[TheaterChangeBarStyleKey.self] = newValue }
    }
}

struct TheaterBarStyleModifier: ViewModifier {
    let style: TheaterChangeBarStyle

    func body(content: Content) -> some View {
        content.environment(\.theaterChangeBarStyle, style)
    }
}

extension View {
    func theaterChangeBarStyle(_ style: TheaterChangeBarStyle) -> some View {
        modifier(TheaterBarStyleModifier(style: style))
    }
}
