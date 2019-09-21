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
        //busca eventos da API
        WebServiceHelper.getServiceUrlListaEvento{ (eventos) in
            DispatchQueue.main.async {
                self.eventos = eventos
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source / delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellEvento", for: indexPath) as! ListaEventosTableViewCell
        
        let evento : Evento = self.eventos[indexPath.row]
        
        cell.lblTitle?.text = evento.title
        //Formata preço
        cell.lblPreco?.text = evento.price.priceFormat()
        //caso tenha desconto, aplica no preço
        if evento.cupons.count > 0 {
            if evento.cupons[0].discount > 0.0{
                
                cell.lblPreco.attributedText = NSAttributedString(string: evento.price.priceFormat(), attributes:
                    [NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue])
                
                cell.lblPrecoLiquido.text = aplicaDesconto(preco: evento.price, desconto: evento.cupons[0].discount).priceFormat()
            }
            else{
                cell.lblPrecoLiquido.text = ""
            }
        }
        else{
            cell.lblPrecoLiquido.text = ""
        }
        cell.loadImageFromUrl(url: evento.image, view: cell.imgEvento)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.eventoSelecionado = self.eventos[indexPath.row]
        self.performSegue(withIdentifier: "ShowDetalhe", sender: self)
    }
    
    // MARK: - Aplica Desconto
    func aplicaDesconto(preco: Double, desconto: Double) -> Double {
        
        var valorLiquido: Double = preco
        valorLiquido = valorLiquido - valorLiquido * desconto / 100
        return valorLiquido
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetalhe" {
            let vcDetalhe = segue.destination as! DetalheEventoViewController
            vcDetalhe.eventoSelecionado = self.eventoSelecionado
        }
    }

}
