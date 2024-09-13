
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = WeatherViewModel()

    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.cyan, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .top)

            VStack {
                if viewModel.isWeatherFetched {
                    if let weather = viewModel.weather {
                        Text("Temperature: \(weather.main.temp)°C")
                        Text("Humidity: \(weather.main.humidity)%")
                        Text("Description: \(weather.weather.first?.description ?? "N/A")")
                    }

                  
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.fiveDayWeather, id: \.date) { day in
                                WeatherCardView(date: day.date, temperature: day.temperature, description: day.description)
                            }
                        }
                        .padding()
                    }

                    Button("More") {
                        viewModel.reset()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                } else {
                    TextField("Enter city name", text: $viewModel.city)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.5))
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)




                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        viewModel.fetchWeather()
                        viewModel.fetchFiveDayWeather()
                    }) {
                        Text("Fetch Weather")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.3))
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            .padding(.horizontal)
        }
    }
}

