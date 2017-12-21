//
//  Target.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 21/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import Foundation
import UIKit

class Target : NSObject {
  
  let id : Int
  let number : Int
  let name : String
  let image : UIImage
  var points : Int
  var shots : Shots
  
  init(id: Int, number: Int, name: String, image: UIImage) {
    self.id = id
    self.number = number
    self.name = name
    self.image = image
    self.points = 0
    self.shots = Shots(shot1: "", shot2: "", shot3: "")
  }
  
  func addPoints(points: Int) {
    self.points += points
  }
}