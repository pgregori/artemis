//
//  Shots.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 29/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import Foundation

class Shots : NSObject {
  
  var shot1 : String?
  var shot2 : String?
  var shot3 : String?
  
  init(shot1 : String, shot2 : String, shot3 : String) {
    
    self.shot1 = shot1
    self.shot2 = shot2
    self.shot3 = shot3
    
    if shot1 == "" {
      self.shot1 = nil
    }
    
    if shot2 == "" {
      self.shot2 = nil
    }
    
    if shot3 == "" {
      self.shot3 = nil
    }
  }
  
  func getShot1() -> String? {
    return shot1
  }
  
  func getShot2() -> String? {
    return shot2
  }
  
  func getShot3() -> String? {
    return shot3
  }
  
  func resetShots() {
    shot1 = nil
    shot2 = nil
    shot3 = nil
  }
}