//
//  MainMenu.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import SpriteKit
import SwiftUI
import WatchConnectivity



class MainMenu: SKScene {
    // properties
    var containerNode: SKSpriteNode!
    
    let audioManager = SKTAudio.sharedInstance()
    
    @ObservedObject var healthManager = HealthManager()
    @StateObject var iOSSessionManager = IOSSessionManager()
    
    weak var gameDelegate: GameViewProtocol?
    
    // system
    override func didMove(to view: SKView) {
        setupBG()
        setupGrounds()
        setupNodes()
        setUpHeartRate()
        setUpCalories()
    
        
        
        
//        labelHeartRate.text = String(self.iOSSessionManager.heartRate)
//        labelHeartRate.text = String(iOSSessionManager.message)
        
        audioManager.playBGMusic("backgroundMusic.mp3")
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
//        gameDelegate?.didTransitionToMainMenu()
        moveGrounds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // hanya dijalankan kalo ada touch
        guard let touch = touches.first else {
            return
        }
        // tentukan lokasi touch
        let node = atPoint(touch.location(in: self))
        
        
        if node.name == "play" {
            gameDelegate?.didTapPlayButton()
            let scene = GameScene(size: size)
            scene.scaleMode = scaleMode
            view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
        }
        else if node.name == "highscore" {
            setupPanel()
        }
        else if node.name == "container" {
            containerNode.removeFromParent()
        }
        
    }
    
}
