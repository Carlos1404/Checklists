//
//  AddItemViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistDetailViewController: UITableViewController {
    
    var delegate: ChecklistDetailViewControllerDelegate?
    
    var itemToEdit: CheckListItem?
    var dueDate = Date.init()
    var isDatePickerVisible = false
    
    @IBOutlet weak var doneButton: UIBarButtonItem!

    @IBAction func Cancel(_ sender: Any) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    
    
    @IBAction func doneAction() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = AddTextItem.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            delegate?.itemDetailViewController(self, didFinishAddingItem: CheckListItem(text: AddTextItem.text!))
        }
    }
    
    @IBOutlet weak var AddTextItem: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet var datePickerCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        if(itemToEdit == nil){
            self.title = "Add Item"
            dueDateLabel.text = updateDueDateLabel(date: self.dueDate)
        } else {
            self.title = "Edit Item"
            AddTextItem.text = itemToEdit?.text
            dueDateLabel.text = updateDueDateLabel(date: itemToEdit?.dueDate)
        }
        doneButton.isEnabled = !AddTextItem.text!.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AddTextItem.becomeFirstResponder()
    }
    
    func updateDueDateLabel(date: Date?) -> String {
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        if let date = date {
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func showDatePicker(){
        
    }
    
    func hideDatePicker(){
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if(indexPath.section == 1 && indexPath.row == 1){
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 1 && indexPath.row == 2){
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            if(isDatePickerVisible){
                return 3
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 1 && indexPath.row == 2){
            return datePickerCell.intrinsicContentSize.height
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.section == 1 && indexPath.row == 1){
            showDatePicker()
        } else if(indexPath.section == 1 && indexPath.row == 2) {
            hideDatePicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if(indexPath.section == 1 && indexPath.row == 2){
            return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: 0))
        } else {
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    
}

protocol ChecklistDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ChecklistDetailViewController)
    func itemDetailViewController(_ controller: ChecklistDetailViewController, didFinishAddingItem item: CheckListItem)
    func itemDetailViewController(_ controller:ChecklistDetailViewController,didFinishEditingItem item: CheckListItem)
}

//MARK: - UITextFieldDelegate

extension ChecklistDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = AddTextItem.text!
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        doneButton.isEnabled = !newString.isEmpty
        return true
    }

}
