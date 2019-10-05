//
//  DetalheEventoViewController.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit
import MapKit

class DetalheEventoViewController: UIViewController, CLLocationManagerDelegate {
    
    var detalheEventoVM = DetalheEventoViewModel()

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPreco: UILabel!
    @IBOutlet weak var imgEvento: UIImageView!
    @IBOutlet weak var txtViewDescricao: UITextView!
    @IBOutlet weak var viewMap: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cria botão para realizar o compartilhamento.
        let btnShare = UIBarButtonItem(image: #imageLiteral(resourceName: "shareIcon"), style: .plain, target: self, action: #selector(compartilharTapped))
        //add botão na navigationBar
        navigationItem.rightBarButtonItems = [btnShare]
        self.setupViewModel()
    }
    
    // MARK: - carregaTela
    private func setupViewModel() {
        
        //Carrega tela com a lista de eventos
        self.detalheEventoVM.carregaTela()
        self.detalheEventoVM.reloadView = {
            
            self.lblTitle.text = self.detalheEventoVM.title
            self.imgEvento.imageFromServerURL((self.detalheEventoVM.eventoSelecionado?.image)!, placeHolder: nil)
            self.lblPreco.text = self.detalheEventoVM.preço
            self.txtViewDescricao.text = self.detalheEventoVM.descricao
            self.viewMap.addAnnotation(self.detalheEventoVM.anotacao)
            
            self.centralizarLocal()
            self.carregaMap()
        }
    }
    
    //Metodo de compartilhar evento
    @objc func compartilharTapped() {
        
        if (self.imgEvento.image!.size.equalTo(CGSize.zero)) {
            let alert = UIAlertController(title: "Compartilhar Evento", message: "Imagem não carregada", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            displayShareSheet(self.imgEvento.image!);
        }
    }
    
    func displayShareSheet(_ shareContent: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as UIImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    //Inicializa mapa
    func carregaMap(){
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            gerenciadorLocalizacao.startUpdatingLocation()
        }
    }
    
    
    //Configura posição desejada no mapa
    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: self.detalheEventoVM.anotacao.coordinate.latitude,longitude: self.detalheEventoVM.anotacao.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.2,0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        viewMap.setRegion(region, animated: true)
    }
    
    //configura o zoom para posicionar a localização no mapa
    func centralizarLocal(){
        let coordenadas = CLLocationCoordinate2D(latitude: self.detalheEventoVM.anotacao.coordinate.latitude, longitude: self.detalheEventoVM.anotacao.coordinate.longitude)
        let regiao = MKCoordinateRegionMakeWithDistance( coordenadas, 200, 200)
        viewMap.setRegion(regiao, animated: true)
    }
    
    @IBAction func touchCheckInEvento(_ sender: Any) {
        realizarCheckIn()
    }
    
    //Metodo para realizar o Check in
    func realizarCheckIn() {
        
        do {
            if self.detalheEventoVM.eventoSelecionado!.people.count > 0 {
                //chama o metodo de post check in
                let retorno : String = WebServiceHelper.enviaPost("", pessoa: (self.detalheEventoVM.eventoSelecionado?.people[0])!)

                //caso retorno 200, operação realizada com sucesso.
                if(retorno == "200"){
                    let alert = UIAlertController(title: "Check-in", message: "Check-in realizado com sucesso!",preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Check-in", message: "Ocorreu um erro ao tentar realizar o Check-in, tente novamente mais tarde.",         preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
