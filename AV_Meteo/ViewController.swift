//
//  ViewController.swift
//  AV_Meteo
//
//  Created by 2Gather Arnaud Verrier on 17/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let realm = try! Realm()
        let meteos = realm.objects(Meteo.self)
        
        print(meteos.last!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

