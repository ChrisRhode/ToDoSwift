//
//  MainTableViewController.swift
//  ToDoSwift
//
//  Created by Christopher Rhode on 2/27/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, DatePickerPassbackDelegate, UITextFieldDelegate {

    let ugbl : Utility
    let db : DBWrapper
    // ** Int vs UInt?
    var selectedRow: Int?
    //var dateValue: String = "03/25/2020"
    var forceReload: Bool = true
    var searchadd : UITextField? = nil
    var isSearchMode : Bool = false
    var currParentItemID : Int = 0
    
    var recordList: [[String]] = []
    
    // ** all of the above have to be initialized in an init, cannot do in viewDidLoad etc
    // ** may be required to define all possible init methods, definmitely the one used to create it
    override init(style:UITableView.Style)
    {
        ugbl = Utility()
        db = DBWrapper.init(forDbFile: "ToDoSwift")
        super.init(style:style)
        
    }
    required init?(coder: NSCoder)
    {
        //ugbl = Utility()
        //db = DBWrapper.init(forDbFile: "ToDoSwift")
        //super.init(coder:coder)
        fatalError("init(coder:) not supported")
    }
    
    override func viewDidLoad() {
        // ** have to initialize to empty in caller!
       
        super.viewDidLoad()

        // get all the items at the root level
        
        // search/add text entry box
        searchadd = UITextField(frame: CGRect(x:0,y:0,width:320,height:44))
        searchadd?.delegate = self
        searchadd?.borderStyle = UITextField.BorderStyle.roundedRect
        searchadd?.clearButtonMode = UITextField.ViewMode.whileEditing
        searchadd?.placeholder = "(search/add)"
        self.tableView.tableHeaderView = searchadd
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      // ** this suffices to create the instance
       // ugbl = Utility()
        
        // testing
        //var x = ugbl.dateHumanToSortable(sourceDate: "03/02/2020")
        //x = ugbl.dateSortableToHuman(sourceDate: x)
       // var x = ugbl.doesContainValidNonNegativeInteger(theString: "ABC")
        
        //
        self.title = ugbl.currDateInHumanFormat()
        let _ = db.openDB()
        let _ = db.executeSQLCommand(theSQL: "CREATE TABLE IF NOT EXISTS Items (ItemID INTEGER NOT NULL, ParentItemID INTEGER NOT NULL, ChildCount INTEGER NOT NULL, ItemText TEXT NOT NULL, Notes TEXT, BumpCount INTEGER NOT NULL, DateOfEvent TEXT,BumpToTopDate TEXT, isGrayedOut INTEGER NOT NULL, isDeleted INTEGER NOT NULL, PRIMARY KEY (ItemID));")
        db.closeDB()
        
        // testing
       // let _ = db.openDB()
       // let _ = db.executeSQLCommand(theSQL: "INSERT INTO Items VALUES (1,1,0,0,'Hello World',NULL,0,NULL,0,0);")
       // let _ = db.executeSQLCommand(theSQL: "INSERT INTO Items VALUES (1,2,0,0,'Second Record',NULL,0,NULL,0,0);")
       // let _ = db.doSelect(sql: "SELECT * FROM Items", records: &recordList)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (forceReload)
        {
            forceReload = false
            loadCurrentChildren()
            self.tableView.reloadData()
        }
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recordList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "MainListCell")
        let thisRow = indexPath.row
        let thisItemID = Int(recordList[thisRow][0])
        let thisItem = ToDoItem(requestedItemID: thisItemID!)
        cell.textLabel!.text = thisItem.itemText
        cell.detailTextLabel!.text = ""
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // selectedRow = indexPath.row
        
        // edit the date
        
       // let tmp = DatePicker(CurrentHumanDate: dateValue, ItemDescription: "Test Date")
       // tmp.delegate = self
       // self.navigationController?.pushViewController(tmp, animated: true)
    }

    func doDatePickerPassBack(theHumanDate: String, didTapCancel: Bool)
    {
        if (didTapCancel == false)
        {
             //dateValue = theHumanDate
            forceReload = true
        }
        
        self.navigationController?.popViewController(animated: false)
    }
    
    // UITextField delegate implementations
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let currentTextFieldValue = textField.text
        // *** currentTextFieldValue?.count does not work
        if (currentTextFieldValue!.count >= 2)
        {
            // instate search mode based on characters entered so far
           // isSearchMode = true
           // let sql = "SELECT ItemID"
            
        }
        else
        {
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hitting RETURN vs clearing the box or defocusing the box is treated as ADD
        let finalTextFieldValue = textField.text
        if (finalTextFieldValue?.count == 0)
        {
            ugbl.popUpSimpleAlert(alertMessage: "Item text cannot be empty", withTypeOfAlert: .isError)
            return false
        }
        let theNewItem = ToDoItem()
        theNewItem.itemText = finalTextFieldValue!
        theNewItem.saveNew()
        textField.text = ""
        loadCurrentChildren()
        self.tableView.reloadData()
        
        return false
    }
    
    // load items at current level
    func loadCurrentChildren()
    {
        let sql = "SELECT ItemID FROM Items WHERE (ParentItemID = \(currParentItemID)) ORDER BY ItemID DESC"
        let _ = db.openDB()
        let _ = db.doSelect(sql: sql, records: &recordList)
        db.closeDB()
        
    }
    
    // template code after this line
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
