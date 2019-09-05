//
//  WebServiceHelper.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

class WebServiceHelper: NSObject {
    
    static func getServiceUrl(_ service : String) -> AnyObject! {
        
        let escapedURLString = service.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let url = URL(string: escapedURLString!)
        
        let requestURL = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        requestURL.addValue("text/x-json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        requestURL.httpMethod = "GET"
        
        var erro: Error? = nil
        var responseData: Data?
        var gotResp = false
        
        let task = URLSession.shared.dataTask(with: requestURL as URLRequest) { data, response, error -> Void in
            
            erro = error
            responseData = data
            gotResp = true
        }
        task.resume()
        
        while !gotResp {
        }
        
        if (erro == nil){
            do {
                if let returnDictionary = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, Any> {
                    
                    return returnDictionary as AnyObject
                }
                
                if let returnArray = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Any> {
                    
                    return returnArray as AnyObject
                }
            }
            catch {
            }
        }
        return nil
    }
    
    static func enviaPost(_ servico : String, pessoa : Pessoa) -> String {
        
        var msgRetorno: String = ""
        let urlString = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"
        let url = URL(string: urlString)
        
        let requestURL = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        requestURL.addValue("application/json", forHTTPHeaderField: "Accept")
        requestURL.addValue("text/x-json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        requestURL.httpMethod = "POST"
        requestURL.httpBody = jsonDataPost(pessoa)
        
        var erro: Error? = nil
        var responseData: Data?
        var gotResp = false
        
        do {
            let task = URLSession.shared.dataTask(with: requestURL as URLRequest) { data, response, error -> Void in
                
                erro = error
                responseData = data
                gotResp = true
            }
            task.resume()
            
            while !gotResp {
            }
            
            if (erro == nil){
                do {
                    if let returnDictionary = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, Any> {
                        
                        if let retorno = returnDictionary["code"]{
                            msgRetorno = retorno as! String
                        }
                    }
                    
                }
                catch {
                }
            }
            
        }

        return msgRetorno
    }
    
    var isSucess: Bool = false
    var msgException: String! = nil
    
    static func jsonDataPost(_ pessoa:Pessoa) -> Data! {
        
        let keys = NSMutableArray()
        let values = NSMutableArray()
        
        keys.add("eventId")
        values.add(pessoa.eventId)
        
        keys.add("name")
        values.add(pessoa.name)
        
        keys.add("email")
        values.add("")
        
        let postDict = NSDictionary(objects: values as [AnyObject], forKeys: keys .mutableCopy() as! [NSCopying])
        
        let error: NSErrorPointer = nil
        let jsonData: Data = try! JSONSerialization.data(withJSONObject: postDict, options: [])
        let jsonDict: AnyObject?
        do {
            jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject
        } catch let error1 as NSError {
            error?.pointee = error1
            jsonDict = nil
        }
        print("Json a ser enviado:\n\(String(describing: jsonDict))")
        return jsonData
    }

}
