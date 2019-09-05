//
//  ListaEventosTableViewController.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

class ListaEventosTableViewController: UITableViewController {

    var eventos : [Evento] = []
    var eventoSelecionado : Evento?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        carregaTela()
    }
    
    // MARK: - carregaTela
    //Carrega tela com a lista de eventos
    func carregaTela() {
        
        let urlString = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
        //busca eventos da API
        if let retornoEventos = WebServiceHelper.getServiceUrl(urlString) {
            for evento in (retornoEventos as! NSArray) as Array {
                //carrega(inicializa) o objeto Evento
                let eventoTmp = Evento(json: evento as! [String : Any])
                eventos.append(eventoTmp)
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellEvento", for: indexPath) as! ListaEventosTableViewCell
        
        let evento : Evento = self.eventos[indexPath.row]
        
        cell.lblTitle?.text = evento.titulo
        //Formata preço
        cell.lblPreco?.text = evento.valor.priceFormat()
        cell.loadImageFromUrl(url: evento.urlImagem, view: cell.imgEvento)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.eventoSelecionado = self.eventos[indexPath.row]
        self.performSegue(withIdentifier: "ShowDetalhe", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetalhe" {
            let vcDetalhe = segue.destination as! DetalheEventoViewController
            vcDetalhe.eventoSelecionado = self.eventoSelecionado
        }
    }

}
