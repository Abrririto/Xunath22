//
//  SaveManager.swift
//  XunathNewProject
//
//  Created by Gabriel do Prado Moreira on 22/11/22.
//

import Foundation
import SpriteKit

enum Resources {
    static var mainCharacter = MainCharacter()
    static var camera = MainCamera()
}

class SaveManager {
    static var shared = SaveManager()
    
    var activeScene: SKScene?
    
    private init() { }
    
    let defaults = UserDefaults.standard
    var sceneManagerDelegate: SceneChangeable?
    
    func saveGame() {
        do {
            let saveModel = SaveModel(
                level: Resources.mainCharacter.level,
                currentExp: Resources.mainCharacter.currentExperience,
                position: Resources.mainCharacter.position
            )
          
            let jsonEncoder = JSONEncoder()
            
            let jsonData = try jsonEncoder.encode(saveModel)
            
            print(saveModel)
            
            defaults.set(jsonData, forKey: "mainCharSave")
            
        } catch {
            fatalError("Saving Error")
        }
    }
    
    func loadSavedData(completion: @escaping () -> Void) {
        if let loadedData = defaults.data(forKey: "mainCharSave") {
            do {
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(SaveModel.self, from: loadedData)
                
                Resources.mainCharacter.level = data.level
                Resources.mainCharacter.currentExperience = data.currentExp
                Resources.mainCharacter.position = data.position
                sceneManagerDelegate?.changeScene(scene: .FirstLevel)
               
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
                return false
            }
        }
        return true
    }
}

struct SaveModel: Codable {
    var level: Int
    var currentExp: Int
    var position: CGPoint
}
