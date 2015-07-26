//
//  MusicConstants.swift
//  MarkovAn
//  These are a set of constants for Int values related to notes, chords, and keys.
//
//  Created by Fupduck Central MBP on 5/28/15.
//  Copyright (c) 2015 Existential Music. All rights reserved.
//

import Foundation



struct Note: Hashable {
    var noteName: String!
    var noteNumber: Int!
    init(noteName: String, noteNumber: Int) {
        self.noteName = noteName
        self.noteNumber = noteNumber
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

struct KeySignature: Hashable {
    var keyName: String!
    init(keyName: String) {
        self.keyName = keyName
    }
    var hashValue: Int {
        return self.keyName.hashValue
    }
}
func == (keyA: KeySignature, keyB: KeySignature) -> Bool {
    return keyA.keyName == keyB.keyName
}

struct Harmony {
    var romanNumeral: String!
    var possibleProgressions: [Harmony]!
}
func == (harmonyA: Harmony, harmonyB: Harmony) -> Bool {
    return harmonyA.romanNumeral == harmonyB.romanNumeral
}

//
//   MARK: Notes -
//      with value between 0 and 11 (String, Int)
//
let kCDblFlatNote   =   Note(noteName: "Cbb", noteNumber: 58)
let kCFlatNote      =   Note(noteName: "Cb", noteNumber: 59)
let kCNote          =   Note(noteName: "C", noteNumber: 60)
let kCSharpNote     =   Note(noteName: "C#", noteNumber: 61)
let kCDblSharpNote  =   Note(noteName: "C##", noteNumber: 62)
let kDDblFlatNote   =   Note(noteName: "Dbb", noteNumber: 60)
let kDFlatNote      =   Note(noteName: "Db", noteNumber: 61)
let kDNote          =   Note(noteName: "D", noteNumber: 62)
let kDSharpNote     =   Note(noteName: "D#", noteNumber: 63)
let kDDblSharpNote  =   Note(noteName: "D##", noteNumber: 64)
let kEDblFlatNote   =   Note(noteName: "Ebb", noteNumber: 62)
let kEFlatNote      =   Note(noteName: "Eb", noteNumber: 63)
let kENote          =   Note(noteName: "E", noteNumber: 64)
let kESharpNote     =   Note(noteName: "E#", noteNumber: 65)
let kFFlatNote      =   Note(noteName: "Fb", noteNumber: 64)
let kFNote          =   Note(noteName: "F", noteNumber: 65)
let kFSharpNote     =   Note(noteName: "F#", noteNumber: 66)
let kFDblSharpNote  =   Note(noteName: "F##", noteNumber: 67)
let kGDblFlatNote   =   Note(noteName: "Gbb", noteNumber: 65)
let kGFlatNote      =   Note(noteName: "Gb", noteNumber: 66)
let kGNote          =   Note(noteName: "G", noteNumber: 67)
let kGSharpNote     =   Note(noteName: "G#", noteNumber: 68)
let kGDblSharpNote  =   Note(noteName: "G##", noteNumber: 69)
let kAFlatNote      =   Note(noteName: "Ab", noteNumber: 68)
let kADblFlatNote   =   Note(noteName: "Abb", noteNumber: 67)
let kANote          =   Note(noteName: "A", noteNumber: 69)
let kASharpNote     =   Note(noteName: "A#", noteNumber: 70)
let kADblSharpNote  =   Note(noteName: "A##", noteNumber: 71)
let kBDblFlatNote   =   Note(noteName: "Bbb", noteNumber: 69)
let kBFlatNote      =   Note(noteName: "Bb", noteNumber: 70)
let kBNote          =   Note(noteName: "B", noteNumber: 71)
let kBSharpNote     =   Note(noteName: "B#", noteNumber: 72)

//  MARK: - Chord Qualities
//  MARK: ... Triads
//let kMajor          =   [0, 4, 7]
//let kMinor          =   [0, 3, 7]
//let kDim            =   [0, 3, 6]
//let kAug            =   [0, 4, 8]

//  MARK: ... Seventh Chords
//let kMajorM7        =   [0, 4, 7, 11]
//let kDominant7      =   [0, 4, 7, 10]
//let kMinorMinor7    =   [0, 3, 7, 10]
//let kMinorM7        =   [0, 3, 7, 11]
//let kAugM7          =   [0, 4, 8, 11]
//let kAugMinor7      =   [0, 4, 8, 10]
//let kHalfDim7       =   [0, 3, 6, 10]
//let kFullDim7       =   [0, 3, 6, 9]

//  MARK: ... Augmented Six Chords
//let kItalianAug6    =   [0, 4, 10]
//let kFrenchAug6     =   [0, 4, 6, 10]
//let kGermanAug6     =   [0, 4, 7, 10]

//  MARK:   - Specific Chords

//let kC = Chord(chordName: "C", notes: [kCNote, kENote, kGNote], bassNote: kCNote, possibleAnalyses: ["C":"I", "Dm": "VII", "Em": "VI", "F": "V", "G": "IV", "Am": "III", "B": "N", "Bm": "N"])
//let kC6 = Chord(chordName: "C/E", notes: [kCNote, kENote, kGNote], bassNote: kENote, possibleAnalyses: ["C":"I6", "Dm": "VII6", "Em": "VI6", "F": "V6", "G": "IV6", "Am": "III6", "B": "N6", "Bm": "N6"])
//let kC64 = Chord(chordName: "C/G", notes: [kCNote, kENote, kGNote], bassNote: kGNote, possibleAnalyses: ["C": "V64"])
//let kCm = Chord(chordName: "Cm", notes: [kCNote, kEFlatNote, kGNote], bassNote: kCNote, possibleAnalyses: ["Cm":"i", "Eb": "vi", "Gm": "iv", "Ab": "iii", "Bb": "ii"])
//let kCm6 = Chord(chordName: "Cm/Eb", notes: [kCNote, kEFlatNote, kGNote], bassNote: kEFlatNote, possibleAnalyses: ["Cm":"i6", "Eb": "vi6", "Gm": "iv6", "Ab": "iii6", "Bb": "ii6"])
//let kCm64 = Chord(chordName: "Cm/G", notes: [kCNote, kEFlatNote, kGNote], bassNote: kGNote, possibleAnalyses: ["Cm": "V64"])
//let kCdim = Chord(chordName: "Cdim", notes: [kCNote, kEFlatNote, kGFlatNote], bassNote: kCNote, possibleAnalyses: ["Db":"viio", "Dbm": "viio", "Bbm": "iio"])
//let kCdim6 = Chord(chordName: "Cdim6", notes: [kCNote, kEFlatNote, kGFlatNote], bassNote: kEFlatNote, possibleAnalyses: ["Db":"viio6", "Dbm": "viio6", "Bbm": "iio6"])
//let kCAug = Chord(chordName: "C+", notes: [kCNote, kENote, kGSharpNote], bassNote: kCNote, possibleAnalyses: ["Am": "III+"])
//
//let kC7 = Chord(chordName: "C7", notes: [kCNote, kENote, kGNote, kBFlatNote], bassNote: kCNote, possibleAnalyses: ["C":"V7/IV", "Dm": "V7/III", "F": "V7", "G": "V7/VII", "Am": "V7/VI"])
//let kC65 = Chord(chordName: "C7/E", notes: [kCNote, kENote, kGNote, kBFlatNote], bassNote: kENote, possibleAnalyses: ["C":"V65/IV", "Dm": "V65/III", "F": "V65", "G": "V65/VII", "Am": "V65/VI"])
//let kC43 = Chord(chordName: "C7/G", notes: [kCNote, kENote, kGNote, kBFlatNote], bassNote: kGNote, possibleAnalyses: ["C":"V43/IV", "Dm": "V43/III", "F": "V43", "G": "V43/VII", "Am": "V43/VI"])
//let kC42 = Chord(chordName: "C7/Bb", notes: [kCNote, kENote, kGNote, kBFlatNote], bassNote: kBFlatNote, possibleAnalyses: ["C":"V42/IV", "Dm": "V42/III", "F": "V42", "G": "V42/VII", "Am": "V42/VI"])
//let kCM7 = Chord(chordName: "Cmaj7", notes: [kCNote, kENote, kGNote, kBNote], bassNote: kCNote, possibleAnalyses: ["C":"I7", "Dm": "VII7", "Em": "VI7", "G": "IV7", "Am": "III7"])
//let kCM65 = Chord(chordName: "Cmaj7/E", notes: [kCNote, kENote, kGNote, kBNote], bassNote: kENote, possibleAnalyses: ["C":"I65", "Dm": "VII65", "Em": "VI65", "G": "IV65", "Am": "III65"])
//let kCM43 = Chord(chordName: "Cmaj7/G", notes: [kCNote, kENote, kGNote, kBNote], bassNote: kGNote, possibleAnalyses: ["C":"I43", "Dm": "VII43", "Em": "VI43", "G": "IV43", "Am": "III43"])
//let kCM42 = Chord(chordName: "Cmaj7/B", notes: [kCNote, kENote, kGNote, kBNote], bassNote: kBNote, possibleAnalyses: ["C":"I42", "Dm": "VII42", "Em": "VI42", "G": "IV42", "Am": "III42"])
//let kCm7 = Chord(chordName: "Cm7", notes: [kCNote, kEFlatNote, kGNote, kBFlatNote], bassNote: kCNote, possibleAnalyses: ["Cm":"i7", "Eb": "vi7", "Gm": "iv7", "Ab": "iii7", "Bb": "ii7"])
//let kCm65 = Chord(chordName: "Cm7/Eb", notes: [kCNote, kEFlatNote, kGNote, kBFlatNote], bassNote: kEFlatNote, possibleAnalyses: ["Cm":"i65", "Eb": "vi65", "Gm": "iv65", "Ab": "iii65", "Bb": "ii65"])
//let kCm43 = Chord(chordName: "Cm7/G", notes: [kCNote, kEFlatNote, kGNote, kBFlatNote], bassNote: kGNote, possibleAnalyses: ["Cm": "V43"])
//let kCm42 = Chord(chordName: "Cm7/Bb", notes: [kCNote, kEFlatNote, kGNote, kBFlatNote], bassNote: kBFlatNote, possibleAnalyses: ["Cm":"i42", "Eb": "vi42", "Gm": "iv42", "Ab": "iii42", "Bb": "ii42"])
//let kChalfDim7 = Chord(chordName: "Cø7", notes: [kCNote, kEFlatNote, kGFlatNote, kBFlatNote], bassNote: kCNote, possibleAnalyses: ["Db":"viiø7", "Dbm": "viiø7", "Bbm": "iiø7"])
//let kChalfDim65 = Chord(chordName: "Cø65", notes: [kCNote, kEFlatNote, kGFlatNote, kBFlatNote], bassNote: kEFlatNote, possibleAnalyses: ["Db":"viiø65", "Dbm": "viiø65", "Bbm": "iiø65"])
//let kChalfDim43 = Chord(chordName: "Cø43", notes: [kCNote, kEFlatNote, kGFlatNote, kBFlatNote], bassNote: kGFlatNote, possibleAnalyses: ["Db":"viiø43", "Dbm": "viiø43", "Bbm": "iiø43"])
//let kChalfDim42 = Chord(chordName: "Cø42", notes: [kCNote, kEFlatNote, kGFlatNote, kBFlatNote], bassNote: kBFlatNote, possibleAnalyses: ["Db":"viiø42", "Dbm": "viiø42", "Bbm": "iiø42"])
//let kCdim7 = Chord(chordName: "Co7", notes: [kCNote, kEFlatNote, kGFlatNote, kBDblFlatNote], bassNote: kCNote, possibleAnalyses: ["Db":"viio7", "Dbm": "viio7"])
//let kCdim65 = Chord(chordName: "Co65", notes: [kCNote, kEFlatNote, kGFlatNote, kBDblFlatNote], bassNote: kEFlatNote, possibleAnalyses: ["Db":"viio65", "Dbm": "viio65"])
//let kCdim43 = Chord(chordName: "Co43", notes: [kCNote, kEFlatNote, kGFlatNote, kBDblFlatNote], bassNote: kGFlatNote, possibleAnalyses: ["Db":"viio43", "Dbm": "viio43"])
//let kCdim42 = Chord(chordName: "Co42", notes: [kCNote, kEFlatNote, kGFlatNote, kBDblFlatNote], bassNote: kBDblFlatNote, possibleAnalyses: ["Db":"viio42", "Dbm": "viio42"])
//
//let kCMaj7      =   ("Cmaj7", [kCNote, kENote, kGNote, kBNote])
//let kC7         =   ("C7", [kCNote, kENote, kGNote, kBFlatNote])
//let kCm7        =   ("Cm7", [kCNote, kEFlatNote, kGNote, kBFlatNote])
//let kCmM7       =   ("CmM7", [kCNote, kEFlatNote, kGNote, kBNote])
//let kCAugM7     =   ("CaugM7", [kCNote, kENote, kGSharpNote, kBNote])
//let kCAugMinor7 =   ("CaugMinor7", [kCNote, kENote, kGSharpNote, kBFlatNote])
//let kCdim7      =   ("C diminished 7", [kCNote, kEFlatNote, kGFlatNote, kCDblFlatNote])
//let kChalfDim7  =   ("C half-diminished 7", [kCNote, kEFlatNote, kGFlatNote, kBFlatNote])
//
//let kCItalianAug6       =       ("C Italian Aug 6", [kCNote, kENote, kASharpNote])
//let kCFrenchAug6       =       ("C Italian Aug 6", [kCNote, kENote, kASharpNote])
//let kCGermanAug6       =       ("C Italian Aug 6", [kCNote, kENote, kASharpNote])

//let keyCMajor = KeySignature(keyName: "C major")
//let keyCMinor = KeySignature(keyName: "c minor")
//let ketCSharpMajor = KeySignature


