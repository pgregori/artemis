//
//  ArtemisDataManager.swift
//  ParsingJSON
//
//  Created by Patrick Gregori on 14/01/16.
//  Copyright © 2016 Patrick Gregori. All rights reserved.
//

import Foundation
import UIKit

class ArtemisDataManager {
  static let baseURL = "http://artemis.weilharter.one/api/v1/"
  static let sharedInstance = ArtemisDataManager(url: ArtemisDataManager.baseURL)
  
  let baseUrl: NSURL
  let session : URLSession
  let sessionConfig : URLSessionConfiguration
  
  init(url: String) {
    baseUrl = NSURL.init(string: url)!
    sessionConfig = URLSessionConfiguration.default
    sessionConfig.httpAdditionalHeaders = ["Content-Type":"application/json"]
    session = URLSession(configuration: sessionConfig)
  }
  
  func registerWithEMail(email: String, firstname: String, lastname: String, password: String, completion: @escaping (_ postString: String) -> Void) {
    let postEndpoint = baseUrl.appendingPathComponent("register")
    
    let postParams : [String: AnyObject] = ["mail": email as AnyObject,
                                            "password": password as AnyObject,
                                            "firstname": firstname as AnyObject,
                                            "lastname": lastname as AnyObject]
    
    makeHTTPPostRequest(path: (postEndpoint as! URL) as URL, body: postParams) { (result, error) -> Void in
      if error == nil {
        if let result = result {
          let nsdata = JSONParser.sharedInstance.parseDictionaryWithData(data: result as Data)
          if let nsdata = nsdata {
            let message = nsdata["message"]
            if let message = message {
                print("Result: \(message) Error: \(error)")
                completion(message as! String)
            }
          }
        }
      } else {
        completion("Ein unerwarteter Fehler ist aufgetreten.")
      }
    }
  }
  
  
  func loginWithEMail(email: String?, password: String?, completion: @escaping (_ loginInfo: LoginInfo?, _ error: String?) -> Void) {
        if let email = email, let password = password {
            let url = baseUrl.appendingPathComponent("login")
      
            let postParams : [String : AnyObject] = ["mail": email as AnyObject,
                                                     "password": password as AnyObject]
      
          makeHTTPPostRequest(path: url!, body: postParams, completion: { (data, error) -> Void in
        if (error != nil) {
            completion(nil, "Error")
          return
        }
            let dataDict = JSONParser.sharedInstance.parseDictionaryWithData(data: data)
            
        if let dataDict = dataDict { //everything alright
          let token = dataDict["token"] as! String
          let tokenExpiretime = dataDict["tokenexpiretime"] as! Int
          let userDict = dataDict["user"] as! NSDictionary
          
          let firstname = userDict["firstname"] as! String
          
            completion(LoginInfo(token: token, tokenExpiretime: tokenExpiretime, firstname: firstname, mail: email, password: password), nil)
          
        } else {
            completion(nil, "No Data")
        }
      })
    }
  }
  
  func getTargets(completion: @escaping (_ targets: [Target]?, _ error: String?) -> Void) {
        let url = baseUrl.appendingPathComponent("targets")
    
    
        makeHTTPGetRequest(path: url as! URL, completion: { (data, error) -> Void in
      if (error != nil) {
        completion(nil, "Error")
        return
      }
            let dataDict = JSONParser.sharedInstance.parseDictionaryWithData(data: data)
      
      if let dataDict = dataDict {
        let targets = dataDict["targets"] as! NSArray
        
        var returnTargets : [Target] = []
        
        for target in targets {
          let targetDict = target as! NSDictionary
          //String(targetDict["id"])
          let id = targetDict["id"] as! Int
          let number = targetDict["number"] as! Int
          let name = targetDict["name"] as! String
          
          let base64StringArray = (targetDict["image"] as! String).components(separatedBy: ",")
            let imageData = NSData(base64Encoded: base64StringArray[1], options: NSData.Base64DecodingOptions())
            let image = UIImage(data: imageData! as Data)
          
          returnTargets.append(Target(id: id, number: number, name: name, image: image!))
        }
        
        
        completion(returnTargets, nil)
        
      } else {
        completion(nil, "No Data")
      }
    })
    
  }
  
