//
//  NetworkManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/19.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

struct URLManager {
   
    private static let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    private static let apiKey = "YOUR_API_KEY"
    
    static func openWeatherURL(from lat: String, to lon: String) -> URL {
        var components = URLComponents(string: baseURL)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
                           "lat": lat,
                           "lon": lon,
                           "units" : "metric",
                           "appid": apiKey
                        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
}

class NetworkManager {
    
    static let shared = NetworkManager()
    let cache         = NSCache<NSString, UIImage>()

    // MARK: get current weather info
    func getAreaWeatherInfo(from lat: String, to lon: String, completion: @escaping (Result<WeatherData, VFError>) -> Void) {
        let endpoint = URLManager.openWeatherURL(from: lat, to: lon)
    
        print(endpoint.absoluteString)
        let task = URLSession.shared.dataTask(with: endpoint) { [weak self] (data, response, error) in
            
            guard let _ = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data else {
                    completion(.failure(.emptyData))
                    return
                }
            
            do {
            
                let decoder = JSONDecoder()          
                let weatherData = try decoder.decode(WeatherData.self, from: data)

                completion(.success(weatherData))
             
            } catch {
                completion(.failure(.invalidData))
                
            }
        }
        task.resume()
    }
    
   // MARK: download weather icon
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {

        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data:  data) else {
                    completion(nil)
                    return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        
        task.resume()
    }
    
}
