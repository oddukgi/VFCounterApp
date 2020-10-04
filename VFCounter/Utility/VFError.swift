//
//  VFError.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/08.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

// Error shows single data updating status
enum VFError: String, Error {
    
    case alreadyInItems   = "Item already existed"
    case updateError      = "Can't update data"
    case invalidLocation  = "This location create invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse  = "Invalid response from the server. Please try again."
    case invalidData      = "The data received from the server was invalid. Please try again."
    case emptyData        = "Data get empty from the server"
}
