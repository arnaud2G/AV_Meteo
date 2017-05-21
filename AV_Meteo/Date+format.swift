//
//  Date+format.swift
//  AV_Meteo
//
//  Created by 2Gather Arnaud Verrier on 19/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation

extension Date {
    
    // Retourne la date de façon intéligente
    static func myFormat(dateFrom1970:Double) -> String {
        
        let dayMs:Double = 86400
        let dateToday = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
        
        if dateToday == dateFrom1970 {
            return "\(NSLocalizedString("Aujourd'hui", comment: "Aujourd'hui"))"
        }
        
        if dateToday + dayMs  == dateFrom1970 {
            return "\(NSLocalizedString("Demain", comment: "Demain"))"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return "\(dateFormatter.string(from: Date(timeIntervalSince1970:dateFrom1970 )))"
    }
}
