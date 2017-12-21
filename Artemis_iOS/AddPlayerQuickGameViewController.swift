//
//  AddUserQuickGameViewController.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 20/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class AddPlayerQuickGameViewController: UIViewController {
  
  let reuseIdentifier = "PlayerTableViewCell"
  @IBOutlet weak var playerTableView: UITableView!
  @IBOutlet weak var playerTextField: UITextField!
  var players : QuickGamePlayers = QuickGamePlayers()
  var alertViewIsPresenting : Bool = false
  var shouldDisplayWelcomeMessage : Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Players and Points: \(players.playerArray)")
    playerTableView.delegate = self
    playerTableView.dataSource = self
    playerTableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    playerTableView.rowHeight = 55
    
    playerTableView.reloadData()
    
    
    playerTextField.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    super.viewDidAppear(animated)
    if shouldDisplayWelcomeMessage {
      displayAlertViewWithHeader(header: "Quick Game:", message: "Fügen Sie Spieler hinzu und starten Sie Ihre schnelle Runde!")
    }
  }
  
  @IBAction func addUserButton(_ sender: Any) {
    
    self.playerTextField.resignFirstResponder()
    
    if let userTextField = playerTextField {
      if userTextField.text == "" {
        displayAlertViewWithHeader(header: "Achtung!", message: "Bitte geben Sie einen Namen ein!")
      } else {
        players.playerArray.append(QuickGamePlayer(playerName: userTextField.text!, playerPoints: 0, order: players.playerArray.count
          ))
        //players.playerArray.sortInPlace(players.reverseSortPlayerPoints)
        players.playerArray.sort(by: players.sortPlayerOrder)
        userTextField.text = ""
        self.playerTableView.reloadData()
      }
    }
  }
  
  @IBAction func startQuickGameButton(_ sender: Any) {
    //players.playerArray.sortInPlace(players.reverseSortPlayerPoints)
    //self.playerTableView.reloadData()
    
    if players.playerArray.count == 0 {
      displayAlertViewWithHeader(header: "Achtung!", message: "Sie müssen mindestens einen Spieler hinzufügen.")
    } else {
      performSegue(withIdentifier: "playQuickGameSegue", sender: self)
    }
  }
  
  @IBAction func endButton(_ sender: Any) {
    //dismissViewControllerAnimated(true, completion: nil) //Diese Variante führt zu Problemen, wenn man zuvor im EndQuickGameViewController war
    performSegue(withIdentifier: "returnToLoginSegue", sender: self)
  }
  
  //override (was one line below)
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //segue.identifier
    let vc = segue.destination
    print(self.players)
    if (segue.identifier == "playQuickGameSegue"){
      (vc as! PlayQuickGameViewController).players = self.players
    }
  }
  
  //hides the keyboard
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

extension AddPlayerQuickGameViewController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //This code was used to test the UITableViewDelegate
    //players.playerArray[indexPath.row].roundFinished = !(players.playerArray[indexPath.row].roundFinished)
    playerTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
  }
  
}

extension AddPlayerQuickGameViewController : UITableViewDataSource {
  
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


extension AddPlayerQuickGameViewController : UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    
    if let userTextField = playerTextField {
      if userTextField.text == "" {
        displayAlertViewWithHeader(header: "Achtung!", message: "Bitte geben Sie einen Namen ein!")
      } else {
        players.playerArray.append(QuickGamePlayer(playerName: userTextField.text!, playerPoints: 0, order: players.playerArray.count
          ))
        //players.playerArray.sortInPlace(players.reverseSortPlayerPoints)
        players.playerArray.sort(by: players.sortPlayerOrder)
        userTextField.text = ""
        self.playerTableView.reloadData()
      }
    }
    
    return false
  }
  
}


