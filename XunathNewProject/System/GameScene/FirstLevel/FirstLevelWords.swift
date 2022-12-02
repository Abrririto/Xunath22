//
//  FirstLevelWords.swift
//  XunathNewProject
//
//  Created by Arthur Martins Saraiva on 30/11/22.
//

import Cocoa
import SpriteKit

struct FirstLevelWords {
    var AllTexts: [String] = []
    
    init() {
        addText()
    }
    
    mutating func addText() {
        self.AllTexts.append("My technique for the next person who replaces me: In order not to deal with those monsters, just stay here in the bathroom all day.\nBosses never come down here.")
        
        self.AllTexts.append("They do experiments somewhere here, I can hear the screams of our people.")
        
        self.AllTexts.append("Horgnir, the champion, remeber elders in biger place.")
        
        self.AllTexts.append("It's been 10 years... I can hear familiar voices here, Horgnir says that our people who have been here the longest stay in bigger, separate rooms.")
        
        self.AllTexts.append("I like how they put the attractants on the floor for the food to come walking.")
        
        self.AllTexts.append("You NEED to find a way to get out of here and stop all this.")
        
        self.AllTexts.append("Reading is a rule of this world, the world waits until you read.")
        
        self.AllTexts.append("It's been 7 years since our people started disappearing, I never imagined it would happen to me too... Where am I?")
        
    }
}
