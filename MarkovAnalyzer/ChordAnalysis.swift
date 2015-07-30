//
//  ChordAnalysis.swift
//  MarkovAnalyzer
//
//  Created by Jess Hendricks on 7/25/15.
//  Copyright © 2015 Existential Music. All rights reserved.
//

import Cocoa

class ChordAnalysis: NSObject {
    
    //  MARK: class functions called without instantiating ChordAnalysis
    
    
    class func modTwelve(var number: Int) -> Int {
        number = number % 12
        if number < 0 {
            number = number + 12
        }
        return number
    }
    
    //  MARK: Instantiated functions
    
    func generateChordFromNotes(var notes: [Note]) -> [Chord] {
        var returnChords = [Chord]()
        if notes.count > 1 {
            notes = self.stackChordInThirds(notes)
            
        } else {
            
            for possibleNote in notes[0].enharmonicNoteNames {
                returnChords.append(Chord(chordName: possibleNote))
            }
            return returnChords
        }
        
        return returnChords
    }
    
    func stackChordInThirds(var notes: [Note]) -> [Note] {
        let thirdIntervals = [3, 4, 6, 7, 10, 11]
        var isStackedInThirds = false
        while !isStackedInThirds {
            notes = notes.sort({$0.noteNumber < $1.noteNumber})
            var intervalsChanged = false
            for index in 1..<notes.count {
                let interval = notes[index].noteNumber - notes[0].noteNumber
                if !thirdIntervals.contains(interval) {
                    notes[index].noteNumber = notes[index].noteNumber - 12
                    intervalsChanged = true
                }
            }
            if !intervalsChanged {
                isStackedInThirds = true
            }
        }
        return notes.sort({$0.noteNumber < $1.noteNumber})
    }
    
//    private func getChordsFromNotes(notes: [Note]) -> [Chord] {
//        var intervalList = [Int]()
//        var newChord = Chord(chordName: notes[0].noteName)
//        for index in 1..<notes.count {
//            //  TODO: Use intervals of stacked chord to get quality.
//        }
//        return []
//    }
    
