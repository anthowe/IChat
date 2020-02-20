//
//  WelcomeViewControllerViewController.swift
//  iChat
//
//  Created by Anthony Howe on 12/17/19.
//  Copyright © 2019 Anthony Howe. All rights reserved.
//

import UIKit
import ProgressHUD

class WelcomeViewControllerViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var enterPasswordTextField: UITextField!
    
    
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
   
    //MARK: IBACTIONS
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTextField.text != "" && enterPasswordTextField.text != "" {
            loginUser()
            print("login")
        }
        else {
            ProgressHUD.showError("email and password are required")
        }
    }
    
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTextField.text != "" && enterPasswordTextField.text != "" && reenterPasswordTextField.text != "" {
           
            if enterPasswordTextField.text == reenterPasswordTextField.text{
            registerUser()
            print("register")
            }
            else {
                ProgressHUD.showError("Passwords do not match!")
            }
        }
                else {
                    ProgressHUD.showError("All fields are required!")
                }
        
    }
    
    
    @IBAction func backgroundTap(_ sender: Any) {
        dismissKeyboard()
    }
    
    
    
  
    
    func registerUser(){
        
        performSegue(withIdentifier: "welcomeToFinishReg", sender: self)
       
        cleanTextFields()
        dismissKeyboard()
        
        
        
    }
    
    
    //MARK: HelperFunctions
    
    func loginUser(){
        ProgressHUD.show("Login...")
        
        FUser.loginUserWith(email: emailTextField.text!, password: enterPasswordTextField.text!)
        { (error) in
            
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            self.goToApp()
            
        }
        
        
        
    }
    
    func cleanTextFields(){
        
        emailTextField.text = ""
        enterPasswordTextField.text = ""
        reenterPasswordTextField.text = ""
    }
    
    func dismissKeyboard(){
          
          self.view.endEditing(false)
    }
    
    
    //MARK: GoToApp
    func goToApp(){
        
        ProgressHUD.dismiss()
        cleanTextFields()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION),  object: nil, userInfo: [kUSERID : FUser.currentId()])
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
        
        
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "welcomeToFinishReg"{
            let vc = segue.destination as! FinishRegistrationViewController
            vc.email = emailTextField.text!
            vc.password = enterPasswordTextField.text!
        }
    }

           
            
       
        
    
}

