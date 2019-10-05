//
//  ListaEventosViewModel.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 21/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import Foundation
import UIKit

typealias DataHandler = () -> Void

class ListaEventosViewModel {

    var eventos : [Evento] = []
    var reloadView: DataHandler = { }
    
     func carregaTela() {
        //busca eventos da API
        WebServiceHelper.getServiceUrlListaEvento{ (eventos) in
            
            self.eventos = eventos
            
            DispatchQueue.main.async {
                self.reloadView()
            }
        }
    }
}

