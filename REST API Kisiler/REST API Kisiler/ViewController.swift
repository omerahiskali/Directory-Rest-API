//
//  ViewController.swift
//  REST API Kisiler
//
//  Created by Ömer Faruk Küçükahıskalı on 29.01.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    var kisiListe = [Kisiler]()
    
    var aramaYapiliyorMu = false
    var aramaKelimesi:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if aramaYapiliyorMu {
           kisiAra(kisi_ad: aramaKelimesi!)
        }else{
           tumKisileriAl()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let indeks = sender as? Int
        
        if segue.identifier == "toDetay"{
            let gidilecekVC = segue.destination as! KisiDetayVC
            gidilecekVC.kisi = kisiListe[indeks!]
        }
        
        if segue.identifier == "toGuncelle"{
            let gidilecekVC = segue.destination as! KisiGuncelleVC
            gidilecekVC.kisi = kisiListe[indeks!]
        }
        
    }
    
    
    func kisiSil(kisi_id:String){
        let params:Parameters = ["kisi_id":kisi_id] // Web Service e gidecek veriler
        
        AF.request("http://omerahiskali.com.tr/WebServiceDeneme/delete_kisiler.php", method: .post, parameters: params).response { response in
            
            if let data = response.data{
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                        if self.aramaYapiliyorMu {
                            self.kisiAra(kisi_ad: self.aramaKelimesi!)
                        }else{
                            self.tumKisileriAl()
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func tumKisileriAl(){
        AF.request("http://omerahiskali.com.tr/WebServiceDeneme/take_alldb.php", method: .get).response{ response in
            if let data = response.data{
                do{
                    let cevap = try JSONDecoder().decode(KisilerCevap.self, from: data)
                    
                    if let gelenListe = cevap.kisiler2{
                        
                        self.kisiListe = gelenListe
                        
                        for k in gelenListe{
                            print("**************")
                            print("Kisi ID : \(k.kisi_id!)")
                            print("Kisi Ad : \(k.kisi_ad!)")
                            print("Kisi Tel : \(k.kisi_tel!)")
                            print("Kisi Eposta : \(k.kisi_ep!)")
                            print("Kisi DT : \(k.kisi_dt!)")
                        }
                    }else{
                        self.kisiListe = [Kisiler]()
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func kisiAra(kisi_ad:String){
        let params:Parameters = ["kisi_ad":kisi_ad] // Web Service e gidecek veriler
        
        AF.request("http://omerahiskali.com.tr/WebServiceDeneme/search_alldb.php", method: .post, parameters: params).response { response in
            
            if let data = response.data{
                do{
                    let cevap = try JSONDecoder().decode(KisilerCevap.self, from: data)
                    
                    if let gelenKisiListesi = cevap.kisiler2{
                        self.kisiListe = gelenKisiListesi
                    }else{
                        self.kisiListe = [Kisiler]()
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    if let gelenListe = cevap.kisiler2{
                        for k in gelenListe{
                            print("**************")
                            print("Kisi ID : \(k.kisi_id!)")
                            print("Kisi Ad : \(k.kisi_ad!)")
                            print("Kisi Tel : \(k.kisi_tel!)")
                            print("Kisi Eposta : \(k.kisi_ep!)")
                            print("Kisi DT : \(k.kisi_dt!)")
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisiListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gelenKisi = kisiListe[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hucre", for: indexPath) as! TableViewCell
        
        cell.etiket.text = gelenKisi.kisi_ad
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetay", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil") {  (contextualAction, view, boolValue) in
            
            let kisi = self.kisiListe[indexPath.row]
            
            if let kid = Int(kisi.kisi_id!){
                self.kisiSil(kisi_id: String(kid))
            }
        }
        
        let guncelleAction = UIContextualAction(style: .normal, title: "Güncelle") {  (contextualAction, view, boolValue) in
            
            self.performSegue(withIdentifier: "toGuncelle", sender: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction,guncelleAction])
    }
}

extension ViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama sonuç : \(searchText)")
        
        aramaKelimesi = searchText
        
        if searchText == ""{
            aramaYapiliyorMu = false
        }else{
            aramaYapiliyorMu = true
        }
        
        kisiAra(kisi_ad: aramaKelimesi!)
    }
    
}
