//
//  RegistroViewController.swift
//  firebasePost
//
//  Created by Jonh Parra on 09/12/19.
//  Copyright © 2019 Jonh Parra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RegistroViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    var perfil: UIImage!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let addImage = UITapGestureRecognizer(target: self, action: #selector(agregarImagen))
        image.addGestureRecognizer(addImage)
        
    }
    
    @IBAction func registrarse(_ sender: UIButton) {
        guard let email = correo.text else { return }
        guard let password = password.text else { return  }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print("Ususario creado")
                self.guardarUsuario()
            } else {
                if let error = error?.localizedDescription{
                 let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                 let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                 alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                } else {
                     let alert = UIAlertController(title: "error", message: "Error en el código", preferredStyle: .alert)
                     let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                     alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func guardarUsuario() {
        // guardar en storage
        let storage = Storage.storage().reference()
        let nombreImagen = UUID()
        let directorio = storage.child("imagenesPerfil/\(nombreImagen)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        directorio.putData(perfil.pngData()!, metadata: metadata){ (data, error) in
            if error == nil {
                print("imagen guardada")
            } else {
                 let alert = UIAlertController(title: "error", message: "Error al guardar la imagen", preferredStyle: .alert)
                 let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                 alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // guardar en database
        
        guard let idUser = Auth.auth().currentUser?.uid else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        guard let user = usuario.text else { return }

        let campos = [
            "user": user,
            "email": email,
            "idUser": idUser,
            "imagenPerfil": String(describing: directorio)
        ]
        ref.child("users").child(idUser).setValue(campos)
        dismiss(animated: true, completion: nil)
        

    }
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func agregarImagen () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let imagenTomada =  info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        perfil = redimensionarImagen(image: imagenTomada!, targetSize: CGSize(width: 100.0, height: 100.0))
        image.image = perfil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func redimensionarImagen (image: UIImage, targetSize: CGSize)  -> UIImage {
        let size = image.size
        let withRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        
        if withRatio > heightRatio{
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * withRatio, height: size.height * withRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
