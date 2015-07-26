//
//  Chord.swift
//  MarkovAn
//
//  Created by Fupduck Central MBP on 5/28/15.
//  Copyright (c) 2015 Existential Music. All rights reserved.
//

import Cocoa

class Chord: Hashable {
    
    
    var chordConnections: [Chord: Int]!
    var totalOccurences: Int = 1
    var totalConnections: Double = 0.0
    internal private(set) var chordName: String = "N/A"
    
    //  Note values
    internal private(set) var chordMembers = [Note]()
    //    internal private(set) var bassNote: Note!
    //    internal private(set) var possibleAnalyses: [String: String]!
    
    
    var hashValue: Int {
        return self.chordName.hashValue
    }
    
    //    func addNote(noteNumber: Int) {
    //    }
    //
    //    func removeNote(noteNumber: Int) {
    //    }
    
    init(chordName: String) {
        self.chordName = chordName
        self.chordConnections = [Chord: Int]()
    }
    
    //    init(chordName: String, notes: [Note], bassNote: Note, possibleAnalyses: [String: String]) {
    //        self.chordName = chordName
    //        self.chordMembers = notes
    //        self.bassNote = bassNote
    //        self.possibleAnalyses = possibleAnalyses
    //    }
    
    func hasChordConnectionToChord(chord: Chord) -> Bool {
        var retVal = false
        for chordConnection in self.chordConnections {
            if chordConnection.0 == chord {
                retVal = true
            }
        }
        return retVal
    }
    
    func addChordConnection(chord: Chord) {
        if self.chordConnections[chord] != nil {
            self.chordConnections[chord]!++
        } else {
            self.chordConnections[chord] = 1
        }
        self.totalConnections++
    }
    
    func removeChordConnection(chord: Chord) {
        if self.chordConnections[chord] != nil {
            let totConn = --self.chordConnections[chord]!
            if totConn == 0 {
                self.chordConnections.removeValueForKey(chord)
            }
            self.totalConnections--
        }
    }
    
    func getProbabilityOfNextForChord(chord: Chord) -> Double {
        if self.chordConnections[chord] != nil {
            return Double(self.chordConnections[chord]!) / Double(self.totalConnections)
        }
        return 0.0
    }
    
    private func findLowestNote() -> Note {
        var lowestNote = Note(noteName: "C", noteNumber: 264)
        for chordMember in self.chordMembers {
            if chordMember.noteNumber < lowestNote.noteNumber {
                lowestNote = chordMember
            }
        }
        return lowestNote
    }
    
}
func == (chordOne: Chord, chordTwo: Chord) -> Bool {
    return chordOne.chordName == chordTwo.chordName
}





