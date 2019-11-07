//
//  ViewController.swift
//  Philosophers
//
//  Created by Andres on 11/5/19.
//  Copyright © 2019 Andres. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    //MARK: Properties
    
    @IBOutlet weak var phil1Image: NSImageView!
    
    @IBOutlet weak var phil2Image: NSImageView!
    
    @IBOutlet weak var phil3Image: NSImageView!
    
    @IBOutlet weak var phil4Image: NSImageView!
    
    @IBOutlet weak var phil5Image: NSImageView!
    
    @IBOutlet weak var startButton: NSButton!
    
    @IBOutlet weak var stopButton: NSButton!
    
    @IBOutlet weak var deadlockButton: NSButton!
    
    var philosophers = [Philosopher]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        philosophers.append(Philosopher(face: phil1Image))
        philosophers.append(Philosopher(face: phil2Image))
        philosophers.append(Philosopher(face: phil3Image))
        philosophers.append(Philosopher(face: phil4Image))
        philosophers.append(Philosopher(face: phil5Image))
        
    }

    //MARK: Actions
    
    @IBAction func start(_ sender: NSButton) {
    }
    @IBAction func stop(_ sender: Any) {
    }
    
    @IBAction func deadlock(_ sender: Any) {
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    //MARK: Private Methods
    
    
    func think(phil: Philosopher){
        
    }
    func eat(phil: Philosopher){
        
    }
}

