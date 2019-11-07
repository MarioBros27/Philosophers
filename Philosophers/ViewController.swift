//
//  ViewController.swift
//  Philosophers
//
//  Created by Andres on 11/5/19.
//  Copyright © 2019 Andres. All rights reserved.
//
import Foundation
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
    let threadsN = 5
    let group = DispatchGroup()
    var running: Bool?
    
//    let semaphore = DispatchSemaphore(value: 1)
    var fork = [DispatchSemaphore]()
    let room = DispatchSemaphore(value: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        philosophers.append(Philosopher(face: phil1Image, id: 0))
        philosophers.append(Philosopher(face: phil2Image, id: 1))
        philosophers.append(Philosopher(face: phil3Image, id: 2))
        philosophers.append(Philosopher(face: phil4Image, id: 3))
        philosophers.append(Philosopher(face: phil5Image, id: 4))

        for i in 0..<threadsN{
            let threadN = DispatchQueue(label: "\(i)",qos: .utility)
            philosophers[i].setThread(thread: threadN)
            fork.append(DispatchSemaphore(value: 1))
        }
        
    }

    //MARK: Threads logic
    
    func runThread(philosopher: Philosopher){
        group.enter()
        philosopher.thread!.async{
            
            while(self.running!){
                self.think(philosopher: philosopher)
//                print("T\(philosopher.id) room wait")
                self.room.wait()
//                self.wait(philosopher: philosopher)
//                print("T\(philosopher.id) fork 1 wait")
                self.fork[philosopher.id].wait()
//                self.wait(philosopher: philosopher)

//                print("T\(philosopher.id) fork  2 wait")
                self.fork[(philosopher.id+1) % 5].wait()
                self.eat(philosopher: philosopher)
//                print("T\(philosopher.id) eating")
//                usleep(useconds_t(Int.random(in: 1000000...2000000)))
//                sleep(1)
                self.fork[(philosopher.id+1) % 5].signal()
                self.fork[philosopher.id].signal()
                self.room.signal()
                print("T\(philosopher.id) ends critical section")
                
            }
            self.group.leave()
        }
    }
    func runAllThreads(){
//        var tempPhilosophers = [Philosopher]()
//        tempPhilosophers += philosophers
//        tempPhilosophers
        philosophers.shuffle()
        for i in 0..<threadsN{
            print("Initiated philosopher \(philosophers[i].id)")
            runThread(philosopher: philosophers[i])
        }
    }
    
    //MARK: Business logic
    func think(philosopher: Philosopher){
        print("Philosopher \(philosopher.id) is thinking")
        DispatchQueue.main.async{
            if(self.running!){
                philosopher.face.image = NSImage(named: NSImage.Name("thinkingImage"))
            }
        }
    }
    func eat(philosopher: Philosopher){
        print("Philosopher \(philosopher.id) is eating")
        DispatchQueue.main.async{
            if(self.running!){
                philosopher.face.image = NSImage(named: NSImage.Name("eatingImage"))
            }

        }
        if(self.running!){
            usleep(useconds_t(Int.random(in: 1500000...3000000)))
        }
    }
    func wait(philosopher: Philosopher){
        print("Philosopher \(philosopher.id) is waiting")
        DispatchQueue.main.async{
            if(self.running!){
            philosopher.face.image = NSImage(named: NSImage.Name("waitingImage"))
            }
        }
    }
    //MARK: Actions
    
    @IBAction func start(_ sender: NSButton) {
        running = true//Not usefeul
        runAllThreads()
    }
    @IBAction func stop(_ sender: Any) {
        
        running = false//Not useful
        startButton.isEnabled = false
        group.wait()
        startButton.isEnabled = true
    }
    
    @IBAction func deadlock(_ sender: Any) {
    }
//    override var representedObject: Any? {
//        didSet {
//            // Update the view, if already loaded.
//        }
//    }
}

