//
//  ListaEventosTableViewController.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

class ListaEventosTableViewController: UITableViewController {

    private var listaEventosVM = ListaEventosViewModel()
    var eventoSelecionado : Evento?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupViewModel()
    }
    
    // MARK: - carregaTela
    private func setupViewModel() {
        
        //Carrega tela com a lista de eventos
        self.listaEventosVM.carregaTela()
        self.listaEventosVM.reloadView = {
            self.tableView.reloadData()
        } 
    }
    
    // MARK: - Table view data source / delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listaEventosVM.eventos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellEvento", for: indexPath) as! ListaEventosTableViewCell
        
        let evento : Evento = self.listaEventosVM.eventos[indexPath.row]
        cell.prepareCell(with: evento)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.eventoSelecionado = self.listaEventosVM.eventos[indexPath.row]
        self.performSegue(withIdentifier: "ShowDetalhe", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetalhe" {
            
            if let destination = segue.destination as? DetalheEventoViewController {
                destination.detalheEventoVM.eventoSelecionado = self.eventoSelecionado
                
            }
//            let vcDetalhe = segue.destination as! DetalheEventoViewController
//            vcDetalhe = self.eventoSelecionado
        }
    }

}
