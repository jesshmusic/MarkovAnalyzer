//
//  ViewController.swift
//  MarkovAnalyzer
//
//  Created by Fupduck Central MBP on 5/21/15.
//  Copyright (c) 2015 Existential Music. All rights reserved.
//

import Cocoa

var totalChords = 0

class ViewController: NSViewController {

    @IBOutlet weak var numberOfMIDISourcesTextField: NSTextField!
    @IBOutlet weak var midiSourceListTextField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

