//
//  AddItemListViewController.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit

class ListDetailViewController: UITableViewController {
    
    var delegate: ListDetailViewControllerDelegate?
    
    var itemToEdit: Checklist?
    var iconAssetChoosed: IconAsset?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var editText: UITextField!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var labelIcon: UILabel!
    
    
    
    @IBAction func CancelAction(_ sender: Any) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.name = editText.text!
            if let icon = self.iconAssetChoosed {
                itemToEdit.icon = icon
            }
            delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            delegate?.itemDetailViewController(self, didFinishAddingItem: Checklist(name: editText.text!, icon: self.iconAssetChoosed ?? IconAsset.NoIcon))
        }
    }
    
    override func viewDidLoad() {
        if(itemToEdit == nil){
            self.title = "Add Item"
            self.iconAssetChoosed = IconAsset.Folder
            if let icon = self.iconAssetChoosed {
                self.icon.image = icon.image
                labelIcon.text = icon.rawValue
            }
        } else {
            self.title = "Edit Item"
            editText.text = itemToEdit?.name
            icon.image = itemToEdit?.icon.image
            labelIcon.text = itemToEdit?.icon.rawValue
            doneButton.isEnabled = !editText.text!.isEmpty
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SelectIcon" {
            let destVC = segue.destination as! IconPickerViewController
            destVC.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editText.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

protocol ListDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func itemDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem item: Checklist)
    func itemDetailViewController(_ controller:ListDetailViewController,didFinishEditingItem item: Checklist)
}

//MARK: - UITextFieldDelegate

extension ListDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = editText.text!
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        doneButton.isEnabled = !newString.isEmpty
        return true
    }
    
}

extension ListDetailViewController: IconPickerViewControllerDelegate {
    func iconPickerViewController(_ controller: IconPickerViewController, didFinishSelectIcon icon: IconAsset) {
        self.icon.image = icon.image
        labelIcon.text = icon.rawValue
        self.iconAssetChoosed = icon
        navigationController?.popViewController(animated: true)
    }
}
