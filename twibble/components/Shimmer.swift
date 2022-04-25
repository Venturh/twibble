import SwiftUI

public struct Shimmer: View {
    @State private var opacity = 0.25
    @AppStorage("isCompact") var isCompact = false
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color("accentPrimary"))
            .opacity(opacity)
            .transition(.opacity)
            .frame(width: .infinity, height: isCompact ? 50 : 80)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 0.9)
                let repeated = baseAnimation.repeatForever(autoreverses: true)
                withAnimation(repeated) {
                    self.opacity = 1.0
                }
        }
    }
}
