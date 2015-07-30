//
//  Note.swift
//  MarkovAnalyzer
//
//  Created by Jess Hendricks on 7/28/15.
//  Copyright © 2015 Existential Music. All rights reserved.
//

import Cocoa

class Note: Hashable {
    var noteName: String!
    var enharmonicNoteNames: [String]!
    var noteNumber: Int!
    init(noteName: String? = nil, noteNumber: Int) {
        self.noteNumber = noteNumber
        if noteName != nil {
            self.setEnharmonics(noteNumber, noteName: noteName)
        } else {
            self.setEnharmonics(noteNumber)
        }
    }
    
    private func setEnharmonics(noteNumber: Int, noteName: String? = nil) {
        self.enharmonicNoteNames = [String]()
        let modNoteNumber = ChordAnalysis.modTwelve(noteNumber)
        switch modNoteNumber {
        case 0:
            self.enharmonicNoteNames = ["C",    "C",    "Dbb",    "B#"]
        case 1:
            self.enharmonicNoteNames = ["Db",    "C#",    "Db",   "C#"]
        case 2:
            self.enharmonicNoteNames = ["D",    "D",    "Ebb",    "C##"]
        case 3:
            self.enharmonicNoteNames = ["Eb",    "D#",    "Eb",   "D#"]
        case 4:
            self.enharmonicNoteNames = ["E",    "E",    "Fb",    "D##"]
        case 5:
            self.enharmonicNoteNames = ["F",    "F",    "Gbb",    "E#"]
        case 6:
            self.enharmonicNoteNames = ["Gb",    "F#",    "Gb",   "F#"]
        case 7:
            self.enharmonicNoteNames = ["G",    "G",    "Abb",    "F##"]
        case 8:
            self.enharmonicNoteNames = ["Ab",    "G#",    "Ab",   "G#"]
        case 9:
            self.enharmonicNoteNames = ["A",    "A",    "Bbb",    "G##"]
        case 10:
            self.enharmonicNoteNames = ["Bb",    "A#",    "Bb",   "A#"]
        case 11:
            self.enharmonicNoteNames = ["B",    "B",    "Cb",    "A##"]
        default:
            if noteName != nil {
                self.enharmonicNoteNames = [noteName!]
            } else {
                self.enharmonicNoteNames = [""]
            }
        }
        if noteName != nil {
            self.noteName = noteName
        } else {
            self.noteName = self.enharmonicNoteNames[0]
        }
    }
    
    var hashValue: Int {
        return self.noteName.hashValue
    }
    
    func isEnharmonic(compareNote: Note) -> Bool {
        return self.noteNumber % 12 == compareNote.noteNumber % 12
    }
}
func == (noteA: Note, noteB: Note) -> Bool {
    return noteA.noteName == noteB.noteName
}
