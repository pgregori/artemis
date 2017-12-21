//
//  TargetDetailViewController.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 28/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

protocol TargetDetailDelegate {
  func didUpdateTarget(target: Target)
}

class TargetDetailViewController: UIViewController {
  
  var delegate : TargetDetailDelegate?
  var target : Target?
  let pickerData = [
    ["Out","Körper","Kill"],
    ["Out","Körper","Kill"],
    ["Out","Körper","Kill"]
  ]
  var points = 0
  
  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var targetImageView: UIImageView!
  @IBOutlet weak var shotCountingPickerView: UIPickerView!
  @IBOutlet weak var pointsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Picker:
    shotCountingPickerView.delegate = self
    shotCountingPickerView.dataSource = self
    
    if let target = target {
      numberLabel.text = "# \(target.number)"
      nameLabel.text = target.name
      targetImageView.image = target.image
      setPickerViewFirstShot(firstShot: getIndexOfShot(shot: target.shots.getShot1()),
                             secondShot: getIndexOfShot(shot: target.shots.getShot2()),
                             thirdShot: getIndexOfShot(shot: target.shots.getShot3()))
    }
    pointsLabel.text = "Punkte: \(getPickerPoints())"
    points = getPickerPoints()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if let target = target {
      target.points = points
      delegate!.didUpdateTarget(target: target)
    }
    
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
  
  func getPickerShot1() -> String {
    var firstShot : String
    
    switch shotCountingPickerView.selectedRow(inComponent: 0) {
    case 0:
      firstShot = ""
    case 1:
      firstShot = "body"
    case 2:
      firstShot = "kill"
    default:
      firstShot = ""
    }
    
    return firstShot
  }
  
  func getPickerShot2() -> String {
    var secondShot : String
    
    switch shotCountingPickerView.selectedRow(inComponent: 1) {
    case 0:
      secondShot = ""
    case 1:
      secondShot = "body"
    case 2:
      secondShot = "kill"
    default:
      secondShot = ""
    }
    
    return secondShot
  }
  
  func getPickerShot3() -> String{
    var thirdShot : String
    
    switch shotCountingPickerView.selectedRow(inComponent: 2) {
    case 0:
      thirdShot = ""
    case 1:
      thirdShot = "body"
    case 2:
      thirdShot = "kill"
    default:
      thirdShot = ""
    }
    
    return thirdShot
  }
  
  func setPickerViewFirstShot(firstShot : Int, secondShot : Int, thirdShot : Int) {
    shotCountingPickerView.selectRow(firstShot, inComponent: 0, animated: false)
    shotCountingPickerView.selectRow(secondShot, inComponent: 1, animated: false)
    shotCountingPickerView.selectRow(thirdShot, inComponent: 2, animated: false)
  }
  
  func getIndexOfShot(shot : String?) -> Int {
    let returnIndex : Int
    if let shot = shot {
      switch shot {
      case "":
        returnIndex = 0
      case "body":
        returnIndex = 1
      case "kill":
        returnIndex = 2
      default:
        returnIndex = 0
      }
    } else {
      returnIndex = 0
    }
    
    return returnIndex
  }
}

extension TargetDetailViewController : UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return pickerData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData[component].count
  }
  
}

extension TargetDetailViewController : UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[component][row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    points = getPickerPoints()
    pointsLabel.text = "Punkte: \(points)"
    if let target = target {
      target.shots = Shots(shot1: getPickerShot1(), shot2: getPickerShot2(), shot3: getPickerShot3())
    }
  }
}

