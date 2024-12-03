//
//  DataController.swift
//  CWKTemplate24
//
//  Created by Abubakr Rizan on 2024-11-30.
//

import Foundation
import CoreData



class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CityModel")
    
    
    init() {
        container.loadPersistentStores { description, error in
            if error != nil {
                fatalError("Something went wrong with loading database")
            }
        }
    }
    
    
}
