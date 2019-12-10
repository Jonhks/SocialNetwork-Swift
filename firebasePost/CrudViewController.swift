//
//  CrudViewController.swift
//  firebasePost
//
//  Created by Jonh Parra on 10/12/19.
//  Copyright © 2019 Jonh Parra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CrudViewController: UIViewController {
    
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var texto: UITextView!
    @IBOutlet weak var botonBorrar: UIBarButtonItem!
    @IBOutlet weak var botonEditar: UIBarButtonItem!
    
    var post: Posts!

    override func viewDidLoad() {
        super.viewDidLoad()
        llenarCampos()
        esconderBotones()

    }
    
    @IBAction func editar(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func borrar(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func llenarCampos () {
        user.text = post.user
        texto.text = post.texto
        
//                if let urlFotoPerfil = post.fotoPerfil{
        //            let storageImagen = Storage.storage().reference(forURL: urlFotoPerfil)
        //            storageImagen.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
        //                if let error = error?.localizedDescription{
        //                    print("Fallo la carga de la imagen", error)
        //                } else {
        //                    if let imagen = data{
        //                        self.imagenPerfil.image = UIImage(data: imagen)
        //                        self.imagenPerfil.layer.cornerRadius =  self.imagenPerfil.frame.size.width/2
        //                        self.imagenPerfil.clipsToBounds = true
        //                    }
        //                }
        //            }
        //        }

    }

    func esconderBotones () {
        guard let idUser = Auth.auth().currentUser?.uid else { return }
        let idUserPost = post.idUser
        print(idUserPost)
        if idUser != idUserPost{
            self.botonBorrar.isEnabled = false
            self.botonEditar.isEnabled = false
            self.texto.isEditable = false
            
        } else {
            print("No es mi cuenta")
        }
    }
    
}
