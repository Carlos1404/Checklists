//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit

class IconPickerViewController: UITableViewController {
    
    let icons = IconAsset.allCases
    
    var delegate: IconPickerViewControllerDelegate?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Icon", for: indexPath)
        configureText(for: cell, withItem: icons[indexPath.row])
        cell.imageView?.image = icons[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.iconPickerViewController(self, didFinishSelectIcon: icons[indexPath.row])
    }
    
    func configureText(for cell: UITableViewCell, withItem item: IconAsset){
        cell.textLabel?.text = item.rawValue
    }
    
}

protocol IconPickerViewControllerDelegate : class {
    func iconPickerViewController(_ controller: IconPickerViewController, didFinishSelectIcon icon: IconAsset)
}
