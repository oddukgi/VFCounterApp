//
//  URL+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/15.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

extension URL    {
    func checkFileExist() -> Bool {
        let path = self.path
        if (FileManager.default.fileExists(atPath: path))   {
            print("FILE AVAILABLE")
            return true
        }else        {
            print("FILE NOT AVAILABLE")
            return false;
        }
    }
}
