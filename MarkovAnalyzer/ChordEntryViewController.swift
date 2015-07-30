//
//  ChordEntryViewController.swift
//  MarkovAnalyzer
//
//  Created by Fupduck Central MBP on 5/21/15.
//  Copyright (c) 2015 Existential Music. All rights reserved.
//

import Cocoa
import CoreMIDI

struct GlobalVariables {
    static var totalChords = 0.0
    static let debugMode = true
}

class ChordEntryViewController: NSViewController {
    
    @IBOutlet weak var chordTableView: NSTableView!
    @IBOutlet weak var chordEntryField: NSTextField!
    @IBOutlet weak var addChordButton: NSButton!
    @IBOutlet weak var removeChordButton: NSButton!
    @IBOutlet var chordTransitionsTextView: NSTextView!
    
    
    var markovChain = MarkovGraph()
    
    let midiManager = MIDIManager.sharedInstance
    
    
    var chords = [Chord]()
    var chordTransitionsText = ""
    
    
    //  MARK: Current Chord variables
    
    @IBOutlet weak var chordComboBox: NSComboBox!
    @IBOutlet weak var romanNumeralComboBox: NSComboBox!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //  Attempt to start MIDI
        self.midiManager.initMIDI()

        if self.chords.count == 0 {
            self.removeChordButton.enabled = false
        }
    }
    
    func submitChord(chord:Chord) {
        self.markovChain.putChord(chord)
        self.chords = self.markovChain.getChordProgression()
        self.addChordToTable()
        self.updateViews()
    }
    
    private func addChordToTable() {
        let newRowIndex = self.chords.count - 1
        self.chordTableView.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap)
        //  Scroll the table to the new chord
        self.chordTableView.selectRowIndexes(NSIndexSet(index: newRowIndex), byExtendingSelection: false)
        self.chordTableView.scrollRowToVisible(newRowIndex)
        self.chordTableView.deselectRow(newRowIndex)
    }
    
    private func reloadChordTableCell(index: NSIndexSet) {
        self.chordTableView.reloadDataForRowIndexes(index, columnIndexes: NSIndexSet(index: 0))
    }
    
    private func updateViews() {
        self.chordTransitionsText = self.markovChain.displayChords()
        self.chordTransitionsTextView.string = self.chordTransitionsText
//        self.chordTransitionsTextView.string == self.markovChain.displayChords()
    }
    
    private func getTransitionDisplayStrings() -> String {
        return self.markovChain.displayChords()
    }
    
    func checkChords(chord:String)->(exists:Bool, chordIndex:Int) {
        for index in 0..<chords.count {
            if chords[index].chordName == chord {
                return (true, index)
            }
        }
        return (false, -1)
    }
    
    func selectedChord() -> Chord? {
        let selectedRow = self.chordTableView.selectedRow
        if selectedRow >= 0 && selectedRow < self.chords.count {
            return self.chords[selectedRow]
        }
        return nil
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MIDIChordEntry" {
            if let midiChordEntryCtrl = segue.destinationController as? MIDIChordEntryViewController {
                midiChordEntryCtrl.chordEntryViewController = self
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ChordEntryViewController {
    
    @IBAction func editingChanged(sender: AnyObject) {
        if self.chordEntryField.stringValue != "" {
            self.addChordButton.enabled = true
        }
    }
    @IBAction func addChord(sender: AnyObject) {
        let chordName = (self.chordEntryField.stringValue)
        self.submitChord(Chord(chordName: chordName))
        self.chordEntryField.stringValue = ""
        self.addChordButton.enabled = false
        self.removeChordButton.enabled = true
    }
    
    @IBAction func removeChord(sender: AnyObject) {
        if let chord = self.selectedChord() {
            self.markovChain.removeChord(chord, indexInProgression: self.chordTableView.selectedRow)
            if let _ = self.selectedChord() {
                self.chords.removeAtIndex(self.chordTableView.selectedRow)
                self.chordTableView.removeRowsAtIndexes(NSIndexSet(index: self.chordTableView.selectedRow), withAnimation: NSTableViewAnimationOptions.SlideRight)
                updateViews()
            }
        }
    }
}

extension ChordEntryViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.chords.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // 1
        let cellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! ChordCellView
        // 2
        if tableColumn!.identifier == "ChordColumn" {
            // 3
            let chordDoc = self.chords[row]
            cellView.chordNameTextField!.stringValue = chordDoc.chordName
            cellView.romanNumberalTextField!.stringValue = chordDoc.romanNumeral
            cellView.chordNumberTextField!.integerValue = row + 1
            return cellView
        }
        
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension ChordEntryViewController: NSTableViewDelegate {
}






