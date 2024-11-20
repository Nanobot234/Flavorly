import SwiftUI

struct ActivityIndicator: View {
    @State var text: String
    var tintColor: Color = .white // Default tint color for the progress indicator
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
                .scaleEffect(2) // You can adjust the scale if necessary
            
            Text(text)
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 20)
        }
        .frame(width: 200, height: 200)
        .background(Color.black.opacity(0.7)) // More visible background opacity
        .cornerRadius(25)
        .shadow(radius: 10) // Adds a subtle shadow for better visibility
        .padding(40) // Add padding to ensure it doesn’t stick to screen edges
    }
}

#Preview {
    ActivityIndicator(text: "Loading... Please Wait")
}

