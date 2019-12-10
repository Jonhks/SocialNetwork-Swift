//
//  Posts.swift
//  firebasePost
//
//  Created by Jonh Parra on 09/12/19.
//  Copyright © 2019 Jonh Parra. All rights reserved.
//

import Foundation


class Posts {
    var user: String?
    var fotoPerfil: String?
    var texto: String?
    var idUser: String?
    var idPost: String?
    
    init(user: String?, fotoPerfil: String?, texto: String?, idUser: String?, idPost: String?) {
        self.user = user
        self.fotoPerfil = fotoPerfil
        self.texto = texto
        self.idUser = idUser
        self.idPost = idPost
    }
}
