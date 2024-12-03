//
//  NavBarView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI
import CoreLocation
import MapKit
import SwiftData

struct NavBarView: View {
    @State var locationInput: String = ""
    @EnvironmentObject var weatherMapPlaceView: WeatherMapPlaceViewModel
//    @Environment(\.managedObjectContext) var manageObjectContext
//    @FetchRequest(sortDescriptors: []) var cities: FetchedResults<CityEntity>
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.modelContext) private var modelContext
    @Query private var cities: [LocationModel]
    
    
    // MARK:  Varaible section - set up variable to use WeatherMapPlaceViewModel and SwiftData

    /*
     set up the @EnvironmentObject for WeatherMapPlaceViewModel
     Set up the @Environment(\.modelContext) for SwiftData's Model Context
     Use @Query to fetch data from SwiftData models

     State variables to manage locations and alertmessages
     */

    // MARK:  Configure the look of tab bar

//    init() {
////         Customize TabView appearance
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .clear
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }

    var body: some View {
            VStack(alignment: .center, spacing: 0) {
                // MARK:  Add view(s) that are common to all tabbed views e.g. - images, textfields, etc
                HStack {
                    Text("Change Location")
                    TextField("Enter New Location", text: $locationInput)
                        .textFieldStyle(.roundedBorder)
                        .shadow(color: .blue, radius: 10)
                        .onSubmit {
                            Task {
                                if cities.contains(where: { city in
                                    city.name == locationInput
                                }) {
                                    let city = cities.first { city in
                                        city.name == locationInput
                                    }
                                    weatherMapPlaceView.newLocation = city?.name
                                    let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: city!.latitude, longitude: city!.longitude)
                                    weatherMapPlaceView.locationCoordinates = coordinates
                                    alertMessage = "Location found in database wil not perform geo-coding will use existing coordinates"
                                    weatherMapPlaceView.newLocation = locationInput
                                    try await weatherMapPlaceView.setAnnotations()
                                    try? await weatherMapPlaceView.fetchWeatherData(lat: weatherMapPlaceView.locationCoordinates!.latitude, lon: weatherMapPlaceView.locationCoordinates!.longitude)
                                    showingAlert = true
                                }
                                 else if (try await weatherMapPlaceView.getCoordinatesForCity(city: locationInput)) {
//                                    let newCity = CityEntity(context: manageObjectContext)
//                                    newCity.name = locationInput
//                                    newCity.latitude = weatherMapPlaceView.locationCoordinates!.latitude
//                                    newCity.longitude = weatherMapPlaceView.locationCoordinates!.longitude
                                     let newCity = LocationModel(name: locationInput, latitude: weatherMapPlaceView.locationCoordinates!.latitude, longitude: weatherMapPlaceView.locationCoordinates!.longitude)
                                    modelContext.insert(newCity)
                                    try? modelContext.save()
                                    alertMessage = "Location not found in database wil be added"
                                    showingAlert = true
                                    weatherMapPlaceView.newLocation = locationInput
                                    try await weatherMapPlaceView.setAnnotations()
                                    try? await weatherMapPlaceView.fetchWeatherData(lat: weatherMapPlaceView.locationCoordinates!.latitude, lon: weatherMapPlaceView.locationCoordinates!.longitude)
                                 } else {
                                     alertMessage = "Invalid Location Entered"
                                     showingAlert = true
                                 }
                                locationInput = ""
                            }
                        }
                }
                .frame(maxWidth: .infinity ,alignment: .center)
                .padding()
                .background(Image("BG").resizable().ignoresSafeArea())
            TabView {
                CurrentWeatherView()
                    .tabItem{
                        Label("Now", systemImage:  "sun.max.fill")
                    }

                ForecastWeatherView()
                    .tabItem{
                        Label("5-Day Weather", systemImage: "calendar")
                    }
                MapView()
                    .tabItem {
                        Label("Place Map", systemImage: "map")
                    }
                VisitedPlacesView()
                    .tabItem{
                        Label("Stored Places", systemImage: "globe")
                    }
            } // TabView
            .onAppear {
                Task {
                    // MARK:  Write code to manage what happens when this view appears
                    let _ = try? await weatherMapPlaceView.getCoordinatesForCity(city: nil)
                    try? await weatherMapPlaceView.fetchWeatherData(lat: weatherMapPlaceView.locationCoordinates!.latitude, lon: weatherMapPlaceView.locationCoordinates!.longitude)
                }
            }

        }//VStack - Outer
        // add frame modifier and other modifiers to manage this view
        .alert(alertMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
    }
}

#Preview {
    NavBarView()
        .environmentObject(WeatherMapPlaceViewModel())
//        .environment(\.managedObjectContext, DataController().container.viewContext)
        .modelContainer(for: LocationModel.self, inMemory: true)
}
