//
//  KisiGuncelleVC.swift
//  REST API Kisiler
//
//  Created by Ömer Faruk Küçükahıskalı on 29.01.2023.
//

import UIKit
import Alamofire

class KisiGuncelleVC: UIViewController {

    var kisi:Kisiler?
    
    @IBOutlet weak var isimTextField: UITextField!
    
    @IBOutlet weak var telTextField: UITextField!
    
    @IBOutlet weak var epTextField: UITextField!
    
    @IBOutlet weak var dtTextField: UITextField!
    
    var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        telTextField.delegate = self
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .wheels
        
        dtTextField.inputView = datePicker
        
        datePicker?.addTarget(self, action: #selector(self.showDate(datePicker:)), for: .valueChanged)
        
        let dokunmaAlgilama = UITapGestureRecognizer(target: self, action: #selector(self.dokunAlgilaMetod))
        view.addGestureRecognizer(dokunmaAlgilama)
        
        if let k = kisi {
            isimTextField.text = k.kisi_ad
            telTextField.text = k.kisi_tel
            epTextField.text = k.kisi_ep
            dtTextField.text = k.kisi_dt
        }
    }
    
    @objc func showDate(datePicker:UIDatePicker){ // çalışacak fonksiyon
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // tarih formatını ayarlama (internette formatlar var)
        let alinanTarih = dateFormatter.string(from: datePicker.date) // date'i stringe çevirdik
        
        dtTextField.text = alinanTarih // textfielda yazdır
    }
    
    @objc func dokunAlgilaMetod(){
        view.endEditing(true)
    }
    
    func numberFormatter(mask:String,tel:String)->String{
        let number = tel.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result:String = ""
        var indeks = number.startIndex
        
        for character in mask where indeks < number.endIndex{
            if character == "X"{
                result.append(number[indeks])
                indeks = number.index(after: indeks)
            }else{
                result.append(character)
            }
        }
        return result
    }
    
    func kisiGuncelle(kisi_id:String,kisi_ad:String,kisi_tel:String,kisi_ep:String,kisi_dt:String){
        let params:Parameters = ["kisi_id":kisi_id,"kisi_ad":kisi_ad,"kisi_tel":kisi_tel,"kisi_ep":kisi_ep,"kisi_dt":kisi_dt] // Web Service e gidecek veriler
        
        AF.request("http://omerahiskali.com.tr/WebServiceDeneme/update_kisiler.php", method: .post, parameters: params).response { response in
            
            if let data = response.data{
                do{
                    let cevap = try JSONSerialization.jsonObject(with: data)
                    print(cevap)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func guncelleAciton(_ sender: Any) {
        if isimTextField.text == "" || telTextField.text == ""{
            let alertController = UIAlertController(title: "Hata", message: "İsim veya Telefon Numarası Boş Bırakılamaz", preferredStyle: .alert)
            let alertTamam = UIAlertAction(title: "Tamam", style: .cancel)
            alertController.addAction(alertTamam)
            self.present(alertController,animated: true)
        }else{
            if telTextField.text?.count != 18{
                let alertController = UIAlertController(title: "Hata", message: "Telefon Numarası Eksik", preferredStyle: .alert)
                let alertTamam = UIAlertAction(title: "Tamam", style: .cancel)
                alertController.addAction(alertTamam)
                self.present(alertController,animated: true)
            }else{
                if let k = kisi,let ad = isimTextField.text,let tel = telTextField.text, let ep = epTextField.text, let dt = dtTextField.text{
                    if let kid = Int(k.kisi_id!){
                        kisiGuncelle(kisi_id: String(kid), kisi_ad: ad, kisi_tel: tel, kisi_ep: ep, kisi_dt: dt)
                    }
                
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let KisilerVC = storyboard.instantiateViewController(withIdentifier: "kisiler")
                    self.navigationController?.pushViewController(KisilerVC, animated: false)
                }else{
                    print("Kaydet Kısmı Hata")
                }
            }
            
        }
    }
    
}

extension KisiGuncelleVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = telTextField.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        telTextField.text = numberFormatter(mask: "+XX (XXX) XXX-XXXX", tel: newString)
        return false
    }
}
