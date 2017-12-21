//
//  LoginViewController.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 07/01/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  var loginInfo : LoginInfo = LoginInfo(token: "", tokenExpiretime: 0, firstname: "", mail: "", password: "")
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func loginButton(_ sender: Any) {
    
    //Hide keyboard:
    self.usernameTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()
    
    if usernameTextField.text != "" && passwordTextField.text != "" {
      self.loadingIndicator.isHidden = false
      ArtemisDataManager.sharedInstance.loginWithEMail(email: usernameTextField.text, password: passwordTextField.text, completion: {(loginInfo, error) -> Void in
        self.loadingIndicator.isHidden = true
        if let loginInfo = loginInfo {
          self.loginInfo = loginInfo
          self.performSegue(withIdentifier: "playSoloGameSegue", sender: self)
        }
      })
    }
  }
  
  @IBAction func registerButton(_ sender: Any) {
    self.performSegue(withIdentifier: "registerSegue", sender: nil)
  }
    
  @IBAction func quickGameButton(_ sender: Any) {
    self.performSegue(withIdentifier: "quickGameSegue", sender: nil)
  }
    
  //override (was one line below)
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "playSoloGameSegue" { //check if segue to TargetOverViewSoloGameViewController
      let navController : UINavigationController = segue.destination as! UINavigationController
      let vc = navController.viewControllers[0] as! TargetOverviewSoloGameViewController
      vc.loginInfo = loginInfo
    }
  }
  
  //Hides the keyboard when you touch somewhere on the screen
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
}

extension LoginViewController : UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
  
}
