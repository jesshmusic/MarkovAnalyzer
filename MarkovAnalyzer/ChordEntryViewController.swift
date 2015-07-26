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
    
    @IBOutlet var chordTransitionTextView: NSTextView!
    @IBOutlet weak var chordIndexLabel: NSTextField!
    @IBOutlet weak var nextChordLabel: NSTextField!
    @IBOutlet weak var chordTableView: NSTableView!
    @IBOutlet weak var chordEntryField: NSTextField!
    @IBOutlet weak var addChordButton: NSButton!
    @IBOutlet weak var removeChordButton: NSButton!
    
    
    var markovChain = MarkovGraph()
    
    let midiManager = MIDIManager.sharedInstance
    
    
    var chords = [Chord]()
    //    var chords = [Chord]()
    //    var currentChord = 0
    //    var nextChord = 0
    //
    //    var testChordCount = 0
    
    @IBOutlet weak var pauseButtonOutlet: NSButton!
    @IBAction func pauseApp(sender: AnyObject) {
        print("App paused")
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //  Attempt to start MIDI
        self.midiManager.initMIDI()
        
        if self.chordEntryField.stringValue == "" {
            self.addChordButton.enabled = false
        }
        if self.chords.count == 0 {
            self.removeChordButton.enabled = false
        }
    }
    
    private func submitChord(chordName: String) {
        self.markovChain.putChord(Chord(chordName: chordName))
        self.chords = markovChain.getChordProgression()
        self.addChordToTable()
        self.updateViews()
    }
    
    private func addChordToTable() {
        let newRowIndex = self.chords.count - 1
        self.chordTableView.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap)
        //  Scroll the table to the new chord
        self.chordTableView.selectRowIndexes(NSIndexSet(index: newRowIndex), byExtendingSelection: false)
        self.chordTableView.scrollRowToVisible(newRowIndex)
    }
    
    private func reloadChordTableCell(index: NSIndexSet) {
        self.chordTableView.reloadDataForRowIndexes(index, columnIndexes: NSIndexSet(index: 0))
    }
    
    private func updateViews() {
        self.chordTransitionTextView.string = "\(getTransitionDisplayStrings())"
        //        numTransMatrixTextField.stringValue = "\(getTransitionDisplayStrings().numTrans)"
        self.chordIndexLabel.integerValue = 0
        self.nextChordLabel.integerValue = 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GlobalVariables.debugMode {
            pauseButtonOutlet.hidden = false
        } else {
            pauseButtonOutlet.hidden = true
        }
    }
}

extension ChordEntryViewController {
    
    @IBAction func editingChanged(sender: AnyObject) {
        if self.chordEntryField.stringValue != "" {
            self.addChordButton.enabled = true
        }
    }
    @IBAction func addChord(sender: AnyObject) {
        self.markovChain.putChord(Chord(chordName: self.chordEntryField.stringValue))
        self.chords = self.markovChain.getChordProgression()
        self.addChordToTable()
        self.chordEntryField.stringValue = ""
        self.addChordButton.enabled = false
        self.removeChordButton.enabled = true
        self.updateViews()
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
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        // 2
        if tableColumn!.identifier == "ChordColumn" {
            // 3
            let chordDoc = self.chords[row]
            cellView.textField!.stringValue = chordDoc.chordName
            return cellView
        } else if tableColumn!.identifier == "Connections" {
            let chordDoc = self.chords[row]
            cellView.textField!.integerValue = Int(chordDoc.totalConnections)
            return cellView
        } else if tableColumn!.identifier == "Occurences" {
            let chordDoc = self.chords[row]
            cellView.textField!.integerValue = chordDoc.totalOccurences
            return cellView
        }
        
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension ChordEntryViewController: NSTableViewDelegate {
}






