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
    
    @IBOutlet weak var fork1Image: NSImageView!
    
    @IBOutlet weak var fork2Image: NSImageView!
    
    @IBOutlet weak var fork3Image: NSImageView!
    
    @IBOutlet weak var fork4Image: NSImageView!
    
    @IBOutlet weak var fork5Image: NSImageView!
    
    @IBOutlet weak var startButton: NSButton!
    
    @IBOutlet weak var leftFork1Image: NSImageView!
    @IBOutlet weak var leftFork2Image: NSImageView!
    @IBOutlet weak var leftFork3Image: NSImageView!
    @IBOutlet weak var leftFork4Image: NSImageView!
    @IBOutlet weak var leftFork5Image: NSImageView!
    
    @IBOutlet weak var stopButton: NSButton!
    
    @IBOutlet weak var deadlockButton: NSButton!
    
    var philosophers = [Philosopher]()
    let threadsN = 5
    let group = DispatchGroup()
    var running: Bool?
    var deadlock: Bool?
    
//    let semaphore = DispatchSemaphore(value: 1)
    var fork = [DispatchSemaphore]()
    let room = DispatchSemaphore(value: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        deadlockButton.isEnabled = false
        // Do any additional setup after loading the view.
        deadlock = false
        philosophers.append(Philosopher(face: phil1Image, id: 0, myFork: fork1Image, otherFork: fork5Image, usingOtherFork: leftFork1Image))
        philosophers.append(Philosopher(face: phil2Image, id: 1, myFork: fork2Image, otherFork: fork1Image,usingOtherFork: leftFork2Image))
        philosophers.append(Philosopher(face: phil3Image, id: 2, myFork: fork3Image, otherFork: fork2Image,usingOtherFork: leftFork3Image))
        philosophers.append(Philosopher(face: phil4Image, id: 3, myFork: fork4Image, otherFork: fork3Image,usingOtherFork: leftFork4Image))
        philosophers.append(Philosopher(face: phil5Image, id: 4, myFork: fork5Image, otherFork: fork4Image,usingOtherFork: leftFork5Image))

        for i in 0..<threadsN{
            let threadN = DispatchQueue(label: "\(i)",qos: .userInteractive)
            philosophers[i].setThread(thread: threadN)
            fork.append(DispatchSemaphore(value: 1))
        }
        rotateImages()
        disableForks()
    }
    //MARK: UI funcs
    func rotateImages(){
        fork1Image.rotate(byDegrees: CGFloat(270))
        leftFork1Image.rotate(byDegrees: CGFloat(270))

        fork2Image.rotate(byDegrees: CGFloat(340))
        leftFork2Image.rotate(byDegrees: CGFloat(310))

        fork3Image.rotate(byDegrees: CGFloat(75))
        leftFork3Image.rotate(byDegrees: CGFloat(30))

        fork4Image.rotate(byDegrees: CGFloat(100))
        leftFork4Image.rotate(byDegrees: CGFloat(100))

        fork5Image.rotate(byDegrees: CGFloat(195))
        leftFork5Image.rotate(byDegrees: CGFloat(170))

    }
    func disableForks(){
        for philosopher in philosophers{
            philosopher.usingOtherFork.isHidden = true
            philosopher.myFork.isHidden = true
        }
    }
    //MARK: Threads logic
    
    func runThread(philosopher: Philosopher){
        group.enter()
        philosopher.thread!.async{
            
            while(self.running!){
                self.think(philosopher: philosopher)
                self.wait(philosopher: philosopher)
                    self.room.wait()
                    self.fork[philosopher.id].wait()
                self.fork[(philosopher.id+1) % 5].wait()
                
                self.eat(philosopher: philosopher)
                if(!self.deadlock!){
                self.fork[(philosopher.id+1) % 5].signal()
                self.fork[philosopher.id].signal()
                self.room.signal()
                }
                print("T\(philosopher.id) ends section")
                
            }
            self.group.leave()
        }
    }
    func runAllThreads(){
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
                let rightPhilosopher = philosopher.id + 1 > 4 ? 0 : philosopher.id + 1

                if(self.philosophers[rightPhilosopher].usingOtherFork.isHidden && !self.deadlock! ){
                    philosopher.myFork.isHidden = false
                }else{
//                    philosopher.myFork.isHidden = true
                }
                
        }
        }
        if(self.running!){
        usleep(useconds_t(Int.random(in: 2000000...3000000)))
        }

    }
    func eat(philosopher: Philosopher){
        print("Philosopher \(philosopher.id) is eating")
        DispatchQueue.main.async{
            philosopher.isEating = true
            if(self.running!){
                philosopher.myFork.isHidden = false
                philosopher.face.image = NSImage(named: NSImage.Name("eatingImage"))
                philosopher.otherFork.isHidden = true
                philosopher.usingOtherFork.isHidden = false
//                let rightP = philosopher.id + 1 > 4 ? 0 : philosopher.id + 1
//                self.philosophers[rightP].myFork.isHidden = true

//                let plusN = philosopher.id + 3 > 4 ? (philosopher.id + 3) % 5 : philosopher.id + 3
////                print("I'm \(philosopher.id) and plus N \(plusN)")
//                let minusN = philosopher.id - 3 < 0 ? philosopher.id + 2 : philosopher.id - 3
////                print("I'm \(philosopher.id) and minus N \(minusN)")
//                let rightP = philosopher.id + 1 > 4 ? 0 : philosopher.id + 1
////                print("I'm \(philosopher.id) and right P \(rightP)")
//                let leftP = philosopher.id - 1 < 0 ? 4 : philosopher.id - 1
////                print("I'm \(philosopher.id) and left P \(leftP)")
//                if(self.philosophers[plusN].isEating ){
//                    self.philosophers[rightP].myFork.isHidden = false
//                }
//                if(self.philosophers[minusN].isEating){
//                    self.philosophers[leftP].myFork.isHidden = true
//
//                }
//
            
            }
    }
        if(self.running!){
            usleep(useconds_t(Int.random(in: 3000000...4000000)))
        }
        DispatchQueue.main.async{
            if(self.running!){
                philosopher.isEating = false
                philosopher.otherFork.isHidden = true
                philosopher.usingOtherFork.isHidden = true
                philosopher.myFork.isHidden = true
            }
        }
        /*when the philosopher eats they get the other fork, finishes eating, then gives it back to
        the other philosopher
         though, it's till the other is waiting that he has the fork*/
    }
    func wait(philosopher: Philosopher){
        print("Philosopher \(philosopher.id) is waiting")
        DispatchQueue.main.async{
            if(self.running!){
                philosopher.face.image = NSImage(named: NSImage.Name("waitingImage"))
//                let rightPhilosopher = philosopher.id + 1 > 4 ? 0 : philosopher.id + 1
//                let leftPhilosopher = philosopher.id - 1 < 0 ? 4 : philosopher.id - 1
//                let minusN = philosopher.id - 2 < 0 ? philosopher.id + 1 : philosopher.id - 2
//
////                if(!self.philosophers[rightPhilosopher].isEating && self.philosophers[leftPhilosopher].isEating && self.philosophers[minusN].isEating){
////                    philosopher.myFork.isHidden = false
////                }else{
////                    philosopher.myFork.isHidden = true
////                }
//                if(!self.philosophers[rightPhilosopher].isEating && self.philosophers[leftPhilosopher].isEating && self.philosophers[rightPhilosopher].usingOtherFork.isHidden){
//                    philosopher.myFork.isHidden = false
//                }else{
//                    philosopher.myFork.isHidden = true
//                }
            }
        }
    }
    //MARK: Actions
    
    @IBAction func start(_ sender: NSButton) {
        running = true//Not usefeul
        runAllThreads()
        stopButton.isEnabled = true
        deadlockButton.isEnabled = true
        startButton.isEnabled = false
    }
    @IBAction func stop(_ sender: Any) {
        
        running = false//Not useful
        group.wait()
//        disableForks()
        for philosopher in philosophers{
            philosopher.isEating = false
        }
        startButton.isEnabled = true
        
    }
    
    @IBAction func deadlock(_ sender: Any) {
        //Disable the room semaphore so all pick the fork
        deadlock = true
//        startButton.isEnabled = false
//        stopButton.isEnabled = true
    }
}
