//
//  Kisiler.swift
//  RestApiKisiler
//
//  Created by Ömer Faruk Küçükahıskalı on 29.01.2023.
//

import Foundation

class Kisiler: Codable{
    var kisi_id:String?
    var kisi_ad:String?
    var kisi_tel:String?
    var kisi_ep:String?
    var kisi_dt:String?
    
    init(kisi_id: String? = nil, kisi_ad: String? = nil, kisi_tel: String? = nil, kisi_ep: String? = nil, kisi_dt: String? = nil) {
        self.kisi_id = kisi_id
        self.kisi_ad = kisi_ad
        self.kisi_tel = kisi_tel
        self.kisi_ep = kisi_ep
        self.kisi_dt = kisi_dt
    }
    
    init() {
        
    }
}
