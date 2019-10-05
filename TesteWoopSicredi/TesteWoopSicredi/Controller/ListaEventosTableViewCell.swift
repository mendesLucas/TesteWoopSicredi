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
    @IBOutlet weak var lblPrecoLiquido: UILabel!
    @IBOutlet weak var imgEvento: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - PrepareCell
    func prepareCell(with evento: Evento){
        
        let eventoCellVM = EventoCellViewModel(evento: evento)
        self.lblTitle?.text = eventoCellVM.title

        self.lblPreco?.text = eventoCellVM.preco
        self.lblPrecoLiquido.text = eventoCellVM.precoLiquido
        
        self.imgEvento.imageFromServerURL(evento.image, placeHolder: nil)
        
        if evento.cupons.count > 0 {
            if evento.cupons[0].discount > 0.0{
                self.lblPreco.attributedText = NSAttributedString(string: eventoCellVM.preco, attributes:
                    [NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue])
            }
        }
    }

    //limpa o cash de imagens da construção da TableView.
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgEvento.image = nil
    }

}
