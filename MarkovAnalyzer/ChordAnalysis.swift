//
//  ChordAnalysis.swift
//  MarkovAnalyzer
//
//  Created by Jess Hendricks on 7/25/15.
//  Copyright © 2015 Existential Music. All rights reserved.
//

import Cocoa

class ChordAnalysis: NSObject {
    
    var triadNames: [Set<Int>: [String]]
    var seventhChordNames: [Set<Int>: [String]]
    
    func generateChordFromNotes(notes: [Note]) -> [Chord] {
        
        var returnChords: [Chord]!
        var reducedNotes = Set<Int>()
        let bassNote = self.getBassNote(notes)
        for note in notes {
            reducedNotes.insert(note.noteNumber % 12)
        }
        if reducedNotes.count == 3 {
            let chordNames = self.triadNames[reducedNotes]!
            returnChords = self.getChordsForChordNames(chordNames, bassNote: bassNote)
        }
        if reducedNotes.count == 4 {
            let chordNames = self.seventhChordNames[reducedNotes]!
            returnChords = self.getChordsForChordNames(chordNames, bassNote: bassNote)
        }
        return returnChords
    }
    
    private func getChordsForChordNames(chordNames: [String], bassNote: Note) -> [Chord] {
        var returnChords = [Chord]()
        for chordName in chordNames {
            var bassNoteString = ""
            if bassNote.noteName.rangeOfString(chordName) == nil {
                bassNoteString = "/\(bassNote.noteName)"
            }
            returnChords.append(Chord(chordName: chordName + bassNoteString))
        }
        return returnChords
    }
    
    private func getBassNote(notes: [Note]) -> Note {
        var lowestNote: Note!
        for note in notes {
            if lowestNote == nil {
                lowestNote = note
            } else {
                if lowestNote.noteNumber > note.noteNumber {
                    lowestNote = note
                }
            }
        }
        return lowestNote
    }
    