  func getTimestampWithToken(token: String, completion: @escaping (_ timestamp: Int?, _ error: String?) -> Void) {
    let urli = baseUrl.relativeString
    
    guard let urlWithToken = NSURL.init(string: urli + "currenttime?token=\(token)") else {
      completion(nil, nil)
      return
    }
    
    makeHTTPGetRequest(path: urlWithToken as URL, completion: { (data, error) -> Void in
      if (error != nil) {
        completion(nil, "Error")
        return
      }
      print(String(data: data!, encoding: String.Encoding.utf8) as String!)
      
      if let data = data {
        let dataInt = JSONParser.sharedInstance.parseIntWithData(data: data)
        completion(dataInt, nil)
      } else {
        completion(nil, "No Data")
      }
    })
    
  }
  
  
  func postBattlesWithToken(token: String, beginTimeStamp: Int, endTimeStamp: Int, targets : Targets, completion: @escaping (_ postString: String) -> Void) {
    
    //var urlWithToken : NSURL = NSURL()
    let urli = baseUrl.relativeString
    
    guard let urlWithToken = NSURL.init(string: urli + "battles?token=\(token)") else {
      completion("error")
      return
    }
    
    //urlWithToken = NSURL.init(string: urli + "battles?token=\(token)")!
    
    
    
    var postDict = [String: AnyObject]()
    postDict["begin"] = beginTimeStamp as AnyObject
    postDict["end"] = endTimeStamp as AnyObject
    
    var targetArray = [AnyObject]()
    //Url zusammenbauen
    for target in targets.targetArray {
      var targetDict = [String: AnyObject]()
      targetDict["target_id"] = target.id as AnyObject;
      
      
      var shotArray = [AnyObject]()
      var shotDict = [String: AnyObject]()
      
        shotDict["shot"] = 1 as AnyObject
      if let type = target.shots.getShot1() {
        shotDict["type"] = type as AnyObject
      } else {
        shotDict["type"] = "out" as AnyObject
      }
      shotArray.append(shotDict as AnyObject)
      
      shotDict["shot"] = 2 as AnyObject
      if let type = target.shots.getShot2() {
        shotDict["type"] = type as AnyObject
      } else {
        shotDict["type"] = "out" as AnyObject
      }
      shotArray.append(shotDict as AnyObject)
      
      shotDict["shot"] = 3 as AnyObject
      if let type = target.shots.getShot3() {
        shotDict["type"] = type as AnyObject
      } else {
        shotDict["type"] = "out" as AnyObject
      }
        shotArray.append(shotDict as AnyObject)
      
        targetDict["shots"] = shotArray as AnyObject
      
      targetArray.append(targetDict as AnyObject)
    }
    
    postDict["scores"] = targetArray as AnyObject
    
    //print(postDict)
    
    makeHTTPPostRequest(path: urlWithToken as URL, body: postDict) { (postString, error) in
      
      print(String(data: postString!, encoding: String.Encoding.utf8) as String!)
      if let _ = error {
        completion("Ein Error ist aufgetreten")
      } else {
        completion("Erfolgreich am Server gespeichert")
      }
      
    }
    
  }
  
  
  func makeHTTPGetRequest(path: URL, completion: @escaping (_ result: Data?, _ error: Error?) -> Void) {
    let request = NSMutableURLRequest(url: path as URL)
    request.httpMethod = "GET"
    
    session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
      //print("Check that GET request")
      //print("Data: \(data)")
      //print("Resp: \(response)")
      //print("Erro: \(error)")
      
      /*DispatchQueue.async(DispatchQueue.main, { () ->Void in
        completion(data as! NSData, error as! NSError)
      })
      
     }.resume()*/
      
      DispatchQueue.main.async{
        completion(data, error)
        
      }
      
    }.resume()
    
  }
  
  func makeHTTPPostRequest(path: URL, body: [String: AnyObject]?, completion: @escaping (_ result: Data?, _ error: Error?) -> Void) {
    var request = URLRequest(url: path as URL)
    request.httpMethod = "POST"
    
    let requestData : NSData
    do {
      if let body = body {
        requestData = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
      } else {
        requestData = NSData()
      }
    } catch {
      print("error parsing nsdata!")
      requestData = NSData()
    }
    
    request.httpBody = requestData as Data/*
    
    session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
      //print("Check that POST request")
      //print("Data: \(data)")
      //print("Resp: \(response)")
      //print("Erro: \(error)")
      DispatchQueue.async(DispatchQueue.main, { () -> Void in
        completion(data as! NSData, error as! NSError)
      })
      
      }.resume()*/
    
    session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
      //print("Check that POST request")
      //print("Data: \(data)")
      //print("Resp: \(response)")
      //print("Erro: \(error)")
      //DispatchQueue.async()
      
      DispatchQueue.main.async {
        completion(data, error)
      }
      
      }.resume()
  }
}
