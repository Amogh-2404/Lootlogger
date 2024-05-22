//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by R.AMOGH on 14/05/24.
//

import UIKit

class ItemsViewController: UITableViewController{
    var itemStore : ItemStore!
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem){
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.firstIndex(of: newItem){
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        
    }
    

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell with default appearance
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row of this cell
        // will item appear
        
        let item = itemStore.allItems[indexPath.row]
        
        // Configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
//        cell.backgroundColor = item.valueInDollars>50 ? UIColor.red : UIColor.green
        
        return cell
        
    }
    
    
    override func tableView(_ tableview:UITableView, commit editingStyle:UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath){
        // If the table view is asing to commit a delete command
        if editingStyle == .delete{
            let item = itemStore.allItems[indexPath.row]
            
            // Remove the item from the store
            itemStore.removeItem(item)
            
            // Remove the item's image from the image store
            imageStore.deleteImage(forKey: item.itemKey as NSString)
            
            // Also remove that row from the table view with an animation
            tableview.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        
    }
    
    // Stack view segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggred segue is "showItem" segue
        switch segue.identifier{
        case "showItem":
            // Figure Out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row{
                
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpexted segue Identifier")
        }
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let customBackButton = UIBarButtonItem()
        customBackButton.title = "Log"
        
        navigationItem.backBarButtonItem = customBackButton
    }
    
    
    
}
