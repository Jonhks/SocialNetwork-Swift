//
//  InicioViewController.swift
//  firebasePost
//
//  Created by Jonh Parra on 09/12/19.
//  Copyright © 2019 Jonh Parra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class InicioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userList = [Users]()
    var postsLists = [Posts]()
    
    var ref: DatabaseReference!
    
    @IBOutlet var vistaAgregar: UIView!
    @IBOutlet weak var textPost: UITextView!
    @IBOutlet weak var tabla: UITableView!
    
    
    let customView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.delegate = self
        tabla.dataSource = self
        
        ref = Database.database().reference()

        
        vistaAgregar.layer.cornerRadius =  10
        selectUser()
        selectPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsLists.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = postsLists[indexPath.row]
        cell.textLabel?.text = post.texto
        return cell
      }
      
    
    @IBAction func guardarPost(_ sender: UIBarButtonItem) {
        guard let idPost = ref.childByAutoId().key else { return }
        guard let idUser = Auth.auth().currentUser?.uid else { return }
        guard let user = userList[0].user else { return }
        guard let imagenPerfil = userList[0].fotoPerfil else { return }
        guard let texto = textPost.text else { return }
        let campos = [
            "texto": texto,
            "user": user,
            "isPost": idPost,
            "isUser": idUser,
            "imagenPerfil": imagenPerfil
        ]
        
        ref.child("posts").child(idPost).setValue(campos)
        textPost.text = ""
        customView.removeFromSuperview()
        vistaAgregar.removeFromSuperview()
    }
    
    func selectUser () {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let userName = value?["user"] as? String ?? ""
            let imagenPerfil = value?["imagenPerfil"] as? String ?? ""
            let user = Users(user: userName, fotoPerfil: imagenPerfil)
            self.userList.append(user)
        }
        
    }
    
    func selectPosts () {
        ref.child("posts").observe(DataEventType.value) { (snapshot) in
            self.postsLists.removeAll()
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                let valores = item.value as? [String: AnyObject]
                let userName = valores?["user"] as? String ?? ""
                let imagenPerfil = valores?["imagenPerfil"] as? String ?? ""
                let texto = valores?["texto"] as? String ?? ""
                let idUser = valores?["idUser"] as? String ?? ""
                let idPost = valores?["idPost"] as? String ?? ""
                
                let post = Posts(user: userName, fotoPerfil: imagenPerfil, texto: texto, idUser: idUser, idPost: idPost)
                self.postsLists.append(post)
            }
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
        }
        
    }

    
    
    @IBAction func agregarPost(_ sender: UIBarButtonItem) {
        let width = self.view.frame.width
        let height = self.view.frame.height
        customView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        customView.backgroundColor =  UIColor.gray.withAlphaComponent(0.5)
        customView.center = self.view.center
        self.view.addSubview(customView)
        
        vistaAgregar.center = self.view.center
        self.view.addSubview(vistaAgregar)
    }
    
    
    
    @IBAction func cancelarPost(_ sender: UIBarButtonItem) {
        customView.removeFromSuperview()
        vistaAgregar.removeFromSuperview()
    }
    
    
    
    @IBAction func salir(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Salir", message: "¿Deseas cerrar sesión?", preferredStyle: .alert)
        let aceptar = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            try! Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert.addAction(cancelar)
        alert.addAction(aceptar)
        present(alert, animated: true, completion: nil)
    }
    


}
