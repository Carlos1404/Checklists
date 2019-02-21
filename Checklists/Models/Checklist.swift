//
//  Checklist.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

class Checklist: Codable {
    
    var name: String
    var items: [CheckListItem]
    
    init(name: String, items: [CheckListItem] = []) {
        self.name = name
        self.items = items
    }
}
