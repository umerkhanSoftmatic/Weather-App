import Foundation
import Combine


class WeatherManager {
    let apiKey = "3bcb2a15d238c6a800c1c3aa6fe28295"
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for city: String) -> AnyPublisher<WeatherModel, WeatherError> {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?q=\(encodedCity)&appid=\(apiKey)&units=metric") else {
            print("Invalid URL for city: \(city)")
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }

        print("Fetching weather data for URL: \(url)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received Data: \(jsonString)")  // Debug the received raw data
                }
            })
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .mapError { error in
                print("Error occurred: \(error.localizedDescription)") // Print error details
                if (error as? URLError) != nil {
                    return WeatherError.networkError
                } else if (error as? DecodingError) != nil {
                    return WeatherError.decodingError
                } else {
                    return WeatherError.networkError
                }
            }
            .eraseToAnyPublisher()
    }
}
