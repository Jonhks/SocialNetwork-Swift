//
//  MyCellTableViewCell.swift
//  firebasePost
//
//  Created by Jonh Parra on 10/12/19.
//  Copyright © 2019 Jonh Parra. All rights reserved.
//

import UIKit

class MyCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var texto: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
