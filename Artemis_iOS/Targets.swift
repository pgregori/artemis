//
//  Targets.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 27/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import Foundation
import UIKit

class Targets : NSObject {
  
  var targetArray : [Target] = []
  
  func sortTargetsByNumber(target1: Target, target2: Target) -> Bool {
    if target1.number > target2.number {
      return true
    }
    return false
  }
}