//
//  ToDoItem.swift
//  ToDoSwift
//
//  Created by Christopher Rhode on 4/5/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {

    // CREATE TABLE IF NOT EXISTS Items (ItemID INTEGER NOT NULL, ParentItemID INTEGER NOT NULL, ChildCount INTEGER NOT NULL, ItemText TEXT NOT NULL, Notes TEXT, BumpCount INTEGER NOT NULL, DateOfEvent TEXT,BumpToTopDate TEXT, isGrayedOut INTEGER NOT NULL, isDeleted INTEGER NOT NULL, PRIMARY KEY (ItemID))
    
    let itemID : Int
    var parentItemID : Int
    var itemText: String
    var notes : String
    var childCount: Int
    var bumpCount: Int
    var dateOnWhichToBumpToTop: Date?
    var dateOfEvent: Date?
    var isGrayedOut : Bool
    var isDeleted: Bool

    override init()
    {
        itemID = 0
        parentItemID = 0
        itemText = ""
        notes = ""
        childCount = 0
        bumpCount = 0
        dateOnWhichToBumpToTop = nil
        dateOfEvent = nil
        isGrayedOut = false
        isDeleted = false
        
        super.init()
    }
    
    init(requestedItemID: Int)
    {
        var localRecordList: [[String]] = []
        var aRecord : [String]
        
        itemID = requestedItemID
        let db = DBWrapper(forDbFile: "ToDoSwift")
        let sql = "SELECT ParentItemID,ChildCount,ItemText,Notes,BumpCount,DateOfEvent,BumpToTopDate,isGrayedOut,isDeleted FROM Items WHERE ItemID = (\(requestedItemID))"
        let _ = db.openDB()
        let _ = db.doSelect(sql: sql, records: &localRecordList)
        db.closeDB()
        aRecord = localRecordList[0]
        parentItemID = Int(aRecord[0])!
        itemText = aRecord[2]
        notes = aRecord[3]
        childCount = Int(aRecord[1])!
        bumpCount = Int(aRecord[4])!
       dateOnWhichToBumpToTop = nil
       dateOfEvent = nil
        isGrayedOut = false
        isDeleted = false
        // ***** it only complained about isGrayedOut not defined
    
        super.init()
    }
    
    func saveNew()
    {
        var sql: String
        var recordList: [[String]] = []
        var nextItemID: Int
        
        if (itemID != 0)
        {
            fatalError("saveNew called but itemID has been set")
        }
        if (itemText.count == 0)
        {
            fatalError("saveNew called but itemText is empty")
        }
        // get the current max ItemID
        let db = DBWrapper(forDbFile: "ToDoSwift")
        let _ = db.openDB()
        sql = "SELECT MAX(ItemID) FROM Items"
        let _ = db.doSelect(sql: sql, records: &recordList)
       
        let result = recordList[0][0]
        if (result == db.cDBNull())
        {
            nextItemID = 1
        }
        else
        {
            nextItemID = Int(result)! + 1
        }
        
        // ***** will need to fix for current parent etc
        
       sql = "INSERT INTO Items (ItemID,ParentItemID,ChildCount,ItemText,Notes,BumpCount,DateOfEvent,BumpToTopDate,isGrayedOut,isDeleted) VALUES (?,0,0,?,NULL,0,NULL,NULL,0,0)"
        let _ = db.doCommandWithParamsStart(sql: sql)
        let _ = db.doCommandWithParamsAddParameter(paramType: "I", paramValue: "\(nextItemID)")
        let _ = db.doCommandWithParamsAddParameter(paramType: "S", paramValue: itemText)
        let _ = db.doCommmandWithParamsEnd()
        
        db.closeDB()
        
    }
}


