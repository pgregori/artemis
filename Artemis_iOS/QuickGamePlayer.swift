//
//  QuickGamePlayer.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 21/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import Foundation

class QuickGamePlayer : NSObject{
  
  var playerName : String
  var playerPoints : Int
  var order : Int
  var roundFinished : Bool
  
  init(playerName: String, playerPoints: Int, order: Int) {
    self.playerName = playerName
    self.playerPoints = playerPoints
    self.order = order
    self.roundFinished = false
  }
  
  func addPoints(points: Int) {
    playerPoints += points
  }
  
}