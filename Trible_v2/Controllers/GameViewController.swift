//
//  GameViewController.swift
//  TribeLeap
//
//  Created by Natasha Radika on 25/04/24.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameViewProtocol: AnyObject {
    func didTapPlayButton()
    func didTransitionToMainMenu()
}


class GameViewController: UIViewController, GameViewProtocol {
    
    @IBOutlet weak var buttonSeeYourPosition: UIButton!
    
    weak var delegate: GameViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MainMenu(size: CGSize(width: 2048, height: 1536))
        scene.scaleMode = .aspectFill
        scene.gameDelegate = self
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
        
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func didTapPlayButton() {
        buttonSeeYourPosition.isHidden = true
    }
    
    func didTransitionToMainMenu() {
        buttonSeeYourPosition.isHidden = false
    }
}
