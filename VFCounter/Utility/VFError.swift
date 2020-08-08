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
    
  case alreadyInItems = "Item already existed"
  case updateError = "Can't update data"
  
}