    override init() {
        self.triadNames = [
            
            //  Triads
            Set<Int>([0, 4, 7]): ["C", "B#"],
            Set<Int>([0, 3, 7]): ["Cm", "B#m"],
            Set<Int>([0, 3, 6]): ["Co", "B#o"],
            Set<Int>([0, 4, 8]): ["C+", "E+", "G#+", "Ab+"],
            
            Set<Int>([1, 5, 8]): ["Db", "C#"],
            Set<Int>([1, 4, 8]): ["Dbm", "C#m"],
            Set<Int>([1, 4, 7]): ["Dbo", "C#o"],
            Set<Int>([1, 5, 9]): ["Db+", "C#+", "F+", "A+"],
            
            Set<Int>([2, 6, 9]): ["D"],
            Set<Int>([2, 5, 9]): ["Dm"],
            Set<Int>([2, 5, 8]): ["Do"],
            Set<Int>([2, 6, 10]): ["D+", "F#+", "Gb+", "A#+", "Bb+"],
            
            Set<Int>([3, 7, 10]): ["Eb", "D#"],
            Set<Int>([3, 6, 10]): ["Ebm", "D#m"],
            Set<Int>([3, 6, 9]): ["Ebo", "D#o"],
            Set<Int>([3, 7, 11]): ["Eb+", "D#+", "G+", "B+"],
            
            Set<Int>([4, 8, 11]): ["E", "Fb"],
            Set<Int>([4, 7, 11]): ["Em", "Fbm"],
            Set<Int>([4, 7, 10]): ["Eo", "Fbo"],
            
            Set<Int>([0, 5, 9]): ["F", "E#"],
            Set<Int>([0, 5, 8]): ["Fm", "E#m"],
            Set<Int>([5, 8, 11]): ["Fo", "E#o"],
            
            Set<Int>([1, 6, 10]): ["Gb", "F#"],
            Set<Int>([1, 6, 9]): ["Gbm", "F#m"],
            Set<Int>([0, 6, 9]): ["Gbo", "F#o"],
            
            Set<Int>([2, 7, 11]): ["G"],
            Set<Int>([2, 7, 10]): ["Gm"],
            Set<Int>([1, 7, 10]): ["Go"],
            
            Set<Int>([0, 3, 8]): ["Ab", "G#"],
            Set<Int>([3, 8, 11]): ["Abm", "G#m"],
            Set<Int>([2, 8, 11]): ["Abo", "G#o"],
            
            Set<Int>([1, 4, 9]): ["A"],
            Set<Int>([0, 4, 9]): ["Am"],
            Set<Int>([0, 3, 9]): ["Ao"],
            
            Set<Int>([2, 5, 10]): ["Bb", "A#"],
            Set<Int>([1, 5, 10]): ["Bbm", "A#m"],
            Set<Int>([1, 4, 10]): ["Bbo", "A#o"],
            
            Set<Int>([3, 6, 11]): ["B", "Cb"],
            Set<Int>([2, 6, 11]): ["Bm", "Cbm"],
            Set<Int>([2, 5, 11]): ["Bo", "Cbo"],
            
            //  Italian Augemented-Six chords or Dominant seventh without fifth
            
            Set<Int>([0, 4, 10]): ["C7", "B#7", "ItaA6"],
            Set<Int>([1, 5, 11]): ["Db7", "C#7", "ItaA6"],
            Set<Int>([2, 6, 0]): ["D7", "ItaA6"],
            Set<Int>([3, 7, 1]): ["Eb7", "D#7", "ItaA6"],
            Set<Int>([4, 8, 2]): ["E7", "Fb7", "ItaA6"],
            Set<Int>([5, 9, 3]): ["F7", "E#7", "ItaA6"],
            Set<Int>([6, 10, 4]): ["Gb7", "F#7", "ItaA6"],
            Set<Int>([7, 11, 5]): ["G7", "ItaA6"],
            Set<Int>([8, 0, 6]): ["Ab7", "G#7", "ItaA6"],
            Set<Int>([9, 1, 7]): ["A7", "ItaA6"],
            Set<Int>([10, 2, 8]): ["Bb7", "A#7", "ItaA6"],
            Set<Int>([11, 3, 9]): ["B7", "Cb7", "ItaA6"]
        ]
        
        
        self.seventhChordNames = [
            //  Seventh Chords Standard
            Set<Int>([0, 3, 7, 10]): ["Cm7", "B#m7"],
            Set<Int>([0, 3, 7, 11]): ["CmM7", "B#mM7"],
            Set<Int>([0, 4, 7, 10]): ["C7", "B#7", "GerA6"],
            Set<Int>([0, 4, 7, 11]): ["Cmaj7", "B#maj7"],
            
            Set<Int>([1, 4, 8, 11]): ["Dbm7", "C#m7"],
            Set<Int>([1, 4, 8, 0]): ["DbmM7", "C#mM7"],
            Set<Int>([1, 5, 8, 11]): ["Db7", "C#7", "GerA6"],
            Set<Int>([1, 5, 8, 0]): ["Dbmaj7", "C#maj7"],
            
            Set<Int>([2, 5, 9, 0]): ["Dm7"],
            Set<Int>([2, 5, 9, 1]): ["DmM7"],
            Set<Int>([2, 6, 9, 0]): ["D7"],
            Set<Int>([2, 6, 9, 1]): ["Dmaj7"],
            
            Set<Int>([3, 6, 10, 1]): ["Ebm7", "D#m7"],
            Set<Int>([3, 6, 10, 2]): ["EbmM7", "D#mM7"],
            Set<Int>([3, 7, 10, 1]): ["Eb7", "D#7", "GerA6"],
            Set<Int>([3, 7, 10, 2]): ["Ebmaj7", "D#maj7"],
            
            Set<Int>([4, 7, 11, 2]): ["Em7", "Fbm7"],
            Set<Int>([4, 7, 11, 3]): ["EmM7", "FbmM7"],
            Set<Int>([4, 8, 11, 2]): ["E7", "Fb7", "GerA6"],
            Set<Int>([4, 8, 11, 3]): ["Emaj7", "Fbmaj7"],
            
            Set<Int>([5, 8, 0, 3]): ["Fm7", "E#m7"],
            Set<Int>([5, 8, 0, 4]): ["FmM7", "E#mM7"],
            Set<Int>([5, 9, 0, 3]): ["F7", "E#7", "GerA6"],
            Set<Int>([5, 9, 0, 4]): ["Fmaj7", "Emaj7"],
            
            Set<Int>([6, 9, 1, 4]): ["Gbm7", "F#m7"],
            Set<Int>([6, 9, 1, 5]): ["GbmM7", "F#mM7"],
            Set<Int>([6, 10, 1, 4]): ["Gb7", "F#7", "GerA6"],
            Set<Int>([6, 10, 1, 5]): ["Gbmaj7", "F#maj7"],
            
            Set<Int>([7, 10, 2, 5]): ["Gm7"],
            Set<Int>([7, 10, 2, 6]): ["GmM7"],
            Set<Int>([7, 11, 2, 5]): ["G7", "GerA6"],
            Set<Int>([7, 11, 2, 6]): ["Gmaj7"],
            
            Set<Int>([8, 11, 3, 6]): ["Abm7", "G#m7"],
            Set<Int>([8, 11, 3, 7]): ["AbmM7", "G#mM7"],
            Set<Int>([8, 0, 3, 6]): ["Ab7", "G#7", "GerA6"],
            Set<Int>([8, 0, 3, 7]): ["Abmaj7", "G#maj7"],
            
            Set<Int>([9, 0, 4, 7]): ["Am7"],
            Set<Int>([9, 0, 4, 8]): ["AmM7"],
            Set<Int>([9, 1, 4, 7]): ["A7", "GerA6"],
            Set<Int>([9, 1, 4, 8]): ["Amaj7"],
            
            Set<Int>([10, 1, 5, 8]): ["Bbm7", "A#m7"],
            Set<Int>([10, 1, 5, 9]): ["BbmM7", "A#mM7"],
            Set<Int>([10, 2, 5, 8]): ["Bb7", "A#7", "GerA6"],
            Set<Int>([10, 2, 5, 9]): ["Bbmaj7", "A#maj7"],
            
            Set<Int>([11, 2, 6, 9]): ["Em7", "Fbm7"],
            Set<Int>([11, 2, 6, 10]): ["EmM7", "FbmM7"],
            Set<Int>([11, 3, 6, 9]): ["E7", "Fb7", "GerA6"],
            Set<Int>([11, 3, 6, 10]): ["Emaj7", "Fbmaj7"],
            
            //  Half Diminished 7th chords
            Set<Int>([0, 3, 6, 10]): ["Cø7", "B#ø7"],
            Set<Int>([1, 4, 7, 11]): ["Dbø7", "C#ø7"],
            Set<Int>([2, 5, 8, 0]): ["Dø7"],
            Set<Int>([3, 6, 9, 1]): ["Ebø7", "D#ø7"],
            Set<Int>([4, 7, 10, 2]): ["Eø7", "Fbø7"],
            Set<Int>([5, 8, 11, 3]): ["Fø7", "E#ø7"],
            Set<Int>([6, 9, 0, 4]): ["F#ø7", "Gbø7"],
            Set<Int>([7, 10, 1, 5]): ["Gø7"],
            Set<Int>([8, 11, 2, 6]): ["Abø7", "G#ø7"],
            Set<Int>([9, 0, 3, 7]): ["Aø7"],
            Set<Int>([10, 1, 4, 8]): ["Bbø7", "A#ø7"],
            Set<Int>([11, 2, 5, 9]): ["Bø7", "Cø7"],
            
            //  Fully Diminished 7th chords (When the bass note is known, simply replace the first character with that
            Set<Int>([0, 3, 6, 9]): ["o7"],
            Set<Int>([1, 4, 7, 10]): ["o7"],
            Set<Int>([2, 5, 8, 11]): ["o7"],
            
            //  French Augemented-Six chords
            Set<Int>([0, 4, 6, 10]): ["FrenchA6"],
            Set<Int>([1, 5, 7, 11]): ["FrenchA6"],
            Set<Int>([2, 6, 8, 0]): ["FrenchA6"],
            Set<Int>([3, 7, 9, 1]): ["FrenchA6"],
            Set<Int>([4, 8, 10, 2]): ["FrenchA6"],
            Set<Int>([5, 9, 11, 3]): ["FrenchA6"]
        ]
    }
    
    
}
