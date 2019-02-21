//
//  AddItemViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
    
    var delegate: AddItemViewControllerDelegate?
    
    var itemToEdit: CheckListItem?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBAction func CancelAction() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func doneAction() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = AddTextItem.text!
            delegate?.addItemViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            delegate?.addItemViewController(self, didFinishAddingItem: CheckListItem(text: AddTextItem.text!))
        }
    }
    
    @IBOutlet weak var AddTextItem: UITextField!
    
    override func viewDidLoad() {
        if(itemToEdit == nil){
            self.title = "Add Item"
        } else {
            self.title = "Edit Item"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AddTextItem.becomeFirstResponder()
    }
    
    
}

protocol AddItemViewControllerDelegate : class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: CheckListItem)
    func addItemViewController(_ controller:AddItemViewController,didFinishEditingItem item: CheckListItem)
}

//MARK: - UITextFieldDelegate

extension AddItemViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = AddTextItem.text!
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        doneButton.isEnabled = !newString.isEmpty
        return true
    }

}
