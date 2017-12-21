//
//  QuickGameUsers.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 20/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import Foundation

class QuickGamePlayers : NSObject{
  
  var playerArray : [QuickGamePlayer] = []
  
  func reverseSortPlayerPoints(player1: QuickGamePlayer, player2: QuickGamePlayer) -> Bool {
    if player1.playerPoints > player2.playerPoints {
      return true
    }
    return false
  }
  
  func sortPlayerOrder(player1: QuickGamePlayer, player2: QuickGamePlayer) -> Bool {
    if player1.order < player2.order {
      return true
    }
    return false
  }
  
  func resetFinishedRound() {
    for player in playerArray {
      player.roundFinished = false
    }
  }
  
  func resetPlayerPoints() {
    for player in playerArray {
      player.playerPoints = 0
    }
  }
}