//
//  AddItemViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBAction func CancelAction() {
        
    }
    
    @IBAction func doneAction() {
        print(AddTextItem.text ?? "null")
        dismiss(animated: true)
    }
    
    @IBOutlet weak var AddTextItem: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        AddTextItem.becomeFirstResponder()
    }
    
    
}

protocol AddItemViewControllerDelegate : class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: CheckListItem)
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
