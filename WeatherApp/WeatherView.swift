import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State var selectedTab: Int = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
            }

        }
    }
}



#Preview {
    WeatherView()
}

