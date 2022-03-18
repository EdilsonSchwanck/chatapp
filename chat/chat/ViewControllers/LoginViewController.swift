//
//  LoginViewController.swift
//  chat
//
//  Created by Edilson Schwanck Borges on 11/03/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    @IBAction func entrar(_ sender: Any) {
        if let emailR = self.email.text{
            if let senhaR = self.senha.text{
                
                // autenticar
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: emailR, password: senhaR) { usuario, erro in
                    
                    if erro == nil{
                        
                      if usuario == nil{
                          let alerta = Alerta(titulo: "Error ao Autenticar", mensagem: "Problema ao realizar autenticação, tente novamente!")
                          self.present(alerta.getAlerta(), animated: true, completion: nil)
                            
                        }else{
                            
                            //redireciondado usuario para tela principal
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                            
                        }
                        
                    }else{
                        
                        let alerta = Alerta(titulo: "Dados incorretos", mensagem: "Verifique os dados Digitatos e tente novamente!")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                        
                        
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    

  

}
