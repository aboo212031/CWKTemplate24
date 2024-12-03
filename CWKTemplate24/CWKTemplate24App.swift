//
//  CWKTemplate24App.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI
import SwiftData

@main
struct CWKTemplate24App: App {
    // MARK:  create a StateObject - weatherMapPlaceViewModel and inject it as an environmentObject.
    @StateObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel = WeatherMapPlaceViewModel()
//    @StateObject private var dataController: DataController = DataController()

    var body: some Scene {
        WindowGroup {
            NavBarView()
                .environmentObject(weatherMapPlaceViewModel)
//                .environment(\.managedObjectContext, dataController.container.viewContext)
        // MARK:  Create a database to store locations using SwiftData
        }
        .modelContainer(for: [LocationModel.self])
    }
}
