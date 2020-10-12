//
//  AreaWeather.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/19.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

struct WeatherData: Codable {

    let coord: Coord?
    let weather: [Weather]
    let main: Main?
    let wind: Wind?
    let name: String?
}

struct Coord: Codable {

    let lon: Double?
    let lat: Double?

}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?

}

struct Main: Codable {

  let temp: Double?
  let feels_like: Double?
  let temp_min: Double?
  let temp_max: Double?
  let pressure: Int?
  let humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp, feels_like, temp_min, temp_max, pressure, humidity
    }
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}

struct Clouds: Codable {

    let all: Int?
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?

}
