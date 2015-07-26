//
//  MIDIChordEntryViewController.swift
//  MarkovAnalyzer
//
//  Created by Jess Hendricks on 7/26/15.
//  Copyright © 2015 Existential Music. All rights reserved.
//

import Cocoa

class MIDIChordEntryViewController: NSViewController {

    @IBOutlet weak var notesPlayedTextField: NSTextField!
    @IBOutlet weak var possibleChordsPopUp: NSPopUpButton!
    @IBOutlet weak var doneButton: NSButton!
    @IBOutlet weak var customChordNameTextField: NSTextField!
    
    private var notes: [Note]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.customChordNameTextField.enabled = false
    }
    
    @IBAction func selectChord(sender: AnyObject) {
        if self.possibleChordsPopUp.selectedItem == 0 {
            self.customChordNameTextField.enabled = true
        } else {
            self.customChordNameTextField.enabled = false
        }
    }
    
    @IBAction func doneEnteringChord(sender: AnyObject) {
    }
    
    @IBAction func cancelEnteringChord(sender: AnyObject) {
    }
}
