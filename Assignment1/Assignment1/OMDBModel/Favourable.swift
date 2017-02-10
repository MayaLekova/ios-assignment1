//
//  Favourable.swift
//  Assignment1
//
//  Created by Maya Lekova on 2/9/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import Foundation
import RealmSwift

public class Favourable: Object {
// TODO: maybe declare this as convenient
//    public required init() {
//        var config = Realm.Configuration()
//        
//        // Use the default directory, but replace the filename
//        config.fileURL = config.fileURL!.deletingLastPathComponent()
//            .appendingPathComponent("favourites.realm")
//        
//        // Set this as the configuration used for the default Realm
//        Realm.Configuration.defaultConfiguration = config
//    }
    
    public func favour() {
        // TODO: find a way to save only once
        do {
            let realm = try Realm()
            
            do {
                try realm.write {
                    realm.add(self)
                }
            } catch let error as NSError {
                print("Error while saving \(self) to DB: \(error)")
            }
        } catch let error as NSError {
            print("Error while obtaining reference to DB: \(error)")
        }
    }
    public func unfavour() {
        do {
            let realm = try Realm()
            
            do {
                try realm.write {
                    realm.delete(self)
                }
            } catch let error as NSError {
                print("Error while saving \(self) to DB: \(error)")
            }
        } catch let error as NSError {
            print("Error while obtaining reference to DB: \(error)")
        }
        
    }
}
