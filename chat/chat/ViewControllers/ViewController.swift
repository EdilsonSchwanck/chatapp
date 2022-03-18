//
//  ViewController.swift
//  chat
//
//  Created by Edilson Schwanck Borges on 11/03/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacao = Auth.auth()
        
       /* do{
            try autenticacao.signOut()
        } catch{
            print("Erro ao deslogar")
        }*/
        
        autenticacao.addStateDidChangeListener { autenticacao, usuario in
            
            
            if usuario != nil {
                self.performSegue(withIdentifier: "loginAutomaticoSegue", sender: nil)
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

