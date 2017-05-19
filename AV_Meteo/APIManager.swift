//
//  APIManager.swift
//  AV_Meteo
//
//  Created by 2Gather Arnaud Verrier on 17/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class APIManager {
    static let main = APIManager()
    
    // Les paramètres limit et page me permettent de controller le nombre de résultats
    let apiUrl = "http://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=b663a8cd840af379b16f9f87600afe1d"
    
    func search(completionHandler: @escaping (_ ret: Bool, _ error: Error?) -> Void) {
        
        let url = URL(string: apiUrl)
        let urlRequest = URLRequest(url: url!)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            data, urlRet, error in
            if let data = data, let list = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any], let jsons = list["list"] as? [[String: Any]] {
                
                let realm = try! Realm()
                for json in jsons {
                    try! realm.write {
                        let meteo = Meteo(JSON: json)
                        realm.add(meteo!, update: true)
                    }
                }
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
            
        }).resume()
    }
}
