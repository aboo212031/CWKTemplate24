//
//  VisitedPlacesView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI
import SwiftData

struct VisitedPlacesView: View {
/*
    Set up the @Environment(\.modelContext) for SwiftData's Model Context
    Use @Query to fetch data from SwiftData models
*/
//    @Environment(\.managedObjectContext) var manageObjectContext
    @Environment(\.modelContext) private var modelContext
    @Query private var cities: [LocationModel]
//    @FetchRequest(sortDescriptors: []) var cities: FetchedResults<CityEntity>
    
    var body: some View {
        VStack{
            Text("Weather Locations In Database")
                .bold()
                .font(.title2)
            List {
                ForEach(cities) { city in
                    HStack {
                        Text(city.name)
                            .bold()
                        Text("( \(city.latitude)")
                        Text("\(city.longitude) )")
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        let city = cities[index]
                        modelContext.delete(city)
                    }
                    try? modelContext.save()
                })
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.inset)
            Spacer()
        }
        .padding()
        .background(Image("sky").resizable().ignoresSafeArea())
    }
}

#Preview {
    VisitedPlacesView()
        .modelContainer(for: LocationModel.self, inMemory: true)
//        .environment(\.managedObjectContext, DataController().container.viewContext)
}
