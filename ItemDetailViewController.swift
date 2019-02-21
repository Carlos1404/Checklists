//
//  AddItemViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController {
    
    var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: CheckListItem?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBAction func CancelAction() {
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
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AddTextItem.becomeFirstResponder()
    }
    
    
}

protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem)
    func itemDetailViewController(_ controller:ItemDetailViewController,didFinishEditingItem item: CheckListItem)
}

//MARK: - UITextFieldDelegate

extension ItemDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = AddTextItem.text!
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        doneButton.isEnabled = !newString.isEmpty
        return true
    }

}
