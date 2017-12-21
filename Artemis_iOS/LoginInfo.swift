//
//  LoginInfo.swift
//  Artemis_iOS
//
//  Created by Patrick Gregori on 02/03/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import Foundation

class LoginInfo : NSObject {
  
  var token : String
  var tokenExpiretime : Int
  let firstname : String
  let mail : String
  let password : String
  
  init(token: String, tokenExpiretime: Int, firstname: String, mail: String, password: String) {
    self.token = token
    self.tokenExpiretime = tokenExpiretime
    self.firstname = firstname
    self.mail = mail
    self.password = password
  }
}