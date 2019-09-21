//
//  Evento.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

struct Evento: Codable {
    
    var id : String
    var people : [People]
    var date :  Int
    var description : String
    var image : String
    var price : Double
    var title : String
    var cupons : [Cupons]
    var longitude : ConvertValue
    var latitude: ConvertValue
    
    
    enum CodingKeys: String, CodingKey {
        case people, date
        case description
        case image, longitude, latitude, price, title, id, cupons
    }
}

enum ConvertValue: Codable {
    
    case double(Double), string(String)
    
    init(from decoder: Decoder) throws {
        
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            
            self = .double(Double(string)!)
            return
        }
        
        throw ConvertError.missingValue
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    enum ConvertError:Error {
        case missingValue
    }
}
