//
//  RegisterViewController.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 20/01/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
  
  var feedbackString : NSData? = nil
  var alertViewIsPresenting : Bool = false
  
  @IBOutlet weak var firstnameTextField: UITextField!
  @IBOutlet weak var lastnameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordRepeatTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    firstnameTextField.delegate = self
    lastnameTextField.delegate = self
    emailTextField.delegate = self
    passwordTextField.delegate = self
    passwordRepeatTextField.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func cancelButtonClick(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func registerButtonClick(_ sender: Any) {
    firstnameTextField.resignFirstResponder()
    lastnameTextField.resignFirstResponder()
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    passwordRepeatTextField.resignFirstResponder()
    
    if let firstname = firstnameTextField.text, let lastname = lastnameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let passwordRepeat = passwordRepeatTextField.text {
      if firstname != "" && lastname != "" && email != "" && password != "" && passwordRepeat != "" && password == passwordRepeat {
        //textfields are not nil and do not contain empty strings and passwords match
        ArtemisDataManager.sharedInstance.registerWithEMail(email: email, firstname: firstname, lastname: lastname, password: password, completion: { (postString) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
          if postString == "user created" {
            self.displayAlertViewWithHeader(header: "Erfolg!", message: postString)
            self.resetTextFields()
          } else {
            self.displayAlertViewWithHeader(header: "Achtung!", message: postString)
          }
          }
        )
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.detailsLabel.text = "Bitte warten..."
       
      } else {
        if passwordRepeatTextField.text == passwordTextField.text { //Not all TextFields are filled
          self.displayAlertViewWithHeader(header: "Achtung!", message: "Bitte alle Felder ausfüllen!")
        } else { //Passwords does not match
          self.displayAlertViewWithHeader(header: "Achtung!", message: "Passwörter stimmen nicht überein!")
        }
      }
    }
  }
  
  func resetTextFields() {
    firstnameTextField.text = ""
    lastnameTextField.text = ""
    emailTextField.text = ""
    passwordTextField.text = ""
    passwordRepeatTextField.text = ""
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  func displayAlertViewWithHeader(header: String, message: String) {
    if alertViewIsPresenting {
    } else {
      alertViewIsPresenting = true
      
      let titleString: String = header
      
      let alertController = UIAlertController(title: titleString, message: message, preferredStyle: UIAlertControllerStyle.alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
      
      self.present(alertController, animated: true, completion: {
        self.alertViewIsPresenting = false
      })
    }
  }
}


extension RegisterViewController : UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
  
}
