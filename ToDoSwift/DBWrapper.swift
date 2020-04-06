//
//  DBWrapper.swift
//  ToDoSwift
//
//  Created by Christopher Rhode on 2/27/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import Foundation
import SQLite3
// * learn about modules in Swift, how do they differ from local code pieces

class DBWrapper
{
    // * declare "pointers" that will be defined later like this
    let ugbl : Utility
    var fullPathToDBFile : String
    var db : OpaquePointer?
    var stmtForParamCommand: OpaquePointer?
    var errorMsg: String?
    var insertParamCtr: Int = -1
    init(forDbFile: String)
    {
        var tmp : String
        
        ugbl = Utility()
      
        tmp = ugbl.getDocumentsDirectory()
        tmp = tmp + forDbFile + ".sqlite"
        fullPathToDBFile = tmp
        
    }
    
    // ** see if there is a better way to define/use string constahts in Swift
    func cDBNull() -> String
    {
        return "$db$N$u$L$L"
    }
    
    func dbNullToEmptyString(theString:String) -> String
    {
        if (theString == cDBNull())
        {
            return ""
        }
        else
        {
            return theString
        }
    }
    
    func openDB() -> Bool
    {
        // * Int32 standard for c code?
        var status: Int32
        status = sqlite3_open(fullPathToDBFile,&db)
        if (status != SQLITE_OK)
        {
            sqlite3_close(db)
            return false
        }
        return true
    }
    
    func closeDB()
    {
        sqlite3_close(db)
    }
    
    func executeSQLCommand(theSQL: String) -> Bool
    {
        var status: Int32
        
        // ** look into how to do char **errorMsg as last parameter
        // **   Examples on Internet all access errorMsg instead as shown
        // * nil instead of NULL
        // * apparently Swift Strings match a UnsafePointer<Int8>
        // *   they go in as a UTF8 zero terminated string
    
        status = sqlite3_exec(db,theSQL,nil,nil,nil)
        if (status != SQLITE_OK)
        {
            errorMsg = String(cString: sqlite3_errmsg(db))
            return false
        }
        return true
        
    }
    // * correct syntax for parameter and local arrays of strings
    // * passing back (by reference) the records (inout)
    func doSelect(sql: String, records: inout [[String]]) -> Bool
    {
        var idx,lastNdx: Int32
        var thisRecord: [String]
        // * use this instead of a specific sqlite3_stmt type
        var stmt: OpaquePointer?
        var status:Int32
        var param_int:Int32 // this is the type returned by sqlite3_column_int
        //var param_text: String // sqlite3_column_text is actually <UnsafePointer><UInt8> not <UnsafePointer><Int8>?!
        var tmp_string: String
        var local_record_list: [[String]] = []
        var column_type: Int32 // this is the type returned by sqlite3_column_type
        
        status = sqlite3_prepare_v2(db,sql,-1,&stmt,nil)
        if (status != SQLITE_OK)
        {
            return false
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            thisRecord = []
            lastNdx = sqlite3_column_count(stmt) - 1
            idx = 0
            while (idx <= lastNdx)
            {
                column_type = sqlite3_column_type(stmt,idx)
                if (column_type == SQLITE_NULL)
                {
                    thisRecord.append(cDBNull())
                }
                else if (column_type == SQLITE_INTEGER)
                {
                    param_int = sqlite3_column_int(stmt,idx)
                    thisRecord.append("\(param_int)")
                }
                else if (column_type == SQLITE_TEXT)
                {
                    let param_text = sqlite3_column_text(stmt,idx)!
                    tmp_string = String(cString:param_text)
                    thisRecord.append(tmp_string)
                }
                else
                {
                    return false
                }
                idx += 1
            }
            local_record_list.append(thisRecord)
            
        }
        status = sqlite3_finalize(stmt)
        
        records = local_record_list
        return true
    }
    
    func doCommandWithParamsStart(sql: String) -> Bool
    {
        var status:Int32
        
        status = sqlite3_prepare_v2(db,sql,-1,&stmtForParamCommand,nil)
        if (status != SQLITE_OK)
        {
            return false
        }
        insertParamCtr = 0
        return true
    }
    
    func doCommandWithParamsAddParameter(paramType:String,paramValue:String) -> Bool
    {
        if (paramType == "S")
        {
            insertParamCtr += 1
            let _ = sqlite3_bind_text(stmtForParamCommand,Int32(insertParamCtr),paramValue,-1,nil)
        }
        else if (paramType == "NS")
        {
            insertParamCtr += 1
            if (paramValue == "")
            {
                let _ = sqlite3_bind_null(stmtForParamCommand, Int32(insertParamCtr))
            }
            else
            {
                let _ = sqlite3_bind_text(stmtForParamCommand,Int32(insertParamCtr),paramValue,-1,nil)
            }
        }
        else if (paramType == "I")
        {
            insertParamCtr += 1
            let _ = sqlite3_bind_int(stmtForParamCommand,Int32(insertParamCtr),Int32(Int(paramValue)!))
        }
        else
        {
            return false
        }
        
        return true
    }
    
    func doCommmandWithParamsEnd() -> Bool
    {
        if (sqlite3_step(stmtForParamCommand) != SQLITE_DONE)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func columnExists(columnName: String, tableName: String) -> Bool
    {
        var localRecords: [[String]] = []
        let leftUpper = columnName.uppercased()
        let sql = "PRAGMA table_info(" + tableName + ");"
        let _ = doSelect(sql: sql, records: &localRecords)
        let lastNdx = localRecords.count - 1
        for idx in 0...lastNdx
        {
            let rightUpper = localRecords[idx][1].uppercased()
            if (rightUpper == leftUpper)
            {
                return true
            }
        }
        return false
    }
}
