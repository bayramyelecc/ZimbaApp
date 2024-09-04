//
//  ItemModel.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 5.09.2024.
//

import Foundation

struct ItemModel: Identifiable {
    var id: String
    var title: String
    var imageUrl: String
    var userId: String
    var fullName: String
    var timeStamp: Date
}
