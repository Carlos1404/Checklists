//
//  AddItemListViewController.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit

class AddItemListViewController: UITableViewController {
    
    var delegate: AddItemListViewControllerDelegate?
    
    var itemToEdit: Checklist?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var editText: UITextField!
    
    
    
    @IBAction func CancelAction(_ sender: Any) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.name = editText.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            delegate?.itemDetailViewController(self, didFinishAddingItem: Checklist(name: editText.text!))
        }
    }
    
    override func viewDidLoad() {
        if(itemToEdit == nil){
            self.title = "Add Item"
        } else {
            self.title = "Edit Item"
            editText.text = itemToEdit?.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editText.becomeFirstResponder()
    }
    
    
}

protocol AddItemListViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: AddItemListViewController)
    func itemDetailViewController(_ controller: AddItemListViewController, didFinishAddingItem item: Checklist)
    func itemDetailViewController(_ controller:AddItemListViewController,didFinishEditingItem item: Checklist)
}

//MARK: - UITextFieldDelegate

extension AddItemListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = editText.text!
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        doneButton.isEnabled = !newString.isEmpty
        return true
    }
    
}
