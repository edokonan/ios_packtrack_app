//
//  ColorSelectionViewController.swift
//  deegeu-swift-share-extensions
//
//  Created by Daniel Spiess on 10/26/15.
//  Copyright © 2015 Daniel Spiess. All rights reserved.
//

import UIKit

@objc(ColorSelectionViewControllerDelegate)
protocol ColorSelectionViewControllerDelegate {
    @objc optional func colorSelection(
        _ sender: ColorSelectionViewController,
        companyName: String, companyValue: String)
}

class ColorSelectionViewController : UITableViewController {
    
    let nameSelections = ["日本郵便", "ヤマト運輸", "佐川急便","西濃運輸", "デリバリープロバイダ(TMG等)", "日本通運", "カトーレック", "福山通運"]
    let valueSelections = [ ComFunc.shared.Company_jppost,
                            ComFunc.shared.Company_yamato,
                            ComFunc.shared.Company_sagawa,
                            ComFunc.shared.Company_seino,
                            ComFunc.shared.Company_tmg,
                            ComFunc.shared.Company_nittsu,
                            ComFunc.shared.Company_katlec,
                            ComFunc.shared.Company_fukutsu ]
    
    let tableviewCellIdentifier = "colorSelectionCell"
    var selectedCompanyName : String = "日本郵便"
    var delegate: ColorSelectionViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Initialize the tableview
    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.register(UITableViewCell.classForCoder(),
                forCellReuseIdentifier: tableviewCellIdentifier)
        title = "配達業者を選択"
    }
    
    // We only have three choices, but there's no reason this tableview can't be populated
    // dynamically from CoreData, NSDefaults, or something else.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameSelections.count
    }
    
    // This just populates each row in the table, and if we've selected it, we'll check it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: tableviewCellIdentifier,
            for: indexPath) as UITableViewCell
        
        let text = nameSelections[indexPath.row]
        cell.textLabel!.text = text
        
        if text == selectedCompanyName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // Save the value the user picks
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let theDelegate = delegate {
            selectedCompanyName = nameSelections[indexPath.row]
            let value = valueSelections[indexPath.row]
            theDelegate.colorSelection!(self,  companyName: selectedCompanyName, companyValue: value)
        }
    }
}
