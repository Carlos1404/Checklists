//
//  CheckListItem.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

class CheckListItem: Codable {
    
    var text: String
    var checked: Bool
    var dueDate: Date
    var shouldRemind: Bool
    var itemID: Int
    
    init(text: String, checked: Bool = false, shouldRemind: Bool = false, dueDate: Date = Date.init(), itemID: Int) {
        self.text = text
        self.checked = checked
        self.dueDate = dueDate
        self.shouldRemind = shouldRemind
        self.itemID = itemID
    }
    
    init(text: String, checked: Bool = false, shouldRemind: Bool = false, dueDate: Date = Date.init()) {
        self.text = text
        self.checked = checked
        self.dueDate = dueDate
        self.shouldRemind = shouldRemind
        self.itemID = UserDefaults.standard.integer(forKey: UserDefaultsKeys.checklistItemID)
    }
    
    func toggleChecked(){
        self.checked = !self.checked
    }
}
