//
//  Philosopher.swift
//  Philosophers
//
//  Created by Andres on 11/6/19.
//  Copyright © 2019 Andres. All rights reserved.
//

import Foundation
import Cocoa

class Philosopher{
    //MARK: Properties
   // var rightFork: NSImageView?
    //var leftFork: NSImageView
    var myForkAvailable: Bool
    var face: NSImageView
    var thread: DispatchQueue?
    var id: Int
    //MARK: Initialization
    init(face: NSImageView, id: Int){
        //rightFork.self = rightF
        //leftFork.self = leftF
        myForkAvailable = true
        self.face = face
        self.id = id
    }
    public func setThread(thread: DispatchQueue){
        self.thread = thread
    }
    
    
}
