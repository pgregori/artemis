//
//  UserTableViewCell.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 20/02/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var playernameLabel: UILabel!
  @IBOutlet weak var pointsLabel: UILabel!
  @IBOutlet weak var checkImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
