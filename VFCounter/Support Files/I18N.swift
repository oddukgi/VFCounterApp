//
//  I18N.swift
//  RingRing
//
//  Created by 강선미 on 22/01/2020.
//  Copyright © 2020 TEMPUS. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
