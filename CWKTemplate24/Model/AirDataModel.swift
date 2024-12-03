//
//  AirDataModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation

/* Code for AirDataModel Struct */

struct AirDataModel: Codable{
    
    // MARK:  list of attributes to map response from openweather pollution api
    let list: [Info]
}

struct Info: Codable {
    let dt: Int
    let components: Components
//    let co: Double
//    let no: Double
//    let no2: Double
//    let o3: Double
//    let so2: Double
//    let pm2_5: Double
//    let pm10: Double
//    let nh3: Double
}

struct Components: Codable {
    let co: Double
    let no: Double
    let no2: Double
    let o3: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let nh3: Double
}
