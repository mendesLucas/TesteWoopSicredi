//
//  FormatPrice.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

extension Double {
    
    // MARK: - Formata Preço
    func priceFormat() -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        
        if let precoFinal = nf.string(from: NSNumber(value: self)){
            let precoUI = String(format: "R$ %@", precoFinal)
            return precoUI
        }
        return "0,00"
    }
    
}



