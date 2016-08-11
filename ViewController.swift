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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messages: [FIRDataSnapshot]! = [FIRDataSnapshot]()
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (FIRAuth.auth()?.currentUser == nil) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "firebaseLoginViewController")
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
    }
    
    deinit {
        self.ref.child("messages").removeObserver(withHandle: _refHandle)
    }
    
    func ConfigureDatabase () {
        ref = FIRDatabase.database().reference()
        
        _refHandle = self.ref.child("messages").observe(.childAdded, with: {(snapshot) -> Void in
            self.messages.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
        })
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
        if let text = message[Constants.MessageField.text] as String! {
        cell.textLabel?.text = text
        }
        if let subText = message[Constants.MessageField.dateTime] {
            cell.detailTextLabel?.text = subText
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        
        ConfigureDatabase()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func SendMessage(data: [String: String]) {
        var packet = data
        packet[Constants.MessageField.dateTime] = Utilities().GetDate()
        self.ref.child("message").childByAutoId().setValue(packet)
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
        if (textField.text?.characters.count == 0) {
            return true
        }
        let data = [Constants.MessageField.text: textField.text! as String]
        SendMessage(data: data)
        print("ended editing")
        textField.text = ""
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

