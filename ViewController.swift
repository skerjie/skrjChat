//
//  ViewController.swift
//  skrjChat
//
//  Created by Andrei Palonski on 07.08.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    var messages: [FIRDataSnapshot]! = [FIRDataSnapshot]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (FIRAuth.auth()?.currentUser == nil) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "firebaseLoginViewController")
            
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let messageSnap: FIRDataSnapshot! = self.messages[indexPath.row]
        let message = messageSnap.value as! Dictionary<String,String>
        let text = message["text"] as String!
        cell.textLabel?.text = text
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func keyboardWillHide (_ sender: Notification) {
        let userInfo: [NSObject:AnyObject] = (sender as NSNotification).userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue().size
        
        self.view.frame.origin.y += keyboardSize.height
    }
    
    func keyboardWillShow(_ sender: NSNotification) {
        let userInfo: [NSObject:AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue().size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue().size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.15, animations:{ self.view.frame.origin.y -= keyboardSize.height
            })
        }
        } else {
            UIView.animate(withDuration: 0.1, animations: {self.view.frame.origin.y += keyboardSize.height - offset.height})
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("ended editing")
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

