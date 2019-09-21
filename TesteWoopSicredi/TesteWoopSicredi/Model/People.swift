//
//  Pessoa.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

struct People: Codable {
    
    var id : String
    var eventId : String
    var name : String
    var picture : String
    
//    init(json: [String: Any]) {
//        self.id = json["id"] as? String ?? ""
//        self.eventId = json["eventId"] as? String ?? ""
//        self.name = json["name"] as? String ?? ""
//        self.picture = json["picture"] as? String ?? ""
//    }

}
