//
//  Meteo.swift
//  AV_Meteo
//
//  Created by 2Gather Arnaud Verrier on 17/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


// Mark - Model
class Meteo: Object, Mappable {
    dynamic var dt:Int = 0
    
    // Cloud
    dynamic var all:Double = 0.0
    
    // Main
    dynamic var grnd_level:Double = 0.0
    dynamic var humidity:Double = 0.0
    dynamic var pressure:Double = 0.0
    dynamic var sea_level:Double = 0.0
    dynamic var temp:Double = 0.0
    dynamic var temp_kf:Double = 0.0
    dynamic var temp_max:Double = 0.0
    dynamic var temp_min:Double = 0.0
    
    // pod
    dynamic var pod:String = ""
    
    // weather
    dynamic var descr:String = ""
    dynamic var icon:String = ""
    dynamic var id:Int = 0
    dynamic var main:String = ""
    
    // wind
    dynamic var deg:Double = 0.0
    dynamic var speed:Double = 0.0
    
    // Index
    override static func primaryKey() -> String? {
        return "dt"
    }
    
    // To Json
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        dt <- map["dt"]
        
        // Clouds
        all <- map["clouds.all"]
        
        // Main
        grnd_level <- map["main.grnd_level"]
        humidity <- map["main.humidity"]
        pressure <- map["main.pressure"]
        sea_level <- map["main.sea_level"]
        temp <- map["main.temp"]
        temp_kf <- map["main.temp_kf"]
        temp_max <- map["main.temp_max"]
        temp_min <- map["main.temp_min"]
        
        // sys
        pod <- map["sys.pod"]
        
        // weather
        descr <- map["weather.0.description"]
        icon <- map["weather.0.icon"]
        id <- map["weather.0.id"]
        main <- map["weather.0.main"]
        
        // wind
        deg <- map["wind.deg"]
        speed <- map["wind.speed"]
    }
}

// Mark - ModelView
class MeteoViewModel {
    
    private var iconURL = "http://openweathermap.org/img/w/%@.png"
    private var kelvinCst = 273.15
    
    private var meteo: Meteo!
    
    var dayDouble: Double {
        
        return Calendar.current.startOfDay(for: Date(timeIntervalSince1970: Double(meteo.dt))).timeIntervalSince1970 // On récupère le jour en ms
    }
    
    var dateText: String {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        dateFormater.timeStyle = .none
        
        return dateFormater.string(from: Date.init(timeIntervalSince1970: Double(meteo.dt)))
    }
    
    var hourText: String {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .none
        dateFormater.timeStyle = .short
        
        return dateFormater.string(from: Date.init(timeIntervalSince1970: Double(meteo.dt)))
    }
    
    var tempMinText: String {
        return "\(Int(meteo.temp_min-kelvinCst))°"
    }
    
    var tempMaxText: String {
        return "\(Int(meteo.temp_max-kelvinCst))°"
    }
    
    var iconUrl:URL {
        return URL(string: String(format: iconURL, meteo.icon))!
    }
    
    init(meteo: Meteo) {
        self.meteo = meteo
    }
}

