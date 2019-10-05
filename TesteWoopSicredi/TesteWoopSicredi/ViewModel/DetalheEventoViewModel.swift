//
//  File.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 05/10/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import Foundation
import UIKit
import MapKit

typealias DataHandlerDetalhe = () -> Void

class DetalheEventoViewModel {
    
    var eventoSelecionado : Evento?
    var reloadView: DataHandlerDetalhe = { }
    var anotacao = MKPointAnnotation()
    var title: String?
    var preço: String?
    var descricao: String!
    
    func carregaTela() {
        if let idEvento: String = self.eventoSelecionado?.id {
            
            WebServiceHelper.getServiceUrlEvento(param: (idEvento)) { (evento) in
                DispatchQueue.main.async {
                    
                    self.title = self.eventoSelecionado!.title
                    self.preço = self.eventoSelecionado!.price.priceFormat()
                    
                    //caso tenha desconto, aplica no preço
                    if self.eventoSelecionado!.cupons.count > 0 {
                        if self.eventoSelecionado!.cupons[0].discount > 0.0{
                            self.preço = self.aplicaDesconto(preco: self.eventoSelecionado!.price, desconto: self.eventoSelecionado!.cupons[0].discount).priceFormat()
                        }
                    }
                    
                    self.descricao = self.eventoSelecionado!.description
                    
                    switch self.eventoSelecionado?.latitude {
                    case .double(let value)?:
                        self.anotacao.coordinate.latitude = value
                        break
                    default: break
                        
                    }
                    
                    switch self.eventoSelecionado?.longitude {
                    case .double(let value)?:
                        self.anotacao.coordinate.longitude = value
                        break
                    default: break
                        
                    }
                    
                    self.reloadView()
                }
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

