//
//  ChatsViewController.swift
//  chat
//
//  Created by Edilson Schwanck Borges on 11/03/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var chates:[Chats] = []
    
    @IBAction func sair(_ sender: Any) {
        
        
        let autenticacao = Auth.auth()
        
        do{
             try autenticacao.signOut()
            dismiss(animated: true, completion: nil)
         } catch{
             print("Erro ao deslogar")
         }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalChats = chates.count
        if totalChats == 0{
            return 1
        }
        
        return totalChats
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let totalChats = chates.count
        
        if totalChats == 0{
            celula.textLabel?.text = "Nunhum chat para você :D"
        }else{
            
            let snap = self.chates[ indexPath.row ]
            celula.textLabel?.text = snap.nome
            
            
        }
        
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let totalChats = chates.count
        
        if totalChats > 0 {
            let snap = self.chates[ indexPath.row ]
            self.performSegue(withIdentifier: "detalhesChatSegue", sender: snap)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesChatSegue"{
            
            let detalhesSnapViewController = segue.destination as! DetalhesChatsViewController
            
            detalhesSnapViewController.chatt = sender as! Chats
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let autenticacao = Auth.auth()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            
            print(idUsuarioLogado)
            
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            
            let chats = usuarios.child(idUsuarioLogado).child("chats")
            
            
            
            
            
            chats.observe(DataEventType.childAdded) { chateshopt in
                let dados = chateshopt.value as? NSDictionary
                
                let chats = Chats()
                chats.indetificador = chateshopt.key
                chats.nome = dados?["nome"] as! String
                chats.descricao = dados?["descricao"] as! String
                chats.urlImagem = dados?["urlImagem"] as! String
                chats.idImagem = dados?["idImagem"] as! String
                
                
                self.chates.append(chats)
                //print(self.chates)
     
                self.tableView.reloadData()
            }
            chats.observe(DataEventType.childRemoved) { chateshot in
                
              
                
                var indice = 0
                for chat in self.chates{
                    
                    if chat.indetificador == chateshot.key{
                        self.chates.remove(at: indice)
                       
                    }
                    indice = indice + 1
                }
                self.tableView.reloadData()
                
            }
            
            /*
          
                chats.observe(DataEventType.childAdded) { chatsshot in
                    
                    
                    let dados = chatsshot.value as? NSDictionary
                    
                    let chats = Chats()
                    chats.indetificador = chatsshot.key
                    chats.nome = dados?["nome"] as! String
                    chats.descricao = dados?["descricao"] as! String
                    chats.urlImagem = dados?["urlImagem"] as! String
                    chats.idImagem = dados?["idImagem"] as! String
                    
                    self.chates.append(chats)
         
                    self.tableView.reloadData()
                
                }
               */
               
            
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
