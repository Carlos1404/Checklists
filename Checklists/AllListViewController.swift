//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {
    
    var checkLists: [Checklist] = []
    
    static var documentDirectory: URL { return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! }
    
    static var dataFileUrl: URL { return ChecklistViewController.documentDirectory.appendingPathComponent("Checklist").appendingPathExtension("json") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let list1: Checklist = Checklist(name: "Fruits", items: [CheckListItem(text: "Poire"), CheckListItem(text: "Pomme")])
        let list2: Checklist = Checklist(name: "Légumes", items: [CheckListItem(text: "Carotte"), CheckListItem(text: "Haricots")])
        checkLists.append(list1)
        checkLists.append(list2)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checklistsDetails" {
            let destVC = segue.destination as! ChecklistViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            destVC.list = checkLists[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklists", for: indexPath)
        configureText(for: cell, withItem: self.checkLists[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checkLists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func addList(item: Checklist){
        checkLists.append(item)
        self.tableView.insertRows(at: [IndexPath(row: checkLists.count - 1, section: 0)], with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, withItem item: Checklist){
        cell.textLabel?.text = item.name
    }
    
    func saveChecklistItems(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(checkLists)
            try data.write(to: AllListViewController.dataFileUrl, options: [])
        }
        catch {print(error)}
    }
    
    
}

extension AllListViewController: ChecklistViewControllerDelegate {
    
    func checklistViewController(_ controller: ChecklistViewController, didFinishAddingItem item: Checklist){
        let indexPath = checkLists.index(where: { $0 === item})
        checkLists[indexPath!].items = item.items
        saveChecklistItems()
    }
    
}
