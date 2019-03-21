//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import UserNotifications

class AllListViewController: UITableViewController {
    
    static var documentDirectory: URL { return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! }
    
    static var dataFileUrl: URL { return AllListViewController.documentDirectory.appendingPathComponent("Checklists").appendingPathExtension("json") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checklistsDetails" {
            let destVC = segue.destination as! ChecklistViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            destVC.list = DataModel.shared.checkLists[indexPath.row]
            destVC.delegate = self
        }
        else if segue.identifier == "addItemList" {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ListDetailViewController
            destVC.delegate = self
        }
        else if segue.identifier == "editItemList"{
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ListDetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            destVC.itemToEdit = DataModel.shared.checkLists[indexPath.row]
            destVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.shared.checkLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklists", for: indexPath)
        configureText(for: cell, withItem: DataModel.shared.checkLists[indexPath.row])
        cell.imageView?.image = DataModel.shared.checkLists[indexPath.row].icon.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DataModel.shared.checkLists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, withItem item: Checklist){
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = uncheckedItemsCount(items: item.items)
    }
    
    func addDummyTodo(item: Checklist){
        DataModel.shared.checkLists.append(item)
        DataModel.shared.sortChecklists()
        self.tableView.reloadData()
    }
    
    func uncheckedItemsCount(items: [CheckListItem]) -> String{
        let value = items.filter({ item -> Bool in
            item.checked == false
        }).count
        
        switch value {
        case 0:
            return "No Item"
        default:
            return String(value)
        }
    }
}

extension AllListViewController: ChecklistViewControllerDelegate {
    
    func checklistViewController(_ controller: ChecklistViewController, didFinishAddingItem item: Checklist){
        let indexPath = DataModel.shared.checkLists.index(where: { $0 === item})
        DataModel.shared.checkLists[indexPath!].items = item.items
        DataModel.shared.saveChecklistItems()
        tableView.reloadRows(at: [IndexPath(item: indexPath!, section: 0)], with: UITableView.RowAnimation.automatic)
    }
    
}

extension AllListViewController: ListDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true)
    }
    
    func itemDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem item: Checklist) {
        addDummyTodo(item: item)
        dismiss(animated: true)
    }
    
    func itemDetailViewController(_ controller: ListDetailViewController, didFinishEditingItem item: Checklist) {
        let indexPath = DataModel.shared.checkLists.index(where: { $0 === item})
        DataModel.shared.checkLists[indexPath!].name = item.name
        DataModel.shared.checkLists[indexPath!].icon = item.icon
        DataModel.shared.saveChecklistItems()
        tableView.reloadRows(at: [IndexPath(item: indexPath!, section: 0)], with: UITableView.RowAnimation.automatic)
        dismiss(animated: true)
    }
}
