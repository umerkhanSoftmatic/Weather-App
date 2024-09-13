
import SwiftUI

struct WeatherCardView: View {
    let date: String
    let temperature: Double
    let description: String

    var body: some View {
        VStack(spacing: 10) {
            Text(date)
                .font(.headline)
            Text("\(temperature, specifier: "%.1f")°C")
                .font(.largeTitle)
            Text(description)
                .font(.subheadline)
        }
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        .frame(width: 150, height: 200)
    }
}

#Preview {
    WeatherCardView(date: "Mon", temperature: 22.0, description: "Cloudy")
}
