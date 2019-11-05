//
//  ViewController.swift
//  Philosophers
//
//  Created by Andres on 11/5/19.
//  Copyright © 2019 Andres. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var image1: NSImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tryfunc()
    }

    @IBAction func button(_ sender: NSButton) {
        image1.image = NSImage(imageLiteralResourceName: "eatingImage")
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func tryfunc(){
    }

}

