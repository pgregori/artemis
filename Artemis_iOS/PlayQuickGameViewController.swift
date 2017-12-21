//
//  PlayQuickGameViewController.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 20/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class PlayQuickGameViewController: UIViewController {
  
  let reuseIdentifier = "PlayerTableViewCell"
  var players : QuickGamePlayers = QuickGamePlayers()
  let pickerData = [
    ["Out","Body","Kill"],
    ["Out","Body","Kill"],
    ["Out","Body","Kill"]
  ]
  var round : Int = 0
  var currentPlayer : Int = 0
  
  @IBOutlet weak var playerTableView: UITableView!
  @IBOutlet weak var shotCountingPickerView: UIPickerView!
  @IBOutlet weak var currentPlayerLabel: UILabel!
  @IBOutlet weak var currentRoundLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    players.playerArray.sort(by: players.sortPlayerOrder)
    for player in players.playerArray {
      
      print(player.playerName)
    }
    //Table View:
    playerTableView.delegate = self
    playerTableView.dataSource = self
    playerTableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    playerTableView.rowHeight = 55
    
    //Picker:
    shotCountingPickerView.delegate = self
    shotCountingPickerView.dataSource = self
    
    //Labels:
    currentRoundLabel.text = "\(round+1)"
    currentPlayerLabel.text = players.playerArray[currentPlayer].playerName
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func nextPlayerButton(_ sender: Any) {
    let pickerPoints = getPickerPoints()
    
    if players.playerArray.count == 1 { //If only ONE player plays
      players.playerArray[currentPlayer].addPoints(points: pickerPoints)
      playerTableView.reloadRows(at: [NSIndexPath(row: (currentPlayer), section: 0) as IndexPath], with: UITableViewRowAnimation.fade)
      round+=1
    } else { //If more than one player plays
      currentPlayer+=1
      if currentPlayer == players.playerArray.count { //Last player
        players.playerArray[currentPlayer-1].addPoints(points: pickerPoints)
        players.resetFinishedRound()
        playerTableView.reloadData()
        currentPlayer = 0
        round+=1
        currentPlayerLabel.text = players.playerArray[currentPlayer].playerName
        
      } else { //Not the last player
        players.playerArray[currentPlayer-1].addPoints(points: pickerPoints)
        players.playerArray[currentPlayer-1].roundFinished = true
        playerTableView.reloadRows(at: [NSIndexPath(row: (currentPlayer-1), section: 0) as IndexPath], with: UITableViewRowAnimation.fade)
        currentPlayerLabel.text = players.playerArray[currentPlayer].playerName
        
      }
    }
    
    currentRoundLabel.text = "\(round+1)"
    resetPickerView()
  }
  
  @IBAction func endQuickGameButton(_ sender: Any) {
    players.resetFinishedRound()
    performSegue(withIdentifier: "endQuickGameSegue", sender: self)
  }
  
  func getPickerPoints() -> Int {
    
    var firstShotPoints : Int = 0
    var secondShotPoints : Int = 0
    var thirdShotPoints : Int = 0
    
    switch shotCountingPickerView.selectedRow(inComponent: 0) {
    case 0:
      firstShotPoints = 0
    case 1:
      firstShotPoints = 18
    case 2:
      firstShotPoints = 20
    default:
      firstShotPoints = 0
    }
    
    switch shotCountingPickerView.selectedRow(inComponent: 1) {
    case 0:
      secondShotPoints = 0
    case 1:
      secondShotPoints = 14
    case 2:
      secondShotPoints = 16
    default:
      secondShotPoints = 0
    }
    
    switch shotCountingPickerView.selectedRow(inComponent: 2) {
    case 0:
      thirdShotPoints = 0
    case 1:
      thirdShotPoints = 10
    case 2:
      thirdShotPoints = 12
    default:
      thirdShotPoints = 0
    }
    
    return firstShotPoints + secondShotPoints + thirdShotPoints
  }
  
  func resetPickerView() {
    shotCountingPickerView.selectRow(0, inComponent: 0, animated: true)
    shotCountingPickerView.selectRow(0, inComponent: 1, animated: true)
    shotCountingPickerView.selectRow(0, inComponent: 2, animated: true)
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  //override (was one line below first)
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination
    
    if (segue.identifier == "endQuickGameSegue"){
      (vc as! EndQuickGameViewController).players = self.players
    }
    
    /*
    let vc = segue.destinationViewController.storyboard?.instantiateViewControllerWithIdentifier("AddPlayerQuickGameViewController") as! AddPlayerQuickGameViewController
    
    vc.players = QuickGamePlayers()
    */ //Maybe useful code
  }
}

extension PlayQuickGameViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return players.playerArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //get cell
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PlayerTableViewCell
    
    //configure cell
    cell.playernameLabel!.text = players.playerArray[indexPath.row].playerName
    cell.pointsLabel!.text = "\(players.playerArray[indexPath.row].playerPoints) Punkte"
    cell.checkImageView.isHidden = !(players.playerArray[indexPath.row].roundFinished)
    
    return cell
  }
}

extension PlayQuickGameViewController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    playerTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
  }
  
}

extension PlayQuickGameViewController : UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return pickerData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData[component].count
  }
  
}

extension PlayQuickGameViewController : UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[component][row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
  }
}
