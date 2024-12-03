//
//  MapView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI
import MapKit

struct MapView: View {

    // MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
        @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel
    
    var body: some View {
        VStack (spacing: 0) {
            Map {
                ForEach(weatherMapPlaceViewModel.placeAnnotation.mapItems.indices, id: \.self) { index in
//                    Marker(item: weatherMapPlaceViewModel.placeAnnotation.mapItems[index])
//                        .tint(.red)
                    Marker(weatherMapPlaceViewModel.placeAnnotation.mapItems[index].name!, systemImage: "mappin", coordinate: weatherMapPlaceViewModel.placeAnnotation.mapItems[index].placemark.coordinate)
//                        .tint(.red)
                }
            }
        
            Text("Top 5 Tourist Attractions in London")
                .font(.system(size: 25))
                .background(.gray)
                .padding(.top)
        
            List() {
                ForEach(weatherMapPlaceViewModel.placeAnnotation.mapItems.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: "mappin.circle.fill").resizable().frame(width: 35, height: 35)
                            .foregroundStyle(.red)
                        Text("\(weatherMapPlaceViewModel.placeAnnotation.mapItems[index].name ?? "")")
                            .font(.title3)
                    }
//                    .listRowInsets(.init())
                    .padding(0.53)
//                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity)
        .background(Image("sky").resizable().ignoresSafeArea())
        .onAppear {
            Task {
                try? await weatherMapPlaceViewModel.setAnnotations()
            }
        }

    }
}

#Preview {
    TabView {
        MapView()
            .tabItem {
                Label("Palce", systemImage: "map")
            }
            .environmentObject(WeatherMapPlaceViewModel())
    }
}
