//
//  WeatherMapPlaceViewModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation
import CoreLocation
import MapKit

class WeatherMapPlaceViewModel: ObservableObject {
    
    // MARK:   published variables section - add variables that you need here and not that default location must be London
    
    /* Add other published varaibles that you are required here, you have been given one main one
     */
    
    @Published var weatherDataModel: WeatherDataModel?
    @Published var placeAnnotation: PlaceAnnotationDataModel
    @Published var newLocation: String?
    @Published var airDataModel: AirDataModel?
    @Published var locationCoordinates: CLLocationCoordinate2D?
    
    // other attributes with suitable comments
    
    init(weatherDataModel: WeatherDataModel? = nil, placeAnnotation: PlaceAnnotationDataModel = PlaceAnnotationDataModel(mapItems: []), newLocation: String? = "London", locationCoordinates: CLLocationCoordinate2D? = nil, airDataModel: AirDataModel? = nil) {
        self.weatherDataModel = weatherDataModel
        self.placeAnnotation = placeAnnotation
        self.newLocation = newLocation
        self.locationCoordinates = locationCoordinates
        self.airDataModel = airDataModel
    }
    
    // MARK:  function to get coordinates safely for a place:
    
    func getCoordinatesForCity(city: String?) async throws -> Bool {
        let location = CLGeocoder()
        if let newLocation = newLocation {
            let locationObject = try? await location.geocodeAddressString(city ?? newLocation)
            if let locationObject = locationObject {
                await MainActor.run {
                    self.locationCoordinates = locationObject.first?.location?.coordinate
                }
                return true
            }
            return false
            // write code for this function with suitable comments
            }
            return false
        }
        // MARK:  function to fetch weather data safely from openweather using location coordinates
        
        func fetchWeatherData(lat: Double, lon: Double) async throws {
            
            let urlWeatherCurrent = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=116a6197ccda403b2dc4d82f92268517&units=metric")
            let urlAir = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=116a6197ccda403b2dc4d82f92268517")
            let urlWeatherHourly = URL(string: "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=\(lat)&lon=\(lon)&appid=116a6197ccda403b2dc4d82f92268517&cnt=48&units=metric")
            let urlWeatherDaily = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lon)&appid=116a6197ccda403b2dc4d82f92268517&cnt=8&units=metric")
            
            guard let unwrappedURLCurrentWeather = urlWeatherCurrent,
                    let unwrappedAir = urlAir,
                    let unwrappedHourlyWeather = urlWeatherHourly,
                    let unwrappedDailyWeather = urlWeatherDaily else {
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: unwrappedURLCurrentWeather)
                let (dataAir, _) = try await URLSession.shared.data(from: unwrappedAir)
                let (dataHourly, _) = try await URLSession.shared.data(from: unwrappedHourlyWeather)
                let (dataDaily, _) = try await URLSession.shared.data(from: unwrappedDailyWeather)
                let unwrappedDataCurrent = try JSONDecoder().decode(Current.self, from: data)
                let unwrappedDataAir = try JSONDecoder().decode(AirDataModel.self, from: dataAir)
                let unwrappedDataHourly = try JSONDecoder().decode(HourlyTemperature.self, from: dataHourly)
                let unwrappedDataDaily = try JSONDecoder().decode(DailyTemperature.self, from: dataDaily)
                
                DispatchQueue.main.async {
                    self.weatherDataModel = WeatherDataModel(lat: lat, lon: lon, timezone: nil, timezoneOffset: nil, current: unwrappedDataCurrent, minutely: nil, hourly: unwrappedDataHourly.list, daily: unwrappedDataDaily.list)
                    self.airDataModel = unwrappedDataAir
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        // MARK:  function to get tourist places safely for a  map region and store for use in showing them on a map
        
        func setAnnotations() async throws {
            
            // write code for this function with suitable comments
            if let locationCoordinates = locationCoordinates {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = "Tourist Attractions"
                request.resultTypes = .pointOfInterest
                request.region = MKCoordinateRegion(
                    center: locationCoordinates,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.0125,
                        longitudeDelta: 0.0125
                    )
                )
                let search = MKLocalSearch(request: request)
                let response = try? await search.start()
                if let unwrappedResponse = response {
                    await MainActor.run{
                        placeAnnotation.mapItems = Array(unwrappedResponse.mapItems[...4])
                    }
                }
            }
        }
    }
