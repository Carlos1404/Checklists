//
//  ViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var list: Checklist!
    
    var delegate: ChecklistViewControllerDelegate?
    
    static var documentDirectory: URL { return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! }
    
    static var dataFileUrl: URL { return ChecklistViewController.documentDirectory.appendingPathComponent("Checklist").appendingPathExtension("json") }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = list.name
        print(ChecklistViewController.dataFileUrl)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.checklistViewController(self, didFinishAddingItem: list)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ItemDetailViewController
            destVC.delegate = self
        }
        else if segue.identifier == "editItem"{
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ItemDetailViewController
            let indexPath = tableView.indexPath(for: sender as! ChecklistItemCell)!
            destVC.itemToEdit = self.list.items[indexPath.row]
            destVC.delegate = self
        }

    }
    
    override func awakeFromNib() {
        //loadChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! ChecklistItemCell
        configureText(for: cell, withItem: self.list.items[indexPath.row])
        configureCheckmark(for: cell, withItem: self.list.items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.list.items[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.list.items.remove(at: indexPath.row)
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
        self.list.items.append(item)
        self.tableView.insertRows(at: [IndexPath(row: self.list.items.count - 1, section: 0)], with: .automatic)
    }
    
    func saveChecklistItems(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(list.items)
            try data.write(to: ChecklistViewController.dataFileUrl, options: [])
        }
        catch {print(error)}
    }
    
    func loadChecklistItems() {
        do {
            let data = try Data(contentsOf: ChecklistViewController.dataFileUrl)
            let decoder = JSONDecoder()
            let list = try decoder.decode([CheckListItem].self, from: data)
            self.list.items = list
        }
        catch {print(error)}
    }
}

protocol ChecklistViewControllerDelegate : class {
    func checklistViewController(_ controller: ChecklistViewController, didFinishAddingItem item: Checklist)
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem) {
        addDummyTodo(item: item)
        dismiss(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem) {
        let indexPath = self.list.items.index(where: { $0 === item})
        self.list.items[indexPath!].text = item.text
        tableView.reloadRows(at: [IndexPath(item: indexPath!, section: 0)], with: UITableView.RowAnimation.automatic)
        dismiss(animated: true)
    }
    
}
