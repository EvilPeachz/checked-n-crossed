import SwiftUI

struct LegalPadBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color(red: 0.98, green: 0.95, blue: 0.70)
                Canvas { context, size in
                    let lineSpacing: CGFloat = 30
                    var y: CGFloat = 20
                    while y < size.height {
                        var path = Path()
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(.blue.opacity(0.25)), lineWidth: 1)
                        y += lineSpacing
                    }

                    var margin = Path()
                    margin.move(to: CGPoint(x: 42, y: 0))
                    margin.addLine(to: CGPoint(x: 42, y: size.height))
                    context.stroke(margin, with: .color(.red.opacity(0.4)), lineWidth: 2)
                }
                .overlay(.white.opacity(0.05))
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}
