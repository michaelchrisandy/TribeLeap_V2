//
//  MainMenuExt.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import SpriteKit

// configuration
extension MainMenu {
    func setupBG() {
       let bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.anchorPoint = .zero
        bgNode.position = .zero
        addChild(bgNode)
    }
    
    func setupGrounds() {
        for i in 0...2 {
            let groundNode = SKSpriteNode(imageNamed: "ground")
            groundNode.name = "ground"
            groundNode.anchorPoint = .zero
            groundNode.zPosition = 1.0
            groundNode.position =  CGPoint(x: CGFloat(i) * groundNode.frame.width, y: 0.0)
            addChild(groundNode)
        }
    }
    
    func moveGrounds() {
        enumerateChildNodes(withName: "ground") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            
            if node.position.x < -self.frame.width {
                node.position.x += node.frame.width * 2.0
            }
            
        }
    }
    
    func setupNodes() {
        // tambahkan graphic setting awalnya
        let play = SKSpriteNode(imageNamed: "play")
        play.name = "play"
        play.setScale(0.7)
        play.zPosition = 10.0
        play.position = CGPoint(x: size.width/2.0, y: size.height/2.0 + play.size.height/2.0 + 50.0)
        addChild(play)
        
        let highscore = SKSpriteNode(imageNamed: "highscore")
        highscore.name = "highscore"
        highscore.setScale(0.7)
        highscore.zPosition = 10.0
        highscore.position = CGPoint(x: size.width/2.0, y: play.position.y - play.size.height - 50.0)
        addChild(highscore)
        
    }
    
    func setupPanel() {
        setupContainer()
        
        // panel
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.setScale(0.8)
        panel.zPosition = 20.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        // highscore
        let screenWidth = UIScreen.main.bounds.width
        let x = (screenWidth - panel.frame.width) / 2.0
        let highscoreLbl = SKLabelNode(fontNamed: "Krungthep")
        
        
        highscoreLbl.text = "Highscore: \(String(format: "%.0f", CaloriesGenerator.sharedInstance.getHighscore()))"
        highscoreLbl.horizontalAlignmentMode = .left
        highscoreLbl.fontSize = 42.0
        highscoreLbl.zPosition = 25.0
        highscoreLbl.position = CGPoint(x: x, y: highscoreLbl.frame.height/2.0)
        panel.addChild(highscoreLbl)
        
        // score
        let scoreLbl = SKLabelNode(fontNamed: "Krungthep")
        scoreLbl.text = "Score: \(String(format: "%.0f", CaloriesGenerator.sharedInstance.getScore()))"
        scoreLbl.horizontalAlignmentMode = .left
        scoreLbl.fontSize = 42.0
        scoreLbl.zPosition = 25.0
        scoreLbl.position = CGPoint(x: x, y: -scoreLbl.frame.height)
        panel.addChild(scoreLbl)
    }
    
    
    func setupContainer() {
        containerNode = SKSpriteNode()
        containerNode.name = "container"
        containerNode.zPosition = 15.0
        containerNode.color = .clear
        containerNode.size = size
        
        containerNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(containerNode)
    }
    
    func setUpHeartRate() {
        // Create the node1 sprite node
        let node1 = SKSpriteNode(imageNamed: "life-on")
        node1.setScale(0.2)
        node1.zPosition = 25.0

        // Create the labelHeartRate node
        let labelHeartRate = SKLabelNode(fontNamed: "Helvetica-Bold")
        labelHeartRate.text = "-- BPM"
        
        // Set the labelHeartRate's properties
        labelHeartRate.fontSize = 40
        labelHeartRate.fontColor = SKColor.black
        labelHeartRate.horizontalAlignmentMode = .left // Align text to the left to place it to the right of node1
        labelHeartRate.verticalAlignmentMode = .center
        
        // Calculate the total width of both nodes
        let totalWidth = node1.frame.width + labelHeartRate.frame.width + 10 // Adding a margin of 10 points between them
        
        // Calculate the starting X position for centering both nodes horizontally
        let startX = (self.frame.width - totalWidth) / 2 - 150
        
        // Position node1 and labelHeartRate at the top center
        let yPos = self.frame.height - node1.frame.height / 2 - 80
        
        node1.position = CGPoint(x: startX + node1.frame.width / 2, y: yPos)
        labelHeartRate.position = CGPoint(x: startX + node1.frame.width + 10, y: yPos)
        
        // Add both nodes to the scene
        addChild(node1)
        addChild(labelHeartRate)
        
        // Schedule the timer to update heart rate
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            Task {
                await self.healthManager.fetchHeartRate()
                
                DispatchQueue.main.async {
                    labelHeartRate.text = String(self.healthManager.heartRate) + " BPM"
                    print(self.healthManager.heartRate)
                }
            }
        })
    }

    
    func setUpCalories(){
        let node1 = SKSpriteNode(imageNamed: "fire")
        node1.setScale(0.08)
        node1.zPosition = 25.0

        // Create the labelHeartRate node
        let labelHeartRate = SKLabelNode(fontNamed: "Helvetica-Bold")
        labelHeartRate.text = "-- KKal"
        
        // Set the labelHeartRate's properties
        labelHeartRate.fontSize = 40
        labelHeartRate.fontColor = SKColor.black
        labelHeartRate.horizontalAlignmentMode = .left // Align text to the left to place it to the right of node1
        labelHeartRate.verticalAlignmentMode = .center
        
        // Calculate the total width of both nodes
        let totalWidth = node1.frame.width + labelHeartRate.frame.width + 10 // Adding a margin of 10 points between them
        
        // Calculate the starting X position for centering both nodes horizontally
        let startX = (self.frame.width - totalWidth) / 2 + 150
        
        // Position node1 and labelHeartRate at the top center
        let yPos = self.frame.height - node1.frame.height / 2 - 80
        
        node1.position = CGPoint(x: startX + node1.frame.width / 2, y: yPos)
        labelHeartRate.position = CGPoint(x: startX + node1.frame.width + 10, y: yPos)
        
        // Add both nodes to the scene
        addChild(node1)
        addChild(labelHeartRate)
        
        // Schedule the timer to update heart rate
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            Task {
                await self.healthManager.fetchActiveEnergyBurned()
                
                DispatchQueue.main.async {
                    labelHeartRate.text = String(format: "%.1f KKal", self.healthManager.activeEnergyBurned)
                    print(self.healthManager.activeEnergyBurned)
                }
            }
        })
    }
    

}
