//
//  Cupom.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

struct Cupons: Codable {
    
    var id : String
    var eventId : String
    var discount : Double

//    init(json: [String: Any]){
//        self.id = json["id"] as? String ?? ""
//        self.eventId = json["eventId"] as? String ?? ""
//
//        if let desc = json["discount"]{
//            self.desconto = desc as! Double
//        }
//        else{
//            self.desconto = 0
//        }
//    }
    
}
