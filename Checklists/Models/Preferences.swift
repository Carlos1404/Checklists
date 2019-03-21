//
//  Preferences.swift
//  Checklists
//
//  Created by lpiem on 21/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit

class Preferences {
    
    static let shared = Preferences()
    
    init(){
        UserDefaults.standard.register(defaults: [UserDefaultsKeys.checklistItemID : 0])
        UserDefaults.standard.register(defaults: [UserDefaultsKeys.firstLaunch : true])
    }
    
    func nextChecklistItemID() -> Int {
        let id = UserDefaults.standard.integer(forKey: UserDefaultsKeys.checklistItemID)
        UserDefaults.standard.set(id + 1, forKey: UserDefaultsKeys.checklistItemID)
        return id
    }
    
    func firstLaunch() -> Bool {
        if (UserDefaults.standard.bool(forKey: UserDefaultsKeys.firstLaunch)) {
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.firstLaunch)
            return true
        } else {
            return false
        }
    }
}
