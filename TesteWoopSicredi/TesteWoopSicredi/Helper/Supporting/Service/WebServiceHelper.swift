//
//  WebServiceHelper.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

class WebServiceHelper: NSObject {
    
    static func getServiceUrlListaEvento( onComplete: @escaping ([Evento]) -> Void) {
        
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Root", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
        
        let service: String = nsDictionary?.value(forKey: "url") as! String
        
        let escapedURLString = service.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let url = URL(string: escapedURLString!)
        
        let requestURL = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        requestURL.addValue("text/x-json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        requestURL.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: requestURL as URLRequest) { data, response, error -> Void in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {return}
                if response.statusCode == 200 {
                    guard let data = data else{return}
                    do {
                        let eventos = try JSONDecoder().decode([Evento].self, from: data)
                        onComplete(eventos)
                        for teste in eventos {
                            print(teste.description)
                        }
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
        
    }
    
    static func getServiceUrlEvento(param: String, onComplete: @escaping (Evento) -> Void) {
        
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Root", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
        
        var service: String = nsDictionary?.value(forKey: "url") as! String
        
        if param != "" {
            service = service + "/\(param)"
        }
        
        let escapedURLString = service.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let url = URL(string: escapedURLString!)
        
        let requestURL = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        requestURL.addValue("text/x-json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        requestURL.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: requestURL as URLRequest) { data, response, error -> Void in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {return}
                if response.statusCode == 200 {
                    guard let data = data else{return}
                    do {
                        let evento = try JSONDecoder().decode(Evento.self, from: data)
                        onComplete(evento)
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
        
    }
    
    //metodo generico para realizar o GET de serviços
    
    static func enviaPost(_ servico : String, pessoa : People) -> String {
        
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
        //#gotResp: semáforo para retorno, simula um retorno sincrono
        var gotResp = false
        
        do {
            //envia post assincrono
            let task = URLSession.shared.dataTask(with: requestURL as URLRequest) { data, response, error -> Void in
                
                erro = error
                responseData = data
                gotResp = true
            }
            task.resume()
            
            //aguarda o retorno para liberar
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
    
    //metodo para mostar Json do Check in
    static func jsonDataPost(_ pessoa:People) -> Data! {
        
        let keys = NSMutableArray()
        let values = NSMutableArray()
        
        keys.add("eventId")
        values.add(pessoa.eventId)
        
        keys.add("name")
        values.add(pessoa.name)
        
        //nao recebo e-mail da API
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
