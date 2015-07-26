//
//  ViewController.swift
//  MarkovMusicTheory
//
//  Created by Fupduck Central MBP on 5/23/15.
//  Copyright (c) 2015 Existential Music. All rights reserved.
//

import Cocoa
import CoreMIDI


class ViewController: NSViewController {

    @IBOutlet weak var numberOfMIDISourcesTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var sourceCount = MIDIGetNumberOfSources()
        numberOfMIDISourcesTextField.stringValue = "\(sourceCount)"
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

