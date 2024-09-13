import Foundation
import Combine


class FiveDayWeatherManager {
    private let apiKey = "3bcb2a15d238c6a800c1c3aa6fe28295"
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
    
    
    func fetchFiveDayWeather(for city: String) -> AnyPublisher<[DayWeather], WeatherError> {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?q=\(encodedCity)&appid=\(apiKey)&units=metric") else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FiveDayWeather.self, decoder: JSONDecoder())
            .map { forecast in
                forecast.list.prefix(5).map { weatherData in
                    DayWeather(date: weatherData.dt_txt,
                               temperature: weatherData.main.temp,
                               description: weatherData.weather.first?.description ?? "N/A")
                }
            }
            .mapError { _ in WeatherError.networkError }
            .eraseToAnyPublisher()
    }
}




