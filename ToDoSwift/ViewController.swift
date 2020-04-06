//
//  ViewController.swift
//  ToDoSwift
//
//  Created by Christopher Rhode on 2/27/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // x: from left y: from top width: height:
        let v = UIView(frame:CGRect(x:0,y:0,width:100,height:64))
        v.backgroundColor = .yellow
        self.view.addSubview(v)
 
        //let vc = UITableViewController(style: .plain)
       // let rc = UINavigationController(rootViewController:)
        
        
    }


}

