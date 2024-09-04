//
//  AuthModel.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 4.09.2024.
//

import Foundation

struct AuthModel : Identifiable ,Codable {
    
    var id: String
    var email: String
    var fullName: String?
    var dateCreated: Date
    var photoUrl: String?
    
}
