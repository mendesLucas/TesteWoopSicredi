//
//  ListaEventosTableViewCell.swift
//  TesteWoopSicredi
//
//  Created by lucas  mendes on 03/09/2019.
//  Copyright © 2019 lucas  mendes. All rights reserved.
//

import UIKit

class ListaEventosTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPreco: UILabel!
    @IBOutlet weak var imgEvento: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Busca imagens com URL
    func loadImageFromUrl(url: String, view: UIImageView){
        if view.image == nil {
        
            let url = NSURL(string: url)!
            
            let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                if let data = responseData{
                    
                    DispatchQueue.main.async() {
                        self.imgEvento.image = UIImage(data: data)
                        self.imgEvento.layer.cornerRadius = 30.0
                        self.imgEvento.clipsToBounds = true
                    }
                }
            }
            task.resume()
        }
    }
    
    //limpa o cash de imagens da construção da TableView.
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgEvento.image = nil
    }

}
