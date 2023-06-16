//
//  KisiDetayVC.swift
//  REST API Kisiler
//
//  Created by Ömer Faruk Küçükahıskalı on 29.01.2023.
//

import UIKit

class KisiDetayVC: UIViewController {

    var kisi:Kisiler?
    
    @IBOutlet weak var isimLabel: UILabel!
    
    @IBOutlet weak var telLabel: UILabel!
    
    @IBOutlet weak var dtLabel: UILabel!
    
    @IBOutlet weak var epLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let k = kisi{
            goster(ad: k.kisi_ad!, tel: k.kisi_tel!, ep: k.kisi_ep!, dt: k.kisi_dt!)
        }
        
    }
    
    func goster(ad:String,tel:String,ep:String,dt:String){
        isimLabel.text = ad
        telLabel.text = tel
        dtLabel.text = dt
        epLabel.text = ep
    }

}
