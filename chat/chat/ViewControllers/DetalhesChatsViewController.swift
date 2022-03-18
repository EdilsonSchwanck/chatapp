//
//  DetalhesChatsViewController.swift
//  chat
//
//  Created by Edilson Schwanck Borges on 17/03/22.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetalhesChatsViewController: UIViewController {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhes: UILabel!
    @IBOutlet weak var contador: UILabel!
    
    var chatt = Chats()
    var tempo = 11
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detalhes.text = "Carregando..."

        let url = URL(string: chatt.urlImagem)
        imagem.sd_setImage(with: url) { imagem, erro, cache, url in
            
            if erro == nil {
                
                self.detalhes.text = self.chatt.descricao
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    
                    //decrementar o timer
                    self.tempo = self.tempo - 1
                    
                    // Exibir timer na tela
                    self.contador.text = String(self.tempo)
                    
                    //caso o timer executado ate o zero, invalida
                    
                    if self.tempo == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                
            }
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        let autenticacao = Auth.auth()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            
            //removendo nos do database
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("chats")
            
            snaps.child(chatt.indetificador).removeValue()
            
            
            //Removendo imagem do Chat
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
           
            
            imagens.child("\(chatt.idImagem).jpg").delete { erro in
                
                if erro == nil{
                    print("Sucesso ao excluir a imagem")
                }else{
                    print("Erro ao excluir a imagem")
                }
            }
            
        }
        
        
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
