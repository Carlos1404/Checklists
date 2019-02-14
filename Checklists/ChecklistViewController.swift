//
//  ViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var checkList: [CheckListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        checkList.append(CheckListItem(text: "Test 1"))
        checkList.append(CheckListItem(text: "Test 2"))
        checkList.append(CheckListItem(text: "Test 3", checked: true))
        checkList.append(CheckListItem(text: "Test 4"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "pickColor" {
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        configureText(for: cell, withItem: self.checkList[indexPath.row])
        configureCheckmark(for: cell, withItem: self.checkList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        checkList[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checkList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell, withItem item: CheckListItem){
        if(item.checked){
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
    }
    
    func configureText(for cell: UITableViewCell, withItem item: CheckListItem){
        cell.textLabel?.text = item.text
    }
    
    func addDummyTodo(){
        checkList.append(CheckListItem(text: "Add element"))
        self.tableView.insertRows(at: [IndexPath(row: checkList.count - 1, section: 0)], with: .automatic)
    }
}

extension ChecklistViewController: AddItemViewControllerDelegate {
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        dismiss(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: CheckListItem) {
        dismiss(animated: true)
    }
    
}
