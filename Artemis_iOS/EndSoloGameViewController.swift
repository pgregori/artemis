//
//  EndSoloGameViewController.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 02/03/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class EndSoloGameViewController: UIViewController {
  
  var targets : Targets = Targets()
  var loginInfo : LoginInfo = LoginInfo(token: "", tokenExpiretime: 0, firstname: "", mail: "", password: "")
  var beginOfGameTimeStamp = 0
  var endOfGameTimeStamp = 0
  var gameDuration = 0
  var alertViewIsPresenting : Bool = false
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var pointsLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    progressHUD.detailsLabel.text = "Wird berechnet..."
    
    nameLabel.text = loginInfo.firstname
    
    var points = 0
    
    for target in targets.targetArray {
      points += target.points
    }
    
    pointsLabel.text = "\(points)"
    
    
    if (beginOfGameTimeStamp + gameDuration + 100) < loginInfo.tokenExpiretime { //100 seconds buffer if connection is bad
      //print("token gültig")
      //print("\(beginOfGameTimeStamp + gameDuration + 100)")
      //print("Expiretime - berechnete Dauer:\(self.loginInfo.tokenExpiretime - beginOfGameTimeStamp - gameDuration - 100)")
      
      ArtemisDataManager.sharedInstance.getTimestampWithToken(token: loginInfo.token, completion: { (timestamp, error) -> Void in
        if error == nil {
          if let timestamp = timestamp {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.endOfGameTimeStamp = timestamp
            self.durationLabel.text = self.getFormatedTime(time: self.endOfGameTimeStamp - self.beginOfGameTimeStamp)
          }
        } else {
          print(error)
        }
      })
      
    } else {
      print("token ungültig")
      ArtemisDataManager.sharedInstance.loginWithEMail(email: loginInfo.mail, password: loginInfo.password, completion: { (loginInfo, error) in
        if let loginInfo = loginInfo {
          self.loginInfo = loginInfo
          
          
          ArtemisDataManager.sharedInstance.getTimestampWithToken(token: loginInfo.token, completion: { (timestamp, error) -> Void in
            if error == nil {
              if let timestamp = timestamp {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.endOfGameTimeStamp = timestamp
                self.durationLabel.text = self.getFormatedTime(time: self.endOfGameTimeStamp - self.beginOfGameTimeStamp)
              }
            } else {
              print(error)
            }
          })
          
        }
      })
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func saveButton(_ sender: Any) {
    print("Game saved.")
    
    let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    progressHUD.detailsLabel.text = "Bitte warten..."

    
    ArtemisDataManager.sharedInstance.postBattlesWithToken(token: loginInfo.token, beginTimeStamp: beginOfGameTimeStamp, endTimeStamp: endOfGameTimeStamp, targets: targets) { (postString) in
      MBProgressHUD.hide(for: self.view, animated: true)
      self.displayAlertViewWithHeader(header: "Meldung:", message: postString)
      print(postString)
    }
  }
  
  @IBAction func newRoundButton(_ sender: Any) {
    self.performSegue(withIdentifier: "returnToTargetOverviewSegue", sender: self)
  }
  
  @IBAction func endButton(_ sender: Any) {
    self.performSegue(withIdentifier: "loginSegue", sender: self)
  }
  
  func getFormatedTime(time: Int) -> String {
    
    let seconds : Int
    let minutes : Int
    let hours : Int
    
    seconds = time % 60
    minutes = ((time - seconds) / 60) % 60
    hours = ((time - seconds - minutes) / 3600) % 60
    
    let secondsString = NSString(format: "%02d", seconds)
    let minutesString = NSString(format: "%02d", minutes)
    let hoursString = NSString(format: "%02d", hours)
    
    return "\(hoursString):\(minutesString):\(secondsString)"
  }
  
  //override (was one line below)
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "returnToTargetOverviewSegue") {
      let navController : UINavigationController = segue.destination as! UINavigationController
      let vc = navController.viewControllers[0] as! TargetOverviewSoloGameViewController
      
      for target in self.targets.targetArray {
        target.points = 0
        target.shots.resetShots()
      }
      
      vc.targets = targets
      vc.loginInfo = loginInfo
      vc.shouldLoadTargets = false
      
    }
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
