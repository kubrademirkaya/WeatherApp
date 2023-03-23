//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kübra Demirkaya on 23.03.2023.
//
/* API Request için;
    1. Web adresine istek göndermek
    2. Veriyi almak
    3. Veriyi işlemek
*/


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    let api = "b93e4d0e8683b3a1a6bb64045463171e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WEATHER"
    }

    @IBAction func getDataButtonClicked(_ sender: Any) {
        //1. Web adresine istek gönderiliyor
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=40.773172&lon=30.3626394&appid=\(api)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                print("error")
            } else {
                //Veri alındı
                if data != nil {
                    do {
                        // JSON içerisinde alınan veriyi işlebilmek için JSON Result objesi oluşturulmalı. Bunun için JsonSerialization sınıfı kullanılacak.
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                        // String:Any -> Gelecek veri int vb. değerler olarak kullanılabilir. Bu şekilde kullanabilmek için Any olarak döndürülüyor.
                        // mutableContainer -> Gelecek veriler array yada dictionary olarak döndürülüyor.
                        
                        DispatchQueue.main.async {
                            if let main = jsonResponse!["main"] as? [String:Any] {
                                if let temp = main["temp"] as? Double {
                                    self.currentTempLabel.text = String(Int(temp-272.15))
                                }
                                if let feels = main["feels"] as? Double {
                                    self.feelsLikeLabel.text = String(Int(feels-272.15))
                                }
                            }
                            if let wind = jsonResponse!["wind"] as? [String:Any] {
                                if let speed = wind["speed"] as? Double {
                                    self.windSpeedLabel.text = String(Int(speed))
                                }
                            }
                        }
                        
                    } catch {
                        
                    }
                    
                }
            }
        }
        //Session işleminin gerçekleşip, çalıştırılması için;
        task.resume()
    }
    
    
}

