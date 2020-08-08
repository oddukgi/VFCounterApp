//
//  PersistenceManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/08.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case update, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let userSettings = "VFCounterSettings"

    }
 
    static func updateWith(items: UserSettings, actionType: PersistenceActionType,
                            completed: @escaping(VFError?) -> Void) {
        
        retrieveUserSettings { result in
            switch result {
            case .success(var retrieveUserSettings):
                switch actionType {
                
                case .update:
                
                    if !retrieveUserSettings.isEmpty {
                    let index = retrieveUserSettings.firstIndex { ($0.alarmOn == items.alarmOn
                        || $0.taskPercent == items.taskPercent)}!
                        
                        retrieveUserSettings[index] = items
                    } else {
                        retrieveUserSettings.append(items)
                    }

                case .remove:
                    retrieveUserSettings.removeAll()
         
                }
                  completed(save(userSettings: retrieveUserSettings))
            case .failure(let error):
                completed(error)
                
            }
        }
    }
    
    
    static func retrieveUserSettings(completed: @escaping(Result<[UserSettings], VFError>) -> Void) {
        guard let userSettings = defaults.object(forKey: Keys.userSettings) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let usersettingData = try decoder.decode([UserSettings].self, from: userSettings)
            completed(.success(usersettingData))
        } catch {
            print(error.localizedDescription)
            completed(.failure(.updateError))
        }
        
    }
    
    static func save(userSettings: [UserSettings]) -> VFError? {
    
         do {
             let encoder = JSONEncoder()
             let encoderFavorites = try encoder.encode(userSettings)
            defaults.set(encoderFavorites, forKey: Keys.userSettings)
             return nil
        } catch {
            return .updateError
        }
    }
}
