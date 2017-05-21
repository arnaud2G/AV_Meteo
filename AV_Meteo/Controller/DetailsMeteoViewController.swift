//
//  DetailsMeteoViewController.swift
//  AV_Meteo
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

class DetailsMeteoViewController: UIViewController {
    
    var meteo:MeteoViewModel!
    
    @IBOutlet weak var imgMeteo: UIImageView!
    @IBOutlet weak var lblMeteo: UILabel!
    
    @IBOutlet weak var lblTempératureMin: UILabel!
    @IBOutlet weak var lblTempératureMax: UILabel!
    
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(Date.myFormat(dateFrom1970: meteo.dayDouble)) - \(meteo.hourText)"
        
        lblMeteo.text = meteo.meteoText
        
        lblTempératureMin.text = meteo.tempMinDescription
        lblTempératureMax.text = meteo.tempMaxDescription
        
        lblWind.text = meteo.windDescription
        lblHumidity.text = meteo.humidityDescription
        
        URLSession.shared.dataTask(with: meteo.iconUrl) {
            (data, response, error) in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.imgMeteo.image = UIImage(data: data)
            })
            }.resume()
    }
}
