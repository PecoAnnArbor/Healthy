//
//  ToJson.swift
//  Healthy1
//
//  Created by Ian Zhang on 9/28/24.
//


struct Medicine: Codable {
    var name: String
    var type: String
    var quantity: Int
    var date: String
    var otherWords: [String]
}

//var title: String
//var type = ["capsules", "pills", "liquids", "ointments", "drops", "equipment", "other"] // other as text box - create their own field [DROPDOWN]
//var quantity: Int

