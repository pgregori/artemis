//
//  TargetsTableViewCell.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 26/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class TargetsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var targetNumberLabel: UILabel!
  @IBOutlet weak var targetNameLabel: UILabel!
  @IBOutlet weak var targetPointsLabel: UILabel!
  @IBOutlet weak var targetImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
