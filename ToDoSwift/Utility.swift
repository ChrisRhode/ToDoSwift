//
//  Utility.swift
//  ToDoSwift
//
//  Created by Christopher Rhode on 2/27/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import Foundation
import UIKit

enum ALERT_TYPES
{
    case isWarning
    case isError
}
class Utility
{
    func currDateInHumanFormat() -> String
    {
        // ** per internet use Date and Dateformatter
        
        let rightNow = Date()
        // ** per internet, [NSDate date] is achieved by the above
        // ** per help text, use DateFormatter instead of NSDateFormatter
        let df = DateFormatter()
        df.dateFormat = "EEEE, MM/dd/yyyy"
        // ** vs .stringFromDate:
        return df.string(from: rightNow)
    }
    
    func getDocumentsDirectory() -> String
    {
        var tmp:String
        // ** when it doesn't like NSxxx, try .xxx, possibly with lowecase first letter
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // ** objectAtIndex:a becomes [a]
        tmp = paths[0]
        tmp = tmp + "/"
        
        return tmp
        
        
    }
    
    func dateHumanToSortable(sourceDate: String) -> String
    {
        if (sourceDate == "")
        {
            return ""
        }
        // * it says separatedBy: is of type CharacaterSet
        let pieces = sourceDate.components(separatedBy: "/")
        // * use String(format:) not .localizedStringWithFormat
        var result: String = String(format:"%04ld", Int(pieces[2])!)
        result = result + "-"
        result = result + String(format:"%02ld", Int(pieces[0])!)
        result = result + "-"
        result = result + String(format:"%02ld", Int(pieces[1])!)
        return result
        
    }
    
    func dateSortableToHuman(sourceDate: String) -> String
    {
        if (sourceDate == "")
        {
            return ""
        }
        // * it says separatedBy: is of type CharacaterSet
        let pieces = sourceDate.components(separatedBy: "-")
        // * use String(format:) not .localizedStringWithFormat
        var result: String = String(format:"%02ld", Int(pieces[1])!)
        result = result + "/"
        result = result + String(format:"%02ld", Int(pieces[2])!)
        result = result + "/"
        result = result + String(format:"%04ld", Int(pieces[0])!)
        return result
    }
    
    func doesContainValidNonNegativeInteger(theString: String) -> Bool
    {
        let notdigits = CharacterSet(charactersIn: "0123456789").inverted
        let r = theString.rangeOfCharacter(from: notdigits)
        // nil: no characters in the string are not in set
        // some: some or all of the characters in the string are not in the set
        return (r == nil)
    }
    
    func popUpSimpleAlert(alertMessage: String, withTypeOfAlert: ALERT_TYPES)
    {
        let alertTypeString: String
        
        // **** no need for default, because it enforces exhaustiveness for enums
        switch withTypeOfAlert
        {
        case .isWarning:
            alertTypeString = "Warning"
        case .isError:
            alertTypeString = "Error"
        }
        
        let ac = UIAlertController(title: alertTypeString, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let app = UIApplication.shared
        let currnc = app.keyWindow!.rootViewController
        currnc!.present(ac, animated: true, completion: nil)
    }
    
}
