//
//  EventoCellViewModel.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 05/10/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class EventoCellViewModel {
    
    let title: String!
    var preco: String!
    private var _precoLiquido: String!
    var precoLiquido: String {
        return _precoLiquido
    }
    
    init(evento : Evento) {
        
        self.title = evento.title
        self.preco = evento.price.priceFormat()
        self._precoLiquido = ""
        //caso tenha desconto, aplica no preço
        if evento.cupons.count > 0 {
            if evento.cupons[0].discount > 0.0{
                self._precoLiquido = aplicaDesconto(preco: evento.price, desconto: evento.cupons[0].discount).priceFormat()
            }
        }
    }
    
    // MARK: - Aplica Desconto
    func aplicaDesconto(preco: Double, desconto: Double) -> Double {
        
        var valorLiquido: Double = preco
        valorLiquido = valorLiquido - valorLiquido * desconto / 100
        return valorLiquido
    }
    
}

//Add Recurso ao UIImageView
extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                            self.layer.cornerRadius = self.frame.size.height/2
                            self.layer.borderColor = UIColor.darkGray.cgColor
                            self.layer.borderWidth = 1
                            self.clipsToBounds = true
                        }
                    }
                }
            }).resume()
        }
    }
}
