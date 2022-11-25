//
//  SaveManager.swift
//  XunathNewProject
//
//  Created by Gabriel do Prado Moreira on 22/11/22.
//

import Foundation

class SaveManager {
    static var shared = SaveManager()
    
    private init() { }
    
    let defaults = UserDefaults.standard
    
    func saveGame(_ newData: MainCharacter) {
        do {
            var saveModel = SaveModel(
                level: newData.level,
                currentExp: newData.currentExperience,
                position: newData.position
            )
          
            let jsonEncoder = JSONEncoder()
            
            let jsonData = try jsonEncoder.encode(saveModel)
            
            print(saveModel)
            
            defaults.set(jsonData, forKey: "mainCharSave")
            
        } catch {
            fatalError("Saving Error")
        }
    }
    
    func loadSavedData() {
        if let loadedData = defaults.data(forKey: "mainCharSave") {
            do {
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(SaveModel.self, from: loadedData)
                
            } catch {
                fatalError()
            }
        }
    }
    
    func clearGameData() {
        defaults.removeObject(forKey: "mainCharSave")
    }
    
    func checkIfSaveExists() -> Bool {
        if let loadedData = defaults.data(forKey: "mainCharSave") {
            if loadedData.isEmpty == false {
                return true
            }
        }
        return false
    }
}

struct SaveModel: Codable {
    var level: Int
    var currentExp: Int
    var position: CGPoint
}
