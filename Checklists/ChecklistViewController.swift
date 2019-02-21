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
        
        if segue.identifier == "AddItem" {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! AddItemViewController
            destVC.delegate = self
        }
        else if segue.identifier == "editItem"{
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! AddItemViewController
            let indexPath = tableView.indexPath(for: sender as! ChecklistItemCell)!
            destVC.itemToEdit = checkList[indexPath.row]
            destVC.delegate = self
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! ChecklistItemCell
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
    
    func configureCheckmark(for cell: ChecklistItemCell, withItem item: CheckListItem){
        if(item.checked){
            cell.CheckMark.isHidden = false
        } else {
            cell.CheckMark.isHidden = true
        }
    }
    
    func configureText(for cell: ChecklistItemCell, withItem item: CheckListItem){
        cell.LabelItem.text = item.text
    }
    
    func addDummyTodo(item: CheckListItem){
        checkList.append(item)
        self.tableView.insertRows(at: [IndexPath(row: checkList.count - 1, section: 0)], with: .automatic)
    }
}

extension ChecklistViewController: AddItemViewControllerDelegate {
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        dismiss(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: CheckListItem) {
        addDummyTodo(item: item)
        dismiss(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: CheckListItem) {
        let indexPath = checkList.index(where: { $0 === item})
        checkList[indexPath!].text = item.text
        tableView.reloadRows(at: [IndexPath(item: indexPath!, section: 0)], with: UITableView.RowAnimation.automatic)
        dismiss(animated: true)
    }
    
}
