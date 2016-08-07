//
//  ViewController.swift
//  skrjChat
//
//  Created by Andrei Palonski on 07.08.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (FIRAuth.auth()?.currentUser == nil) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "firebaseLoginViewController")
            
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

