//
//  Usuario.swift
//  chat
//
//  Created by Edilson Schwanck Borges on 14/03/22.
//

import Foundation

class Usuario{
    
    var email: String
    var nome: String
    var uid: String
    
    init(email: String, nome: String, uid: String){
        self.email = email
        self.nome = nome
        self.uid = uid
    }
    
}