    private func getChordForChordName(chordName: String, bassNote: Note) -> Chord {
        
        var bassNoteString = ""
        if bassNote.noteName.rangeOfString(chordName) == nil {
            bassNoteString = "/\(bassNote.noteName)"
        }
        return Chord(chordName: chordName + bassNoteString)
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
    
    private func getNoteFromNumber(noteNumber: Int) -> Note {
        let noteNumberMod = noteNumber % 12
        switch noteNumberMod {
        case 0:
            return Note(noteName: "C", noteNumber: noteNumber)
        case 1:
            return Note(noteName: "C#", noteNumber: noteNumber)
        case 2:
            return Note(noteName: "D", noteNumber: noteNumber)
        case 3:
            return Note(noteName: "Eb", noteNumber: noteNumber)
        case 4:
            return Note(noteName: "E", noteNumber: noteNumber)
        case 5:
            return Note(noteName: "F", noteNumber: noteNumber)
        case 6:
            return Note(noteName: "F#", noteNumber: noteNumber)
        case 7:
            return Note(noteName: "G", noteNumber: noteNumber)
        case 8:
            return Note(noteName: "Ab", noteNumber: noteNumber)
        case 9:
            return Note(noteName: "A", noteNumber: noteNumber)
        case 10:
            return Note(noteName: "Bb", noteNumber: noteNumber)
        default:
            return Note(noteName: "B", noteNumber: noteNumber)
        }
    }
    
    private func getNoteListFromNumber(noteNumber: Int) -> [Note] {
        let noteNumberMod = noteNumber % 12
        switch noteNumberMod {
        case 0:
            return [Note(noteName: "C", noteNumber: noteNumber), Note(noteName: "B#", noteNumber: noteNumber)]
        case 1:
            return [Note(noteName: "Db", noteNumber: noteNumber), Note(noteName: "C#", noteNumber: noteNumber)]
        case 2:
            return [Note(noteName: "D", noteNumber: noteNumber)]
        case 3:
            return [Note(noteName: "Eb", noteNumber: noteNumber), Note(noteName: "D#", noteNumber: noteNumber)]
        case 4:
            return [Note(noteName: "E", noteNumber: noteNumber), Note(noteName: "Fb", noteNumber: noteNumber)]
        case 5:
            return [Note(noteName: "F", noteNumber: noteNumber), Note(noteName: "E#", noteNumber: noteNumber)]
        case 6:
            return [Note(noteName: "Gb", noteNumber: noteNumber), Note(noteName: "F#", noteNumber: noteNumber)]
        case 7:
            return [Note(noteName: "G", noteNumber: noteNumber)]
        case 8:
            return [Note(noteName: "Ab", noteNumber: noteNumber), Note(noteName: "G#", noteNumber: noteNumber)]
        case 9:
            return [Note(noteName: "A", noteNumber: noteNumber)]
        case 10:
            return [Note(noteName: "Bb", noteNumber: noteNumber), Note(noteName: "A#", noteNumber: noteNumber)]
        default:
            return [Note(noteName: "B", noteNumber: noteNumber), Note(noteName: "Cb", noteNumber: noteNumber)]
        }
    }
}


//func generateChordFromNotes(notes: [Note]) -> (chords:[Chord], normalOrderSet:Set<Int>) {
//
//    var returnChords: [Chord]!
//    var reducedNotes = Set<Int>()
//    let bassNote = self.getBassNote(notes)
//    for note in notes {
//        reducedNotes.insert(note.noteNumber % 12)
//    }
//    var reducedNotesArray = [Note]()
//    for reducedNote in reducedNotes {
//        reducedNotesArray.append(self.getNoteFromNumber(reducedNote))
//    }
//    let normalOrderSet = self.getNormalOrder(reducedNotesArray)
//    var testNoteSet = normalOrderSet.notes
//    var transposeNumber = 0
//    var returnChord = Chord(chordName: "N/A")
//    for _ in 0..<12 {
//        if self.chordQualities[normalOrderSet.noteNumbers] != nil {
//            returnChord  = self.getChordForChordName(normalOrderSet.notes[transposeNumber].noteName + self.chordQualities[normalOrderSet.noteNumbers]!, bassNote: bassNote)
//            break
//        }
//        transposeNumber++
//        testNoteSet = self.transposeByInterval(transposeNumber, notes: testNoteSet)
//    }
//
//
//    if returnChords == nil {
//        returnChords = [Chord(chordName: "N/A")]
//    }
//    return ([returnChord], normalOrderSet.noteNumbers)
//}

//        self.triadNames = [
//
//            //  Triads
//            Set<Int>([0, 4, 7]): ["C", "B#"],
//            Set<Int>([0, 3, 7]): ["Cm", "B#m"],
//            Set<Int>([0, 3, 6]): ["Co", "B#o"],
//            Set<Int>([0, 4, 8]): ["C+", "E+", "G#+", "Ab+"],
//
//            Set<Int>([1, 5, 8]): ["Db", "C#"],
//            Set<Int>([1, 4, 8]): ["Dbm", "C#m"],
//            Set<Int>([1, 4, 7]): ["Dbo", "C#o"],
//            Set<Int>([1, 5, 9]): ["Db+", "C#+", "F+", "A+"],
//
//            Set<Int>([2, 6, 9]): ["D"],
//            Set<Int>([2, 5, 9]): ["Dm"],
//            Set<Int>([2, 5, 8]): ["Do"],
//            Set<Int>([2, 6, 10]): ["D+", "F#+", "Gb+", "A#+", "Bb+"],
//
//            Set<Int>([3, 7, 10]): ["Eb", "D#"],
//            Set<Int>([3, 6, 10]): ["Ebm", "D#m"],
//            Set<Int>([3, 6, 9]): ["Ebo", "D#o"],
//            Set<Int>([3, 7, 11]): ["Eb+", "D#+", "G+", "B+"],
//
//            Set<Int>([4, 8, 11]): ["E", "Fb"],
//            Set<Int>([4, 7, 11]): ["Em", "Fbm"],
//            Set<Int>([4, 7, 10]): ["Eo", "Fbo"],
//
//            Set<Int>([0, 5, 9]): ["F", "E#"],
//            Set<Int>([0, 5, 8]): ["Fm", "E#m"],
//            Set<Int>([5, 8, 11]): ["Fo", "E#o"],
//
//            Set<Int>([1, 6, 10]): ["Gb", "F#"],
//            Set<Int>([1, 6, 9]): ["Gbm", "F#m"],
//            Set<Int>([0, 6, 9]): ["Gbo", "F#o"],
//
//            Set<Int>([2, 7, 11]): ["G"],
//            Set<Int>([2, 7, 10]): ["Gm"],
//            Set<Int>([1, 7, 10]): ["Go"],
//
//            Set<Int>([0, 3, 8]): ["Ab", "G#"],
//            Set<Int>([3, 8, 11]): ["Abm", "G#m"],
//            Set<Int>([2, 8, 11]): ["Abo", "G#o"],
//
//            Set<Int>([1, 4, 9]): ["A"],
//            Set<Int>([0, 4, 9]): ["Am"],
//            Set<Int>([0, 3, 9]): ["Ao"],
//
//            Set<Int>([2, 5, 10]): ["Bb", "A#"],
//            Set<Int>([1, 5, 10]): ["Bbm", "A#m"],
//            Set<Int>([1, 4, 10]): ["Bbo", "A#o"],
//
//            Set<Int>([3, 6, 11]): ["B", "Cb"],
//            Set<Int>([2, 6, 11]): ["Bm", "Cbm"],
//            Set<Int>([2, 5, 11]): ["Bo", "Cbo"],
//
//            //  Italian Augemented-Six chords or Dominant seventh without fifth
//
//            Set<Int>([0, 4, 10]): ["C7", "B#7", "ItaA6"],
//            Set<Int>([1, 5, 11]): ["Db7", "C#7", "ItaA6"],
//            Set<Int>([2, 6, 0]): ["D7", "ItaA6"],
//            Set<Int>([3, 7, 1]): ["Eb7", "D#7", "ItaA6"],
//            Set<Int>([4, 8, 2]): ["E7", "Fb7", "ItaA6"],
//            Set<Int>([5, 9, 3]): ["F7", "E#7", "ItaA6"],
//            Set<Int>([6, 10, 4]): ["Gb7", "F#7", "ItaA6"],
//            Set<Int>([7, 11, 5]): ["G7", "ItaA6"],
//            Set<Int>([8, 0, 6]): ["Ab7", "G#7", "ItaA6"],
//            Set<Int>([9, 1, 7]): ["A7", "ItaA6"],
//            Set<Int>([10, 2, 8]): ["Bb7", "A#7", "ItaA6"],
//            Set<Int>([11, 3, 9]): ["B7", "Cb7", "ItaA6"]
//        ]
//
//
//        self.seventhChordNames = [
//            //  Seventh Chords Standard
//            Set<Int>([0, 3, 7, 10]): ["Cm7", "B#m7"],
//            Set<Int>([0, 3, 7, 11]): ["CmM7", "B#mM7"],
//            Set<Int>([0, 4, 7, 10]): ["C7", "B#7", "GerA6"],
//            Set<Int>([0, 4, 7, 11]): ["Cmaj7", "B#maj7"],
//
//            Set<Int>([1, 4, 8, 11]): ["Dbm7", "C#m7"],
//            Set<Int>([1, 4, 8, 0]): ["DbmM7", "C#mM7"],
//            Set<Int>([1, 5, 8, 11]): ["Db7", "C#7", "GerA6"],
//            Set<Int>([1, 5, 8, 0]): ["Dbmaj7", "C#maj7"],
//
//            Set<Int>([2, 5, 9, 0]): ["Dm7"],
//            Set<Int>([2, 5, 9, 1]): ["DmM7"],
//            Set<Int>([2, 6, 9, 0]): ["D7"],
//            Set<Int>([2, 6, 9, 1]): ["Dmaj7"],
//
//            Set<Int>([3, 6, 10, 1]): ["Ebm7", "D#m7"],
//            Set<Int>([3, 6, 10, 2]): ["EbmM7", "D#mM7"],
//            Set<Int>([3, 7, 10, 1]): ["Eb7", "D#7", "GerA6"],
//            Set<Int>([3, 7, 10, 2]): ["Ebmaj7", "D#maj7"],
//
//            Set<Int>([4, 7, 11, 2]): ["Em7", "Fbm7"],
//            Set<Int>([4, 7, 11, 3]): ["EmM7", "FbmM7"],
//            Set<Int>([4, 8, 11, 2]): ["E7", "Fb7", "GerA6"],
//            Set<Int>([4, 8, 11, 3]): ["Emaj7", "Fbmaj7"],
//
//            Set<Int>([5, 8, 0, 3]): ["Fm7", "E#m7"],
//            Set<Int>([5, 8, 0, 4]): ["FmM7", "E#mM7"],
//            Set<Int>([5, 9, 0, 3]): ["F7", "E#7", "GerA6"],
//            Set<Int>([5, 9, 0, 4]): ["Fmaj7", "Emaj7"],
//
//            Set<Int>([6, 9, 1, 4]): ["Gbm7", "F#m7"],
//            Set<Int>([6, 9, 1, 5]): ["GbmM7", "F#mM7"],
//            Set<Int>([6, 10, 1, 4]): ["Gb7", "F#7", "GerA6"],
//            Set<Int>([6, 10, 1, 5]): ["Gbmaj7", "F#maj7"],
//
//            Set<Int>([7, 10, 2, 5]): ["Gm7"],
//            Set<Int>([7, 10, 2, 6]): ["GmM7"],
//            Set<Int>([7, 11, 2, 5]): ["G7", "GerA6"],
//            Set<Int>([7, 11, 2, 6]): ["Gmaj7"],
//
//            Set<Int>([8, 11, 3, 6]): ["Abm7", "G#m7"],
//            Set<Int>([8, 11, 3, 7]): ["AbmM7", "G#mM7"],
//            Set<Int>([8, 0, 3, 6]): ["Ab7", "G#7", "GerA6"],
//            Set<Int>([8, 0, 3, 7]): ["Abmaj7", "G#maj7"],
//
//            Set<Int>([9, 0, 4, 7]): ["Am7"],
//            Set<Int>([9, 0, 4, 8]): ["AmM7"],
//            Set<Int>([9, 1, 4, 7]): ["A7", "GerA6"],
//            Set<Int>([9, 1, 4, 8]): ["Amaj7"],
//
//            Set<Int>([10, 1, 5, 8]): ["Bbm7", "A#m7"],
//            Set<Int>([10, 1, 5, 9]): ["BbmM7", "A#mM7"],
//            Set<Int>([10, 2, 5, 8]): ["Bb7", "A#7", "GerA6"],
//            Set<Int>([10, 2, 5, 9]): ["Bbmaj7", "A#maj7"],
//
//            Set<Int>([11, 2, 6, 9]): ["Em7", "Fbm7"],
//            Set<Int>([11, 2, 6, 10]): ["EmM7", "FbmM7"],
//            Set<Int>([11, 3, 6, 9]): ["E7", "Fb7", "GerA6"],
//            Set<Int>([11, 3, 6, 10]): ["Emaj7", "Fbmaj7"],
//
//            //  Half Diminished 7th chords
//            Set<Int>([0, 3, 6, 10]): ["Cø7", "B#ø7"],
//            Set<Int>([1, 4, 7, 11]): ["Dbø7", "C#ø7"],
//            Set<Int>([2, 5, 8, 0]): ["Dø7"],
//            Set<Int>([3, 6, 9, 1]): ["Ebø7", "D#ø7"],
//            Set<Int>([4, 7, 10, 2]): ["Eø7", "Fbø7"],
//            Set<Int>([5, 8, 11, 3]): ["Fø7", "E#ø7"],
//            Set<Int>([6, 9, 0, 4]): ["F#ø7", "Gbø7"],
//            Set<Int>([7, 10, 1, 5]): ["Gø7"],
//            Set<Int>([8, 11, 2, 6]): ["Abø7", "G#ø7"],
//            Set<Int>([9, 0, 3, 7]): ["Aø7"],
//            Set<Int>([10, 1, 4, 8]): ["Bbø7", "A#ø7"],
//            Set<Int>([11, 2, 5, 9]): ["Bø7", "Cø7"],
//
//            //  Fully Diminished 7th chords (When the bass note is known, simply replace the first character with that
//            Set<Int>([0, 3, 6, 9]): ["o7"],
//            Set<Int>([1, 4, 7, 10]): ["o7"],
//            Set<Int>([2, 5, 8, 11]): ["o7"],
//
//            //  French Augemented-Six chords
//            Set<Int>([0, 4, 6, 10]): ["FrenchA6"],
//            Set<Int>([1, 5, 7, 11]): ["FrenchA6"],
//            Set<Int>([2, 6, 8, 0]): ["FrenchA6"],
//            Set<Int>([3, 7, 9, 1]): ["FrenchA6"],
//            Set<Int>([4, 8, 10, 2]): ["FrenchA6"],
//            Set<Int>([5, 9, 11, 3]): ["FrenchA6"]
//        ]
//  MARK: Chord Pitch Sets

//        self.chordQualities = [
//            Set<Int>([0]):                      "",
//            Set<Int>([7, 0]):                   "5",
//            Set<Int>([0, 4]):                   "",
//            Set<Int>([0, 3]):                   "m",
//            Set<Int>([0, 4, 7]):                "",
//            Set<Int>([0, 3, 7]):                "m",
//            Set<Int>([0, 3, 6]):                "dim",
//            Set<Int>([0, 4, 8]):                "aug",
//            Set<Int>([10, 0, 4]):               "7",
//            Set<Int>([7, 10, 0]):               "7",
//            Set<Int>([4, 7, 10, 0]):            "7",
//            Set<Int>([11, 0, 4, 7]):            "maj7",
//            Set<Int>([7, 10, 0, 3]):            "m7",
//            Set<Int>([11, 0, 3, 7]):            "m(maj7)",
//            Set<Int>([10, 0, 3, 6]):            "ø7",
//            Set<Int>([0, 3, 6, 9]):             "º7",
//            Set<Int>([0, 2, 4, 7]):             "9",
//            Set<Int>([0, 1, 4, 7]):             "7b9",
//            Set<Int>([0, 2, 3, 7]):             "m9",
//            Set<Int>([0, 1, 3, 7]):             "m7b9",
//            Set<Int>([10, 0, 2, 4, 7]):         "9",
//            Set<Int>([11, 0, 2, 4, 7]):         "maj9",
//            Set<Int>([10, 0, 1, 4, 7]):         "7b9",
//            Set<Int>([7, 10, 0, 2, 3]):         "m9",
//            Set<Int>([7, 10, 0, 1, 3]):         "m7b9",
//            Set<Int>([11, 0, 2, 3, 6]):         "m(maj9)",
//            Set<Int>([11, 0, 2, 3, 7]):         "m(maj7)9",
//            Set<Int>([11, 0, 1, 3, 7]):         "m(maj7)b9",
//            Set<Int>([4, 6, 10, 0]):            "FrenchA6"
//        ]

//This version is in order to see if there might be a trick for 7ths , 9ths, 11ths, etc.
//                self.chordQualities = [
//
//                    Set<Int>([0, 4, 7]):                  "",
//                    Set<Int>([0, 3, 7]):                  "m",
//                    Set<Int>([0, 3, 6]):                  "dim",
//                    Set<Int>([0, 4, 8]):                  "aug",
//                    Set<Int>([0, 4, 10]):                 "7",
//                    Set<Int>([0, 7, 10]):                 "7",
//                    Set<Int>([0, 4, 7, 10]):              "7",
//                    Set<Int>([0, 4, 7, 11]):              "maj7",
//                    Set<Int>([0, 3, 7, 10]):              "m7",
//                    Set<Int>([0, 3, 7, 11]):              "m(maj7)",
//                    Set<Int>([0, 3, 6, 10]):              "ø7",
//                    Set<Int>([0, 3, 6, 9]):               "º7",
//                    Set<Int>([0, 2, 4, 7]):               "9",
//                    Set<Int>([0, 1, 4, 7]):               "7b9",
//                    Set<Int>([0, 2, 3, 7]):               "m9",
//                    Set<Int>([0, 1, 3, 7]):               "m7b9",
//                    Set<Int>([0, 2, 4, 7, 10]):           "9",
//                    Set<Int>([0, 2, 4, 7, 11]):           "maj9",
//                    Set<Int>([0, 1, 4, 7, 10]):           "7b9",
//                    Set<Int>([0, 2, 3, 7, 10]):           "m9",
//                    Set<Int>([0, 1, 3, 7, 10]):           "m7b9",
//                    Set<Int>([0, 2, 3, 6, 11]):           "m(maj9)",
//                    Set<Int>([0, 2, 3, 7, 11]):           "m(maj7)9",
//                    Set<Int>([0, 1, 3, 7, 11]):           "m(maj7)b9",
//                    Set<Int>([0, 1, 3, 7, 11]):           "mM7b9",
//                    Set<Int>([4, 6, 10, 0]):              "FrenchA6"
//                ]

//private func getNormalOrder(notes: [Note]) -> (notes: [Note], noteNumbers: Set<Int>) {
//    var sortedPitchSet = notes.sort({$0.noteNumber < $1.noteNumber})
//    if sortedPitchSet.count > 1 {
//        var pitchSetPermutations = [[Note]]()
//        pitchSetPermutations.append(sortedPitchSet)
//        for index in 1..<sortedPitchSet.count {
//            pitchSetPermutations.append(self.rotatePitchSet(pitchSetPermutations[index - 1]))
//        }
//        func compareNormalOrders (pitchSet1: [Note], pitchSet2: [Note]) -> [Note] {
//            var indexToCheck = sortedPitchSet.count - 1
//
//            while indexToCheck != 0 {
//                var checkedPitchSet1 = pitchSet1[indexToCheck].noteNumber - pitchSet1[0].noteNumber
//                var checkedPitchSet2 = pitchSet2[indexToCheck].noteNumber - pitchSet2[0].noteNumber
//                checkedPitchSet1 = self.modTwelve(checkedPitchSet1)
//                checkedPitchSet2 = self.modTwelve(checkedPitchSet2)
//                if checkedPitchSet1 == checkedPitchSet2 {
//                    if indexToCheck == 1 {
//                        if pitchSet1[0].noteNumber < pitchSet2[0].noteNumber {
//                            return pitchSet1
//                        } else {
//                            return pitchSet2
//                        }
//                    }
//                }
//                if checkedPitchSet1 < checkedPitchSet2 {
//                    return pitchSet1
//                }
//                if checkedPitchSet1 > checkedPitchSet2 {
//                    return pitchSet2
//                }
//                indexToCheck--
//            }
//            return sortedPitchSet
//        }
//        for index in 1..<pitchSetPermutations.count {
//            sortedPitchSet = compareNormalOrders(sortedPitchSet, pitchSet2: pitchSetPermutations[index])
//        }
//    }
//    var noteNumbers = Set<Int>()
//    for note in sortedPitchSet {
//        noteNumbers.insert(note.noteNumber)
//    }
//    return (sortedPitchSet, noteNumbers)
//}
//
//private func transposeByInterval(interval: Int, notes: [Note]) -> [Note] {
//    for var note in notes {
//        note.noteNumber = modTwelve(note.noteNumber + interval)
//        note = self.getNoteFromNumber(note.noteNumber)
//    }
//    return notes
//}
//
//
//private func rotatePitchSet(notes: [Note]) -> [Note] {
//    var rotatedPitchSet = notes
//    if rotatedPitchSet.count > 1 {
//        rotatedPitchSet.insert(rotatedPitchSet.last!, atIndex: 0)
//        rotatedPitchSet.removeLast()
//    }
//    return rotatedPitchSet
//}


