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
//git kontrol
//git pull kontrol

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var seaLevelLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    let api = "b93e4d0e8683b3a1a6bb64045463171e"
    
    //Koordinat işlemleri için gerekli değişken tanımlamaları
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    var latitude : Double?
    var longitude : Double?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WEATHER"
        
        getUserLocation()
        getData()
        
    }
    
    //Geçerli anlık konumu alma işlemleri getUserLocation() fonksiyonu içinde gerçekleştiriliyor
    func getUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //Alınan geçerli konum değişkene atanıyor
        currentLatitude = locationManager.location?.coordinate.latitude ?? currentLatitude
        currentLongitude = locationManager.location?.coordinate.longitude ?? currentLongitude
        
        locationManager.stopUpdatingLocation()
    }
    
    //Konum için gerekli olan CoreLocation sınıfının LocationManager fonksiyonu delegate ediliyor
    //Geçerli anlık konum alınıyor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = location.latitude
        longitude = location.longitude
    }
    
    
    func getData() {
        //1. Web adresine istek gönderiliyor
        //url'de koordinatlar, geçerli koordinatların atandığı değişkenler olarak belirleniyor
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(currentLatitude)&lon=\(currentLongitude)&appid=\(api)")
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
                        
                        // Alınan veri işleniyor
                        // DispatchQueue, alınan verilerin UI tarafında görüntülenebilmesi için kullanılır.
                        DispatchQueue.main.async {
                            if let main = jsonResponse!["main"] as? [String:Any] {
                                if let temp = main["temp"] as? Double {
                                    let tempString = (String(Int(temp-272.15)))
                                    self.currentTempLabel.text = "\(tempString)°"
                                }
                                if let feels = main["feels_like"] as? Double {
                                    let feelsString = String(Int(feels-272.15))
                                    self.feelsLikeLabel.text = "\(feelsString)°"
                                }
                                if let tempMin = main["temp_min"] as? Double {
                                   let tempMinString = String(Int(tempMin-272.15))
                                    self.minTempLabel.text = "\(tempMinString)°"
                                }
                                if let tempMax = main["temp_max"] as? Double {
                                    let tempMaxString = String(Int(tempMax-272.15))
                                    self.maxTempLabel.text = "\(tempMaxString)°"
                                }
                                if let humidity = main["humidity"] as? Double {
                                    self.humidityLabel.text = String(Int(humidity))
                                }
                                if let seaLevel = main["sea_level"] as? Double {
                                    self.seaLevelLabel.text = String(Int(seaLevel))
                                }
                            }
                            if let wind = jsonResponse!["wind"] as? [String:Any] {
                                if let speed = wind["speed"] as? Double {
                                    self.windSpeedLabel.text = String(Int(speed))
                                }
                            }
                            if let weatherArray = jsonResponse!["weather"] as? [[String:Any]] {
                                if let weather = weatherArray[0] as? [String:Any] {
                                    if let description = weather["description"] as? String {
                                        self.descriptionLabel.text = description
                                    }
                                }
                            }
                            if let name = jsonResponse!["name"] as? String {
                                self.locationLabel.text = name
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

