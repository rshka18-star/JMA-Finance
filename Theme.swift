
import SwiftUI

enum JMATheme {
    static let bg = Color(red: 0.02, green: 0.07, blue: 0.13)
    static let panel = Color(red: 0.04, green: 0.12, blue: 0.22)
    static let blue = Color.cyan
    static let green = Color.green
    static let red = Color.red
    static let gold = Color.yellow
}

struct NeonCard<Content: View>: View {
    var color: Color = JMATheme.blue
    @ViewBuilder var content: Content

    init(color: Color = JMATheme.blue, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(JMATheme.panel.opacity(0.92))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(color.opacity(0.8), lineWidth: 1.3)
            )
            .shadow(color: color.opacity(0.22), radius: 12)
    }
}

struct JMALogoView: View {
    var body: some View {
        VStack(spacing: -4) {
            Text("JMA")
                .font(.system(size: 54, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [.white, .gray, .white], startPoint: .top, endPoint: .bottom)
                )
                .shadow(color: .blue.opacity(0.55), radius: 8)
            Text("FINANCE")
                .font(.headline.weight(.black))
                .foregroundStyle(.red)
                .tracking(4)
        }
    }
}
