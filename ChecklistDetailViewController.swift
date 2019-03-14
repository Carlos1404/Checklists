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
    
    override func viewDidLoad() {
        if(itemToEdit == nil){
            self.title = "Add Item"
        } else {
            self.title = "Edit Item"
            AddTextItem.text = itemToEdit?.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AddTextItem.becomeFirstResponder()
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
