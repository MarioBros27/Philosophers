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
    //MARK: Initialization
    init(face: NSImageView){
        //rightFork.self = rightF
        //leftFork.self = leftF
        myForkAvailable = true
        self.face = face
    }
    
    
}
