//
//  CurrentWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct CurrentWeatherView: View {

// MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

// MARK:  set up local @State variable to support this view
    var body: some View {
        VStack {
            Text("\(weatherMapPlaceViewModel.newLocation!)")
                .font(.title2)
                .padding()
            Text("\(DateFormatterUtils.formattedDateTime(from: TimeInterval(Int( weatherMapPlaceViewModel.weatherDataModel?.current.dt ?? 0))))")
                .bold()
            
            VStack {
                
                Spacer()
                
                HStack {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherMapPlaceViewModel.weatherDataModel?.current.weather[0].icon ?? "10d")@2x.png"))
                        .frame(width: 50, height: 50)
//                    Image("temperature").resizable().frame(width: 50, height: 50)
                    VStack {
                        Text("\(weatherMapPlaceViewModel.weatherDataModel?.current.weather[0].weatherDescription.rawValue.capitalized ?? "")")
                        Text("Feels Like \(Int((weatherMapPlaceViewModel.weatherDataModel?.current.main.feels_like ?? 0))) C")
                    }
                }
                .frame(width: 250, alignment: .leading)
                HStack {
                    Image("temperature").resizable().frame(width: 50, height: 50)
                    Text("H: \(Int((weatherMapPlaceViewModel.weatherDataModel?.current.main.temp_max ?? 0))) C")
                    Text("L: \(Int((weatherMapPlaceViewModel.weatherDataModel?.current.main.temp_min ?? 0))) C")
                }
                .frame(width: 250, alignment: .leading)
                HStack {
                    Image("windSpeed").resizable().frame(width: 50, height: 50)
                    Text("Wind Speed: \(String(format: "%.1f", weatherMapPlaceViewModel.weatherDataModel?.current.wind.speed ?? 0)) m/s")
                }
                .frame(width: 250, alignment: .leading)
                HStack {
                    Image("humidity").resizable().frame(width: 50, height: 50)
                    Text("Humidity: \(weatherMapPlaceViewModel.weatherDataModel?.current.main.humidity ?? 0)%")
                }
                .frame(width: 250, alignment: .leading)
                HStack {
                    Image("pressure").resizable().frame(width: 50, height: 50)
                    Text("Pressure: \(weatherMapPlaceViewModel.weatherDataModel?.current.main.pressure ?? 0) hPa")
                }
                .frame(width: 250, alignment: .leading)
                
                Spacer()
                
                Text("Current Air Quality in \(weatherMapPlaceViewModel.newLocation ?? "")")
                    .bold()
//                ScrollView(.horizontal) {
                    HStack(spacing:50) {
                        VStack {
                            Image("so2").resizable().frame(width: 50, height: 50)
                            Text("\(String(format: "%.1f",weatherMapPlaceViewModel.airDataModel?.list.first?.components.so2 ?? ""))")
                        }
                        VStack {
                            Image("no").resizable().frame(width: 50, height: 50)
                            Text("\(String(format: "%.1f",weatherMapPlaceViewModel.airDataModel?.list.first?.components.no ?? ""))")
                        }
                        VStack {
                            Image("voc").resizable().frame(width: 50, height: 50)
                            Text("\(String(format: "%.1f",weatherMapPlaceViewModel.airDataModel?.list.first?.components.co ?? ""))")
                        }
                        VStack {
                            Image("pm").resizable().frame(width: 50, height: 50)
                            Text("\(String(format: "%.1f",weatherMapPlaceViewModel.airDataModel?.list.first?.components.pm10 ?? ""))")
                        }
                    }
                    .background(Image("BG").resizable())
//                }
//                .padding()
                
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("sky").resizable().ignoresSafeArea())

    }
}

#Preview {
    CurrentWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
