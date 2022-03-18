//
//  FotoViewController.swift
//  chat
//
//  Created by Edilson Schwanck Borges on 11/03/22.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    @IBOutlet weak var botaoProximo: UIButton!
    
    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString
    
    
    @IBAction func proximoPasso(_ sender: Any) {
        self.botaoProximo.isEnabled = false
        self.botaoProximo.setTitle("Carregado...", for: .normal)
        
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
       // let imagenFile = imagens.child("\(idImagem).jpg")
        
        // recuperando imagem
        if let imagemSelecionada = imagem.image{
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.5){
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil) { metaDados, erro in
                    
                    if erro == nil{
                        print("Deu certo subio")
                        
                        let nomeImage = metaDados?.dictionaryRepresentation()["name"] as! String
                        let starsRef = armazenamento.child(nomeImage)
                        
                        starsRef.downloadURL { url, error in
                            if let error = error {
                                print(error)
                            }else{
                                if let urlString = url{
                                    self.performSegue(withIdentifier: "selecionarUsuarioSegue" , sender: urlString.absoluteString)
                                }
                            }
                        }
                      
                        //let url: Void = imagenFile.downloadURL { url, erro in
                          //  print(url?.absoluteString as Any)
                        //}
                        //self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: url)
                        
                        //self.botaoProximo.isEnabled = true
                        //self.botaoProximo.setTitle("Próximo", for: .normal)
                    }else{
                    
                        let alerta = Alerta(titulo: "Upload falhou", mensagem: "Erro ao salvar o arquivo, tente novamente!")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                    
                }
            }
            
            
        }
        
    }// fim do proximo passo
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUsuarioSegue"{
            
            let usuarioViewController = segue.destination as!  UsuariosTableViewController
            
            usuarioViewController.descricao = self.descricao.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImagem = self.idImagem
        }
    }
    
    
    @IBAction func selecionarFoto(_ sender: Any) {
        
        // ultiliza a camera do dispositivo
        //imagePicker.sourceType= .camera
        
        
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        // recuperando a foto
        let imagemRecuperada = info[ UIImagePickerController.InfoKey.originalImage ] as? UIImage
        
        imagem.image = imagemRecuperada
        
        //Habilitar o botao
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(red: 0.345, green: 0.741, blue: 0.278, alpha: 1)
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        // desabilitar o botão proximo
        botaoProximo.isEnabled = false
        botaoProximo.backgroundColor = UIColor.gray
       
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
