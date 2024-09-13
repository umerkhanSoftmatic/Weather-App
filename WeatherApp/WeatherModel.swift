import Foundation

struct WeatherModel: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
}


// DayWeather model for storing 5-day weather data

struct FiveDayWeather: Codable {
    let list: [WeatherData]
    
    struct WeatherData: Codable {
        let dt_txt: String
        let main: Main
        let weather: [Weather]
        
        struct Main: Codable {
            let temp: Double
        }
        
        struct Weather: Codable {
            let description: String
        }
    }
}



struct DayWeather {
    let date: String
    let temperature: Double
    let description: String
}


