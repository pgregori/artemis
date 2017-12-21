//
//  EndQuickGameViewController.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 25/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class EndQuickGameViewController: UIViewController {
  
  let reuseIdentifier = "PlayerTableViewCell"
  var players : QuickGamePlayers = QuickGamePlayers()
  var alertViewIsPresenting : Bool = false
  @IBOutlet weak var playerTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    playerTableView.delegate = self
    playerTableView.dataSource = self
    playerTableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    playerTableView.rowHeight = 55
    
    players.playerArray.sort(by: players.reverseSortPlayerPoints)
    playerTableView.reloadData()
  }
  
  //viewwill
  
  //viewWil Save Userdata when iPhone sleeps googeln
  
  //view
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func sortByStartnumberButton(_ sender: Any) {
    players.playerArray.sort(by: players.sortPlayerOrder)
    playerTableView.reloadData()
  }
  
  @IBAction func sortByPointsButton(_ sender: Any) {
    players.playerArray.sort(by: players.reverseSortPlayerPoints)
    playerTableView.reloadData()
  }
  
  @IBAction func startNewRoundButton(_ sender: Any) {
    players.resetPlayerPoints()
    performSegue(withIdentifier: "addPlayerSegue", sender: self)
  }
  
  @IBAction func endQuickGameButton(_ sender: Any) {
    performSegue(withIdentifier: "loginSegue", sender: self)
  }
  
  //override (was one line below)
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //segue.identifier
    let vc = segue.destination
    
    if (segue.identifier == "addPlayerSegue"){
      (vc as! AddPlayerQuickGameViewController).players = self.players
      (vc as! AddPlayerQuickGameViewController).shouldDisplayWelcomeMessage = false
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

extension EndQuickGameViewController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    players.playerArray[indexPath.row].roundFinished = !(players.playerArray[indexPath.row].roundFinished)
    playerTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
  }
  
}

extension EndQuickGameViewController : UITableViewDataSource {
 
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return players.playerArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //get cell
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PlayerTableViewCell
    
    //configure cell
    cell.playernameLabel!.text = players.playerArray[indexPath.row].playerName
    cell.pointsLabel!.text = "\(players.playerArray[indexPath.row].playerPoints) Punkte"
    cell.checkImageView.isHidden = !(players.playerArray[indexPath.row].roundFinished)
    
    return cell
  }
}
