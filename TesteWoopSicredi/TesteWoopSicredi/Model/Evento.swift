//
//  Evento.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

class Evento {
    
    var id : String
    var pessoas : [Pessoa] = []
    var date :  String
    var descricao : String
    var urlImagem : String
    var longitude : String
    var latitude : String
    var valor : Double
    var titulo : String
    var cupons : [Cupom] = []
    
    init(json: [String: Any]) {
        
        self.id = json["id"] as? String ?? ""
        self.date = json["date"] as? String ?? ""
        self.descricao = json["description"] as? String ?? ""
        self.urlImagem = json["image"] as? String ?? ""
        self.latitude = json["latitude"] as? String ?? ""
        self.longitude = json["longitude"] as? String ?? ""
        
        if let price = json["price"]{
            self.valor = price as! Double
        }
        else{
            self.valor = 0
        }
        self.titulo = json["title"] as? String ?? ""
        
        let pessoaJson = json["people"] as? Array ?? []
        for pessoa in (pessoaJson as NSArray) as Array {
            let pessoaTmp = Pessoa(json: pessoa as! [String : Any])
            self.pessoas.append(pessoaTmp)
        }
        
        let cuponJson = json["cupons"] as? Array ?? []
        for cupon in (cuponJson as NSArray) as Array {
            let cuponTmp = Cupom(json: cupon as! [String : Any])
            self.cupons.append(cuponTmp)
        }
    }
    
}
