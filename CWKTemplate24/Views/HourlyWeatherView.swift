//
//  HourlyWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct HourlyWeatherView: View {

    // MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel
    @State var arrayOfData = Array([])

    var body: some View {
       VStack {
           Text("Hourly Forecast Weather for \(weatherMapPlaceViewModel.newLocation ?? "")")
                .font(.title)
                .padding()

            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(weatherMapPlaceViewModel.weatherDataModel?.hourly?.indices ?? 0..<2, id: \.self) { index in
                        VStack {
                            Text("\(DateFormatterUtils.formattedDateWithDay(from: TimeInterval(Int( weatherMapPlaceViewModel.weatherDataModel?.hourly?[index].dt ?? 0))))")
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherMapPlaceViewModel.weatherDataModel?.hourly?[index].weather[0].icon ?? "10d")@2x.png"))
                                .frame(width: 50, height: 50)
//                            Image("rain").resizable().frame(width: 50, height: 50)
                            Text("\(Int( weatherMapPlaceViewModel.weatherDataModel?.hourly?[index].main.temp ?? 0)) C")
                            Text("\(weatherMapPlaceViewModel.weatherDataModel?.hourly?[index].weather[0].weatherDescription.rawValue.capitalized ?? "Rain")")
                                .frame(height: 50)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 100)
                        .background(.cyan)
                    }
                }
            }
        }    }
}
#Preview {
    HourlyWeatherView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("sky").resizable().ignoresSafeArea())
        .environmentObject(WeatherMapPlaceViewModel())
}
