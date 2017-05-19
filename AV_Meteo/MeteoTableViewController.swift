//
//  MeteoTableViewController.swift
//  AV_Meteo
//
//  Created by 2Gather Arnaud Verrier on 18/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MeteoTableViewController: UITableViewController {
    
    private let treeH:Int = 10800
    
    var notificationToken:NotificationToken?
    
    var rawMeteo = [Double:[MeteoViewModel]]()
    var sectionMeteo = [Double]()
    
    deinit {
        notificationToken?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On récupère la météo pour les dates > à la date d'aujourd'hui
        let predicate = NSPredicate(format: "dt > %d", (Int(NSDate().timeIntervalSince1970) - treeH))
        let realm = try! Realm()
        let results = realm.objects(Meteo.self)
            .filter(predicate)
        
        initByDay(meteos: results.map{MeteoViewModel(meteo:$0)})
        
        // Block de notification pour les updates sur la BDD
        notificationToken = results.addNotificationBlock({
            [weak self] changes in
            switch changes {
            case .initial:
                // Initialisation
                self?.initByDay(meteos: results.map{MeteoViewModel(meteo:$0)})
                break
            case .update(_,_,_,_):
                // Modifications
                // Ici avec un peu plus de temps se serait plus jolie d'updater seulement les sections misent à jours
                self?.initByDay(meteos: results.map{MeteoViewModel(meteo:$0)})
                self?.tableView.reloadData()
                break
            case .error(_):
                // TODO: Gestion de l'erreur
                break
            }
        })
        
        // Permet de rafraichir manuellement
        self.refreshControl?.addTarget(self, action: #selector(MeteoTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    // Mise à jours de la BDD
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        refreshControl.beginRefreshing()
        
        APIManager.main.search() {
            ret, error in
            DispatchQueue.main.async(execute: {() -> Void in
                self.refreshControl!.endRefreshing()
            })
        }
    }
    
    // Mark: - preparation des résultats
    // Initialisation de la table
    func initByDay(meteos:[MeteoViewModel]) {
        
        // On récupère les jours
        let days = Array(Set(meteos // Supprime les doublons
            .map{$0.dayDouble}))
        
        // On trie par jour
        for day in days {
            rawMeteo[day] = meteos.filter{$0.dayDouble == day}
        }
        sectionMeteo = Array(rawMeteo.keys).sorted{$0 < $1}
    }
    
    
    // Gestion de la table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionMeteo.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Date.myFormat(dateFrom1970: sectionMeteo[section])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rawMeteo[sectionMeteo[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeteoCell") as! MeteoCell
        
        cell.setupCell(withMeteo: rawMeteo[sectionMeteo[indexPath.section]]![indexPath.row])
        return cell
    }
}

// MARK: - MeteoCell
class MeteoCell:UITableViewCell {
    
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    
    @IBOutlet weak var lblTemp1: UILabel!
    @IBOutlet weak var lblTemp2: UILabel!
    
    func setupCell(withMeteo meteo:MeteoViewModel) {
        
        lblHour.text = meteo.hourText
        
        lblTemp1.text = meteo.tempMinText
        lblTemp2.text = meteo.tempMaxText
        
        self.imgWeather.image = nil
        URLSession.shared.dataTask(with: meteo.iconUrl) {
            (data, response, error) in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.imgWeather.image = UIImage(data: data)
            })
        }.resume()
    }
}
