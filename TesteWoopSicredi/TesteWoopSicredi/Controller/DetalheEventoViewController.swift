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

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPreco: UILabel!
    @IBOutlet weak var imgEvento: UIImageView!
    @IBOutlet weak var txtViewDescricao: UITextView!
    @IBOutlet weak var viewMap: MKMapView!
    var eventoSelecionado : Evento?
    var gerenciadorLocalizacao = CLLocationManager()
    var anotacao = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cria botão para realizar o compartilhamento.
        let btnShare = UIBarButtonItem(image: #imageLiteral(resourceName: "shareIcon"), style: .plain, target: self, action: #selector(compartilharTapped))
        //add botão na navigationBar
        navigationItem.rightBarButtonItems = [btnShare]
        
        if let idEvento = self.eventoSelecionado?.id {
            
            WebServiceHelper.getServiceUrlEvento(param: idEvento) { (evento) in
                DispatchQueue.main.async {
                    self.eventoSelecionado = evento
                    self.carregaTela()
                    self.centralizarLocal()
                }
            }
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

    
    //Metodo carregar campos da tela
    func carregaTela() {
    
        self.lblTitle.text = self.eventoSelecionado!.title
        self.lblPreco.text = self.eventoSelecionado!.price.priceFormat()

        //caso tenha desconto, aplica no preço
        if self.eventoSelecionado!.cupons.count > 0 {
            if self.eventoSelecionado!.cupons[0].discount > 0.0{
                self.lblPreco.text = aplicaDesconto(preco: self.eventoSelecionado!.price, desconto: self.eventoSelecionado!.cupons[0].discount).priceFormat()
            }
        }

        //busca imagem do evento com a URL
        self.loadImageFromUrl(url: self.eventoSelecionado!.image, view: self.imgEvento)
        self.txtViewDescricao.text = self.eventoSelecionado!.description
        carregaMap()
        
        switch self.eventoSelecionado?.latitude {
        case .double(let value)?:
            anotacao.coordinate.latitude = value
            break
        default: break
            
        }
        
        switch self.eventoSelecionado?.longitude {
        case .double(let value)?:
            anotacao.coordinate.longitude = value
            break
        default: break
            
        }

        self.viewMap.addAnnotation( anotacao )
    }
    
    // MARK: - Aplica Desconto
    func aplicaDesconto(preco: Double, desconto: Double) -> Double {
        
        var valorLiquido: Double = preco
        valorLiquido = valorLiquido - valorLiquido * desconto / 100
        return valorLiquido
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
        
        let coordinations = CLLocationCoordinate2D(latitude: anotacao.coordinate.latitude,longitude: anotacao.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.2,0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        viewMap.setRegion(region, animated: true)
    }
    
    //configura o zoom para posicionar a localização no mapa
    func centralizarLocal(){
        let coordenadas = CLLocationCoordinate2D(latitude: anotacao.coordinate.latitude, longitude: anotacao.coordinate.longitude)
        let regiao = MKCoordinateRegionMakeWithDistance( coordenadas, 200, 200)
        viewMap.setRegion(regiao, animated: true)
    }
    
    //busca imagem do evento com URL
    func loadImageFromUrl(url: String, view: UIImageView){
        if view.image == nil {
            
            let url = NSURL(string: url)!
            
            let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                if let data = responseData{
                    
                    DispatchQueue.main.async() {
                        self.imgEvento.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
    

    @IBAction func touchCheckInEvento(_ sender: Any) {
        realizarCheckIn()
    }
    
    //Metodo para realizar o Check in
    func realizarCheckIn() {
        
        do {
            let urlString = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
            if self.eventoSelecionado!.people.count > 0 {
                //chama o metodo de post check in
                let retorno : String = WebServiceHelper.enviaPost(urlString, pessoa: (self.eventoSelecionado?.people[0])!)
                
                //caso retorno 200, operação realizada com sucesso.
                if(retorno == "200"){
                    let alert = UIAlertController(title: "Check-in", message: "Check-in realizado com sucesso!",         preferredStyle: UIAlertControllerStyle.alert)
                    
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
