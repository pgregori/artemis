//
//  TargetOverviewSoloGameViewController.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 26/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class TargetOverviewSoloGameViewController: UIViewController {
  
  var targets : Targets = Targets()
  let reuseIdentifier = "TargetsTableViewCell"
  var seconds = 0
  var timer = Timer()
  var loginInfo : LoginInfo = LoginInfo(token: "", tokenExpiretime: 0, firstname: "", mail: "", password: "")
  var beginOfGameTimeStamp = 0
  var shouldLoadTargets = true
  
  @IBOutlet weak var targetsTableView: UITableView!
  @IBOutlet weak var pointsLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    targetsTableView.delegate = self
    targetsTableView.dataSource = self
    targetsTableView.register(UINib(nibName: "TargetsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    targetsTableView.rowHeight = 100
    
    let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    progressHUD.detailsLabel.text = "Bitte warten..."
    
    if shouldLoadTargets {
      ArtemisDataManager.sharedInstance.getTargets { (targets, error) -> Void in //getTargets test
        if error == nil {
          if let responseTargets = targets {
            for target in responseTargets {
              
              self.targets.targetArray.append(target)
            }
          }
        }
        self.targetsTableView.reloadData()
      }
    } else {
      
      self.targetsTableView.reloadData()
    }
    
  
    
    
    ArtemisDataManager.sharedInstance.getTimestampWithToken(token: loginInfo.token, completion: { (timestamp, error) -> Void in
      if error == nil {
        if let timestamp = timestamp {
          print(timestamp)
          self.timer = Timer(timeInterval: 1, target: self, selector: #selector(TargetOverviewSoloGameViewController.updateTimerLabel), userInfo: nil, repeats: true)
          MBProgressHUD.hide(for: self.view, animated: true)
          RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
          self.beginOfGameTimeStamp = timestamp
        }
      } else {
        print(error)
      }
    })
    
    
    
    /*print("LoginInfo:")
    print(loginInfo.token)
    print(loginInfo.tokenExpiretime)
    print(loginInfo.firstname)
    print(loginInfo.mail)
    print(loginInfo.password)*/
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func openDetailView(index: Int) {
    let vc = storyboard?.instantiateViewController(withIdentifier: "TargetDetailViewController") as! TargetDetailViewController
    
    vc.target = targets.targetArray[index]
    vc.delegate = self
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func getTargetPoints() -> Int {
    var targetPoints = 0
    for target in targets.targetArray {
      targetPoints += target.points
    }
    
    return targetPoints
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
  
  @objc func updateTimerLabel() {
    seconds+=1
    timerLabel.text = getFormatedTime(time: seconds)
  }
  
  @IBAction func endRoundButton(_ sender: Any) {
    print("Runde ist jetzt beendet.")
    self.performSegue(withIdentifier: "endSoloGameSegue", sender: self)
  }
  
  //override (was one line below)
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination
    if segue.identifier == "endSoloGameSegue" {
      (vc as! EndSoloGameViewController).targets = self.targets
      (vc as! EndSoloGameViewController).loginInfo = self.loginInfo
      (vc as! EndSoloGameViewController).beginOfGameTimeStamp = self.beginOfGameTimeStamp
      (vc as! EndSoloGameViewController).gameDuration = self.seconds
    }
  }
  
  
}

extension TargetOverviewSoloGameViewController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    openDetailView(index: indexPath.row)
  }
  
}

extension TargetOverviewSoloGameViewController : UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return targets.targetArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //get cell
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TargetsTableViewCell
    
    //configure cell
    //    cell.targetNumberLabel!.text = players.playerArray[indexPath.row].playerName
    //    cell!.text = "\(players.playerArray[indexPath.row].playerPoints) Punkte"
    //    cell.checkImageView.hidden = !(players.playerArray[indexPath.row].roundFinished)
    
    cell.targetNumberLabel!.text = "\(targets.targetArray[indexPath.row].number)"
    cell.targetPointsLabel!.text = "\(targets.targetArray[indexPath.row].points)"
    cell.targetNameLabel!.text = "\(targets.targetArray[indexPath.row].name)"
    cell.targetImageView.image = targets.targetArray[indexPath.row].image
    
    return cell
  }
}

extension TargetOverviewSoloGameViewController : TargetDetailDelegate {
  func didUpdateTarget(target: Target) {
    print("Did update target \(target.name)")
    let int = targets.targetArray.index(of: target)
    targets.targetArray[int!] = target
    targetsTableView.reloadRows(at: [NSIndexPath(row: (int!), section: 0) as IndexPath], with: UITableViewRowAnimation.fade)
    pointsLabel.text = "Punkte: \(getTargetPoints())"
  }
}
