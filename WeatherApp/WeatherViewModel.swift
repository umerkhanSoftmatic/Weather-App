import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherModel?
    @Published var fiveDayWeather: [DayWeather] = []
    @Published var city: String = ""
    @Published var errorMessage: String?
    @Published var isWeatherFetched: Bool = false
    
    private let weatherManager = WeatherManager()
    private let fiveDayWeatherManager = FiveDayWeatherManager()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather() {
        if city.isEmpty {
            errorMessage = "City name cannot be empty"
            return
        }
        
        weatherManager.fetchWeather(for: city)
            .receive(on: DispatchQueue.main)  
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = self.errorMessage(for: error)
                }
            }, receiveValue: { [weak self] fetchedWeather in
                self?.weather = fetchedWeather
                self?.isWeatherFetched = true
                self?.errorMessage = nil
            })
            .store(in: &cancellables)
    }
    
   
    func fetchFiveDayWeather() {
        if city.isEmpty {
            errorMessage = "City name cannot be empty"
            return
        }
        
        fiveDayWeatherManager.fetchFiveDayWeather(for: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = self.errorMessage(for: error)
                }
            }, receiveValue: { [weak self] fetchedFiveDayWeather in
                self?.fiveDayWeather = fetchedFiveDayWeather
            })
            .store(in: &cancellables)
    }
    
    func reset() {
        weather = nil
        fiveDayWeather = []
        city = ""
        errorMessage = nil
        isWeatherFetched = false
    }
    
   
    func errorMessage(for error: Error) -> String {
        switch error {
        case WeatherError.invalidURL:
            return "Invalid URL"
        case WeatherError.networkError:
            return "Network error. Please try again."
        case WeatherError.decodingError:
            return "Failed to decode weather data."
        default:
            return "An unknown error occurred."
        }
    }
}
