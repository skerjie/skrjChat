//
//  LoginRegisteredViewController.swift
//  skrjChat
//
//  Created by Andrei Palonski on 07.08.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginRegisteredViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        //logout
        
        let fireBaseAuth = FIRAuth.auth()
        do {
            try fireBaseAuth?.signOut()
        } catch let signOutError as NSError {
            print("Error signing out")
        }
        
        // Do any additional setup after loading the view.
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisteredViewController.dismissKeyboard)) // Убираем клавиатуру по нажатию пустого экрана
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() { // сама функция которая разрешает закончить редактирование
    view.endEditing(true)
    }

    @IBAction func loginClicked(_ sender: AnyObject) {
        if (emailTextField.text?.characters.count < 5) {
            emailTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.3)
            return
        } else {
            emailTextField.backgroundColor = UIColor.white()
        }
        
        if (passwordTextField.text?.characters.count < 5) {
            passwordTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.3)
            return
        } else {
            passwordTextField.backgroundColor = UIColor.white()
        }
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                Utilities().ShowAlert(title: "Error", message: error.localizedDescription, vc: self)
            print(error.localizedDescription)
                return
            }
            print("Sign In!")
        })
    }
    
    @IBAction func registerClicked(_ sender: AnyObject) {
    }
    
    
    @IBOutlet weak var forgotClicked: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
