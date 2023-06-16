//
//  KisiEkleVC.swift
//  REST API Kisiler
//
//  Created by Ömer Faruk Küçükahıskalı on 29.01.2023.
//

import UIKit
import Alamofire

class KisiEkleVC: UIViewController {
    
    @IBOutlet weak var isimTextField: UITextField!
    
    @IBOutlet weak var telefonTextField: UITextField!
    
    @IBOutlet weak var epostaTextField: UITextField!
    
    @IBOutlet weak var dtarihiTextField: UITextField!
    
    var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        telefonTextField.delegate = self
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .wheels
        
        dtarihiTextField.inputView = datePicker
        
        datePicker?.addTarget(self, action: #selector(self.showDate(datePicker:)), for: .valueChanged)
        
        let dokunmaAlgilama = UITapGestureRecognizer(target: self, action: #selector(self.dokunAlgilaMetod))
        view.addGestureRecognizer(dokunmaAlgilama)
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

    
    @objc func showDate(datePicker:UIDatePicker){ // çalışacak fonksiyon
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // tarih formatını ayarlama (internette formatlar var)
        let alinanTarih = dateFormatter.string(from: datePicker.date) // date'i stringe çevirdik
        
        dtarihiTextField.text = alinanTarih // textfielda yazdır
    }
    
    @objc func dokunAlgilaMetod(){
        view.endEditing(true)
    }
    
    func kisiEkle(kisi_ad:String,kisi_tel:String,kisi_ep:String,kisi_dt:String){
        let params:Parameters = ["kisi_ad":kisi_ad,"kisi_tel":kisi_tel,"kisi_ep":kisi_ep,"kisi_dt":kisi_dt] // Web Service e gidecek veriler
        
        AF.request("http://omerahiskali.com.tr/WebServiceDeneme/insert_kisiler.php", method: .post, parameters: params).response { response in
            
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
    
    @IBAction func kaydetAction(_ sender: Any) {
        
        if isimTextField.text == "" || telefonTextField.text == ""{
            let alertController = UIAlertController(title: "Hata", message: "İsim veya Telefon Numarası Boş Bırakılamaz", preferredStyle: .alert)
            let alertTamam = UIAlertAction(title: "Tamam", style: .cancel)
            alertController.addAction(alertTamam)
            self.present(alertController,animated: true)
        }else{
            if telefonTextField.text?.count != 18{
                let alertController = UIAlertController(title: "Hata", message: "Telefon Numarası Eksik", preferredStyle: .alert)
                let alertTamam = UIAlertAction(title: "Tamam", style: .cancel)
                alertController.addAction(alertTamam)
                self.present(alertController,animated: true)
            }else{
                if let ad = isimTextField.text, let tel = telefonTextField.text, let eposta = epostaTextField.text, let dt = dtarihiTextField.text{
                    kisiEkle(kisi_ad: ad, kisi_tel: tel, kisi_ep: eposta, kisi_dt: dt)
                    
                    
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

extension KisiEkleVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = telefonTextField.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        telefonTextField.text = numberFormatter(mask: "+XX (XXX) XXX-XXXX", tel: newString)
        return false
    }
}
