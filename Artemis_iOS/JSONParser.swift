//
//  JSONParser.swift
//  ParsingJSON
//
//  Created by Patrick Gregori on 14/01/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import Foundation

class JSONParser {
  static let sharedInstance = JSONParser()
  
  func parseDictionaryWithData(data: Data?) -> [String:AnyObject]? {
    do {
        if let data = data, let json = try JSONSerialization.jsonObject(with: data as Data, options:[]) as? [String: AnyObject] {
        return json
      }
    } catch {
      print("couldn't parse JSON")
    }
    return nil
  }
  
  func parseIntWithData(data: Data?) -> Int? {
    do {
      //NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])
        if let data = data, let json = try JSONSerialization.jsonObject(with: data as Data, options: [.allowFragments]) as? Int {//NSObject {
        return json
      }
    } catch {
      print("couldn't parse JSON")
    }
    return nil
  }
}
