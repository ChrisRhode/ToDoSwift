//
//  DatePicker.swift
//  ToDoSwift
//
//  Created by Christopher Rhode on 4/4/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit

// my standard passback of results from user interaction with the class
// ** required vs optional equivalents in swift?

protocol DatePickerPassbackDelegate: class {
    func doDatePickerPassBack(theHumanDate: String, didTapCancel: Bool)
}

class DatePicker: UIViewController {

    // link up controls in xib here
    
    @IBOutlet weak var lblItemDescription: UILabel!
    
    @IBOutlet weak var txtTheDate: UITextField!
    
    // delegate
    weak var delegate: DatePickerPassbackDelegate? = nil
    
    // properties for class
    // use let instead of var in this case, because they will not change after initialization
    
    let gCurrentHumanDate: String
    let gItemDescription: String
    
    // overriding init for manual instancing, while taking care of what the superclass needs
    // this works when we are not using storyboards (we aren't using them right now)
    // will always initialize this UIViewController with
    //   init(CurrentHumanDate,ItemDescription)
    
   // dummy convenience init()
    convenience init()
    {
        self.init(CurrentHumanDate:"", ItemDescription:"")
    }
    
    init(CurrentHumanDate: String, ItemDescription: String)
    {
        gCurrentHumanDate = CurrentHumanDate
        gItemDescription = ItemDescription
        // must call designated initializer of superclass
        super.init(nibName:nil, bundle:nil)
    }
    // implement the other required superclass initializers as errors
    required init?(coder: NSCoder) {
       fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    
    
    @IBAction func btnCheckTapped(_ sender: Any) {
    }
    
    
    @IBAction func btnCancelTapped(_ sender: Any) {
         delegate?.doDatePickerPassBack(theHumanDate: "", didTapCancel: true)
    }
    
    @IBAction func btnOKTapped(_ sender: Any) {
        
        delegate?.doDatePickerPassBack(theHumanDate: (txtTheDate.text)!, didTapCancel: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
