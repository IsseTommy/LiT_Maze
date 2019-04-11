//
//  ViewController.swift
//  Maze
//
//  Created by Tommy on 2019/04/11.
//  Copyright © 2019 Tommy. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var playerView: UIView!
    var playerMotionManager: CMMotionManager!
    var speedX: Double = 0.0
    var speedY: Double = 0.0
    
    let screenSize = UIScreen.main.bounds.size

    let maze = [
        [1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 1, 0],
        [3, 0, 1, 0, 1, 0],
        [1, 1, 1, 0, 0, 0],
        [1, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 0, 0],
        [0, 1, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0],
        [0, 0, 1, 1, 1, 2],
    ]
    
    var startView: UIView!
    var goalView: UIView!
    
    var wallrectArray = [CGRect]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellWidth = screenSize.width / CGFloat(maze[0].count)
        let cellHeight = screenSize.height / CGFloat(maze.count)
        
        let cellOffsetX = screenSize.width / CGFloat(maze[0].count * 2)
        let cellOffsetY = screenSize.height / CGFloat(maze.count * 2)
        
        for y in 0 ..< maze.count {
            for x in 0 ..< maze[y].count {
                switch maze[y][x]{
                case 1:
                    let wallView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    wallView.backgroundColor = UIColor.black
                    view.addSubview(wallView)
                    wallrectArray.append(wallView.frame)
                case 2:
                    startView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    startView.backgroundColor = UIColor.green
                    view.addSubview(startView)
                case 3:
                    goalView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    goalView.backgroundColor = UIColor.red
                    view.addSubview(goalView)
                default:
                    break
                }
            }
        }
        
        playerView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth / 6, height: cellHeight / 6))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.gray
        self.view.addSubview(playerView)
        
        playerMotionManager = CMMotionManager()
        playerMotionManager.accelerometerUpdateInterval = 0.02
        
        self.startAccelerometer()
    }
    
    func createView(x: Int, y: Int, width: CGFloat, height: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> UIView {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(x: offsetX + width * CGFloat(x), y: offsetY + height * CGFloat(y))
        
        view.center = center
        
        return view
    }
    
    func startAccelerometer() {
        let handler: CMAccelerometerHandler = {(CMAccelerometerData: CMAccelerometerData?, error: Error?) ->
            Void in
            self.speedX += CMAccelerometerData!.acceleration.x
            self.speedY += CMAccelerometerData!.acceleration.y
            
            var posX = self.playerView.center.x + (CGFloat(self.speedX) / 3)
            var posY = self.playerView.center.y - (CGFloat(self.speedY) / 3)
            
            if posX <= self.playerView.frame.width / 2 {
                self.speedX = 0
                posX = self.playerView.frame.width / 2
            }
            if posY <= self.playerView.frame.height / 2 {
                self.speedY = 0
                posY = self.playerView.frame.height / 2
            }
            if posX >= self.screenSize.width - (self.playerView.frame.width / 2) {
                self.speedX = 0
                posX = self.screenSize.width - (self.playerView.frame.width / 2)
            }
            if posY >= self.screenSize.height - (self.playerView.frame.height / 2) {
                self.speedY = 0
                posX = self.screenSize.height - (self.playerView.frame.height / 2)
            }
            
            for wallRect in self.wallrectArray {
                if (wallRect.intersects(self.playerView.frame)){
                    self.gameCheck(result: "gameover", message: "壁に当たりました")
                    return
                }
            }
            
            if (self.goalView.frame.intersects(self.playerView.frame)) {
                self.gameCheck(result: "Clear", message: "クリアしました！")
                return
            }
            
            self.playerView.center = CGPoint(x: posX, y: posY)
        }
        playerMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: handler)
    }
    
    func gameCheck(result: String, message: String) {
        if playerMotionManager.isAccelerometerActive {
            playerMotionManager.stopAccelerometerUpdates()
        }
        
        let gameCheckAlert: UIAlertController = UIAlertController(title: result, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "もう一度", style: .default, handler: {(action: UIAlertAction!) -> Void in
            self.retry()
        })
        gameCheckAlert.addAction(retryAction)
        self.present(gameCheckAlert, animated: true, completion: nil)
    }
    
    func retry() {
        playerView.center = startView.center
        if !playerMotionManager.isAccelerometerActive {
            self.startAccelerometer()
        }
        speedX = 0.0
        speedY = 0.0
    }

}

