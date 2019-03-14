//
//  DataModel.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit

class DataModel: Codable {
    
    static let shared = DataModel()
    var checkLists: [Checklist] = []
    
    init() {
        loadChecklistItems()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveChecklistItems),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
    
    @objc func saveChecklistItems(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(checkLists)
            try data.write(to: AllListViewController.dataFileUrl, options: [])
        }
        catch {print(error)}
    }
    
    func loadChecklistItems() {
        do {
            let data = try Data(contentsOf: AllListViewController.dataFileUrl)
            let decoder = JSONDecoder()
            let list = try decoder.decode([Checklist].self, from: data)
            self.checkLists = list
        }
        catch {print(error)}
    }
    
    func sortChecklists(){
        self.checkLists = checkLists.sorted { $0.name < $1.name }
        saveChecklistItems()
    }
}
