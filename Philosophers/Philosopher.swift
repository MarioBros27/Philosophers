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
    var myFork: NSImageView
    var otherFork: NSImageView
    var usingOtherFork: NSImageView
    var isEating: Bool
    var face: NSImageView
    var thread: DispatchQueue?
    var id: Int
    //MARK: Initialization
    init(face: NSImageView, id: Int, myFork: NSImageView, otherFork: NSImageView, usingOtherFork: NSImageView){
        //rightFork.self = rightF
        //leftFork.self = leftF
        isEating = false
        self.face = face
        self.id = id
        self.myFork = myFork
        self.otherFork = otherFork
        self.usingOtherFork = usingOtherFork
        
    }
    public func setThread(thread: DispatchQueue){
        self.thread = thread
    }
    
    
}
