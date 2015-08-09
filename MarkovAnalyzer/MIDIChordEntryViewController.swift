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
    @IBOutlet weak var clearNotesButton: NSButton!
    @IBOutlet weak var romanNumeralComboBox: NSComboBox!
    @IBOutlet weak var keySigPopup: NSPopUpButton!
    
    private var notes: [Note]!
    private var chordResult: Chord!
    private var romanNumeralResult: String!
    var currentKeySig: KeySignature!
    var chordEntryViewController: ChordEntryViewController!
    
    private let keySigs = [kCMajor, kCSharpMajor, kDFlatMajor, kDMajor, kDSharpMajor, kEFlatMajor, kEMajor, kFMajor, kFSharpMajor,
        kGFlatMajor, kGMajor, kGSharpMajor, kAFlatMajor, kAMajor, kASharpMajor, kBFlatMajor, kBMajor, kCFlatMajor,
        kCMinor, kCSharpMinor, kDFlatMinor, kDMinor, kDSharpMinor, kEFlatMinor, kEMinor, kFMinor, kFSharpMinor,
        kGFlatMinor, kGMinor, kGSharpMinor, kAFlatMinor, kAMinor, kASharpMinor, kBFlatMinor, kBMinor]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.possibleChordsPopUp.removeAllItems()
        self.possibleChordsPopUp.enabled = false
        let romanNumerals = [
            "none",
            "I", "I6", "I64", "I7", "I65", "I43", "I42",
            "ii", "ii6", "ii64", "ii7", "ii65", "ii43", "ii42",
            "iii", "iii6", "iii64", "iii7", "iii65", "iii43", "iii42",
            "IV", "IV6", "IV64", "IV7", "IV65", "IV43", "IV42",
            "V", "V6", "V64", "V7", "V65", "V43", "V42",
            "vi", "vi6", "vi64", "vi7", "vi65", "vi43", "vi42",
            "viiº", "viiº6", "viiº64", "viiº7", "viiº65", "viiº43", "viiº42", "viiø7", "viiø65", "viiø43", "viiø42",
            
            "i", "i6", "i64", "i7", "i65", "i43", "i42",
            "iiº", "iiº6", "iiº64", "iiø7", "iiø65", "iiø43", "iiø42",
            "III", "III6", "III64", "III7", "III65", "III43", "III42",
            "iv", "iv6", "iv64", "iv7", "iv65", "iv43", "iv42",
            "V", "V6", "V64", "V7", "V65", "V43", "V42",
            "VI", "VI6", "VI64", "VI7", "VI65", "VI43", "VI42",
            "VII", "VII6", "VII64", "VII7", "VII65", "VII43", "VII42",
            "viiº", "viiº6", "viiº64", "viiº7", "viiº65", "viiº43", "viiº42", "viiø7", "viiø65", "viiø43", "viiø42",
            "N6",
            "It6", "Ger6", "Fr6"
        ]
        self.romanNumeralComboBox.removeAllItems()
        self.romanNumeralComboBox.addItemsWithObjectValues(romanNumerals)
        self.romanNumeralComboBox.selectItemAtIndex(0)
        self.romanNumeralResult = self.romanNumeralComboBox.selectedCell()?.stringValue
        
        self.keySigPopup.removeAllItems()
        for keySig in self.keySigs {
            self.keySigPopup.addItemWithTitle(keySig.keyName)
        }
        self.keySigPopup.selectItemAtIndex(keySigs.indexOf(self.currentKeySig)!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleMIDI:", name: "MIDINoteNotifictation", object: nil)
    }
    
    func handleMIDI(notification: NSNotification) {
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        let noteNumber = userInfo["Note"] as! Int
        let newNote = Note(noteNumber: noteNumber)
        if self.notes == nil {
            self.notes = [Note]()
        }
        if self.notes.contains(newNote) {
            self.notes.removeAtIndex(self.notes.indexOf(newNote)!)
        } else {
            self.notes.append(newNote)
        }
        self.getChord()
        if self.notes.count > 0 {
            self.possibleChordsPopUp.enabled = true
        }
        var notesDisplay = ""
        for nextNote in self.notes {
            notesDisplay = notesDisplay + "\(nextNote.noteName):\(nextNote.noteNumber), "
        }
        self.notesPlayedTextField.stringValue = notesDisplay
       
    }
    
    func getChord() {
        if self.notes != nil && self.notes.count > 0 {
            self.chordResult = Chord(notes: self.notes)
            var chordNames = [String]()
            for nextChordName in self.chordResult.enharmonicChordNames {
                chordNames.append(nextChordName)
            }
            print(self.chordResult.chordDescription())
            self.populatePossibleChordsAndRoman(chordNames)
        }
    }
    
    private func populatePossibleChordsAndRoman(chordNames: [String]) {
        self.possibleChordsPopUp.removeAllItems()
        for nextResult in chordNames {
            self.possibleChordsPopUp.addItemWithTitle(nextResult)
        }
        self.possibleChordsPopUp.selectItemAtIndex(0)
        if let chordResultTitle = self.possibleChordsPopUp.selectedItem?.title {
            self.chordResult.selectEnharmonic(chordResultTitle)
        }

    }
    @IBAction func setResult(sender: AnyObject) {
        let chordResultTitle = self.possibleChordsPopUp.selectedItem?.title
        self.chordResult.selectEnharmonic(chordResultTitle!)
    }
    
    @IBAction func selectRomanNumeral(sender: AnyObject) {

        self.romanNumeralResult = self.romanNumeralComboBox.selectedCell()?.stringValue
    }
    
    @IBAction func selectKeySig(sender: AnyObject) {
        self.currentKeySig = self.keySigs[self.keySigPopup.indexOfSelectedItem]
    }
//    @IBAction func selectChord(sender: AnyObject) {
//        if self.possibleChordsPopUp.selectedItem == 0 {
//            self.customChordNameTextField.enabled = true
//        } else {
//            self.customChordNameTextField.enabled = false
//        }
//    }
    
    @IBAction func clearNotes(sender: AnyObject) {
        if self.notes != nil {
            if self.notes.count > 0 {
                self.notes.removeAll()
                self.notesPlayedTextField.stringValue = ""
            }
            self.chordResult = nil
            self.possibleChordsPopUp.removeAllItems()
            self.possibleChordsPopUp.enabled = false
        }
    }
    
    @IBAction func doneEnteringChord(sender: AnyObject) {
        if self.chordResult != nil {
            self.chordResult.romanNumeral = self.romanNumeralResult
            self.chordResult.keySig = self.currentKeySig
            self.chordEntryViewController.submitChord(self.chordResult)
            self.chordEntryViewController.currentKeySig = self.currentKeySig
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.dismissController(nil)
    }
    
    @IBAction func cancelEnteringChord(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.dismissController(nil)
    }
}
