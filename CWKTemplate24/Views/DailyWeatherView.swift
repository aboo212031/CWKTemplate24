//
//  DailyWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct DailyWeatherView: View {
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    var body: some View {
        ScrollView {
            ForEach(weatherMapPlaceViewModel.weatherDataModel?.daily?.indices ?? 0..<2, id: \.self) { index in
                HStack {
//                    Image("rain").resizable().frame(width: 50, height: 50)
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherMapPlaceViewModel.weatherDataModel?.daily?[index].weather[0].icon ?? "10d")@2x.png"))
                        .frame(width: 50, height: 50)
                    Spacer()
                    VStack {
                        Text("\(DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(Int( weatherMapPlaceViewModel.weatherDataModel?.daily?[index].dt ?? 0))))")
                        Text("\(weatherMapPlaceViewModel.weatherDataModel?.daily?[index].weather[0].weatherDescription.rawValue.capitalized ?? "Rain")")
                    }
                    Spacer()
                    HStack {
                        VStack {
                            Text("Day")
                            Text("\(Int(weatherMapPlaceViewModel.weatherDataModel?.daily?[index].temp.day ?? 0)) C")
                        }
                        VStack {
                            Text("Night")
                            Text("\(Int(weatherMapPlaceViewModel.weatherDataModel?.daily?[index].temp.night ?? 0)) C")
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(RoundedRectangle(cornerRadius: 5.0).stroke(lineWidth: 1.0))
            }
        }
        .padding()
    }
}

#Preview {
    DailyWeatherView()
        .background(Image("sky").resizable().ignoresSafeArea())
        .environmentObject(WeatherMapPlaceViewModel())
}
