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
    internal private(set) var enharmonicChordNames = [String]()
    var romanNumeral: String = "I"
    var keySig: KeySignature = KeySignature(keyName: "C major")
    
    internal private(set) var root: Note!
    internal private(set) var third: Note?
    internal private(set) var fifth: Note?
    internal private(set) var seventh: Note?
    internal private(set) var ninth: Note?
    internal private(set) var eleventh: Note?
    internal private(set) var thirteenth: Note?
    
    internal private(set) var bass: Note!
    
    
    //  Note values
    internal private(set) var chordMembers = [Note]()
    internal private(set) var stackedChordMembers = [Note]()
    
    init(root: Note,
        third: Note? = nil,
        fifth: Note? = nil,
        seventh: Note? = nil,
        ninth: Note? = nil,
        eleventh: Note? = nil,
        thirteenth: Note? = nil,
        bassNote: Note)
    {
        self.root = root
        self.third = third
        self.fifth = fifth
        self.seventh = seventh
        self.ninth = ninth
        self.eleventh = eleventh
        self.thirteenth = thirteenth
        self.bass = bassNote
        self.chordConnections = [Chord: Int]()
        self.setChordNameFromMembers()

    }
    
    init(notes: [Note]) {
        self.bass = self.findLowestNote(notes)
        self.stackChordInThirds(notes)
        self.setChordNameFromMembers()
        self.chordConnections = [Chord: Int]()
        print("********\tStack notes: ")
        for nextNote in self.stackedChordMembers {
            print("\(nextNote.noteName): \t\t\(nextNote.noteNumber)")
        }
    }
    
    init() {
        self.chordConnections = [Chord: Int]()
    }
    
//    init(chordName: String, romanNumeral: String? = nil) {
//        self.chordName = chordName
//        if romanNumeral != nil {
//            self.romanNumeral = romanNumeral!
//        }
//        self.chordConnections = [Chord: Int]()
//    }
    
    var hashValue: Int {
        return self.chordName.hashValue
    }
    
    func selectEnharmonic(chordName: String) {
        if let selectedEnharmonicIndex = self.enharmonicChordNames.indexOf(chordName) {
            self.chordName = self.enharmonicChordNames[selectedEnharmonicIndex]
        }
    }
    
    private func stackChordInThirds(notes: [Note])
    {
        self.chordMembers = notes
        var mutableNotes = [Note]()
        for note in notes {
            mutableNotes.append(Note(noteNumber: note.noteNumber))
        }
        let thirdIntervals = [3, 4, 6, 7, 10, 11]
        var isStackedInThirds = false
        while !isStackedInThirds {
            mutableNotes = mutableNotes.sort({$0.noteNumber < $1.noteNumber})
            var intervalsChanged = false
            for index in 1..<mutableNotes.count {
                let interval = mutableNotes[index].noteNumber - mutableNotes[index - 1].noteNumber
                if !thirdIntervals.contains(interval) {
                    mutableNotes[index].noteNumber = mutableNotes[index].noteNumber - 12
                    intervalsChanged = true
                    break
                }
            }
            if !intervalsChanged {
                isStackedInThirds = true
            }
        }
        
        //  Set individual chord members
        self.root = mutableNotes[0]
        for index in 1..<mutableNotes.count {
            
            let note = mutableNotes[index]
            let interval = note.noteNumber - self.root.noteNumber
            switch interval {
            case 3, 4:
                self.third = self.chordMembers[self.chordMembers.indexOf(note)!]
            case 6, 7, 8:
                self.fifth = self.chordMembers[self.chordMembers.indexOf(note)!]
            case 9, 10, 11:
                self.seventh = self.chordMembers[self.chordMembers.indexOf(note)!]
            case 13, 14, 15:
                self.ninth = self.chordMembers[self.chordMembers.indexOf(note)!]
            case 16, 17, 18:
                if self.third == nil && interval == 16 {
                    self.third = self.chordMembers[self.chordMembers.indexOf(note)!]
                } else {
                    self.eleventh = self.chordMembers[self.chordMembers.indexOf(note)!]
                }
            default:
                self.thirteenth = self.chordMembers[self.chordMembers.indexOf(note)!]
            }
        }
        self.stackedChordMembers = mutableNotes
    }
    
    
    private func setChordNameFromMembers() {
        var suffix = ""
        let rootNoteNumber = self.stackedChordMembers[self.stackedChordMembers.indexOf(self.root)!].noteNumber
        var thirdNoteNumber: Int!
        var fifthNoteNumber: Int!
        var seventhNoteNumber: Int!
        var ninthNoteNumber: Int!
        var eleventhNoteNumber: Int!
        var thirteenthNoteNumber: Int!
        var baseChordNames = [String]()
        //  Create suffix for triad
        if self.third != nil {
            thirdNoteNumber = self.stackedChordMembers[self.stackedChordMembers.indexOf(self.third!)!].noteNumber
            if self.fifth != nil {
                fifthNoteNumber = self.stackedChordMembers[self.stackedChordMembers.indexOf(self.fifth!)!].noteNumber
                if ((thirdNoteNumber - rootNoteNumber == 3) && (fifthNoteNumber - rootNoteNumber == 7)) {
                    suffix = suffix + "m"
                    baseChordNames = self.createBaseChordNames(suffix)
                } else if ((thirdNoteNumber - rootNoteNumber == 3) && (fifthNoteNumber - rootNoteNumber == 6)) {
                    suffix = suffix + "dim"
                    baseChordNames = self.createBaseChordNames(suffix)
                } else if ((thirdNoteNumber - rootNoteNumber == 4) && (fifthNoteNumber - rootNoteNumber == 8)) {
                    suffix = suffix + "+"
                    baseChordNames = self.createBaseChordNames(suffix)
                } else if ((thirdNoteNumber - rootNoteNumber == 16) && (fifthNoteNumber - rootNoteNumber == 6) && self.seventh != nil) {
                    if self.seventh!.noteNumber - rootNoteNumber == 10 {
                        suffix = "7b5"
                    } else if self.seventh!.noteNumber - rootNoteNumber == 11 {
                        suffix = "maj7b5"
                    }
                    baseChordNames = self.createBaseChordNames("")
                } else {
                    baseChordNames = self.createBaseChordNames("")
                }
            } else {
                if thirdNoteNumber - rootNoteNumber == 3 {
                    suffix = suffix + "m"
                    baseChordNames = self.createBaseChordNames(suffix)
                } else {
                    baseChordNames = self.createBaseChordNames("")
                }
            }
        } else if self.fifth != nil {
            fifthNoteNumber = self.stackedChordMembers[self.stackedChordMembers.indexOf(self.fifth!)!].noteNumber
            if fifthNoteNumber - rootNoteNumber == 7 {
                suffix = suffix + "5"
                baseChordNames = self.createBaseChordNames("")
            } else if fifthNoteNumber - rootNoteNumber == 6 {
                suffix = suffix + "dim"
                baseChordNames = self.createBaseChordNames(suffix)
            }
        } else {
            baseChordNames = self.createBaseChordNames("")
        }
        //  Suffix could be : "", m, dim, +, 5
        
        //  Alter suffix for extended harmonies
        if self.seventh != nil {
            seventhNoteNumber = self.stackedChordMembers[self.stackedChordMembers.indexOf(self.seventh!)!].noteNumber
            if seventhNoteNumber - rootNoteNumber == 9 {
                switch suffix {
                case "dim":
                    suffix = suffix + "7"
                case "5":
                    suffix = "b7"
                default:
                    suffix = suffix + "b7"
                }
            } else if seventhNoteNumber - rootNoteNumber == 10 {
                switch suffix {
                case "dim":
                    suffix = "7b5"
                case "5":
                    suffix = "7"
                case "7b5":
                    suffix = "7b5"
                case "maj7b5":
                    suffix = "maj7b5"
                default:
                    suffix = suffix + "7"
                }
            } else if seventhNoteNumber - rootNoteNumber == 11 {
                switch suffix {
                case "m":
                    suffix = "m(maj7)"
                case "dim":
                    suffix = "dim(maj7)"
                case "5":
                    suffix = "maj7"
                default:
                    suffix = suffix + "maj7"
                }
            }
        }
        //  Suffix could be: "", m, dim, +, 5, dim7, b7, mb7, +b7, 7b5, 7, m7, +7, m(maj7), dim(maj7), maj7, +maj7
        
        if self.ninth != nil {
            ninthNoteNumber = self.stackedChordMembers[self.stackedChordMembers.indexOf(self.ninth!)!].noteNumber
            if ninthNoteNumber - rootNoteNumber == 13 {
                switch suffix {
                case "", "5":
                    suffix = "addb9"
                case "m" :
                    suffix = "m(b9)"
                case "dim" :
                    suffix = "dim(b9)"
                case "+" :
                    suffix = "+(b9)"
                case "maj7":
                    suffix = "maj7(b9)"
                case "dim7":
                    suffix = "dim(b9)"
                case "7":
                    suffix = "(b9)"
                case "m(maj7)":
                    suffix = "mb9(maj7)"
                case "dim(maj7)":
                    suffix = "dimb9(maj7)"
                case "m7":
                    suffix = "m7(b9)"
                case "7b5":
                    suffix = "7b5(b9)"
                default:
                    suffix = suffix + "b9"
                }
//                suffix = suffix + "b9"
            } else if ninthNoteNumber - rootNoteNumber == 14 {
                switch suffix {
                case "", "5":
                    suffix = "add9"
                case "m" :
                    suffix = "m(add9)"
                case "dim" :
                    suffix = "dim(add9)"
                case "+" :
                    suffix = "+(add9)"
                case "maj7":
                    suffix = "maj9"
                case "dim7":
                    suffix = "dim9"
                case "7":
                    suffix = "9"
                case "m(maj7)":
                    suffix = "m9(maj7)"
                case "dim(maj7)":
                    suffix = "dim9(maj7)"
                case "m7":
                    suffix = "m9"
                case "7b5":
                    suffix = "m9b5"
                default:
                    suffix = suffix + "9"
                }
            } else if ninthNoteNumber - rootNoteNumber == 15 {
                switch suffix {
                case "", "5":
                    suffix = "add#9"
                case "m" :
                    suffix = "m(add#9)"
                case "dim" :
                    suffix = "dim(add#9)"
                case "+" :
                    suffix = "+(add#9)"
                case "maj7":
                    suffix = "maj7(#9)"
                case "dim7":
                    suffix = "dim(#9)"
                case "7":
                    suffix = "(#9)"
                case "m(maj7)":
                    suffix = "m#9(maj7)"
                case "dim(maj7)":
                    suffix = "dim#9(maj7)"
                case "m7":
                    suffix = "m7(#9)"
                case "7b5":
                    suffix = "7b5(#9)"
                default:
                    suffix = suffix + "#9"
                }
//                suffix = suffix + "#9"
            }
        }
        //  Suffix could be: "", m, dim, +, 5, dim7, b7, mb7, +b7, 7b5, 7, m7, +7, m(maj7), dim(maj7), maj7, +maj7, add9, m(add9), dim(add9), +(add9), maj9, dim9, 9, m9(maj7), dim9(maj7), m9, m9b5
        if self.eleventh != nil {
            eleventhNoteNumber = self.stackedChordMembers[self.stackedChordMembers.indexOf(self.eleventh!)!].noteNumber
            if eleventhNoteNumber - rootNoteNumber == 16 {
                switch suffix {
                case "", "5":
                    suffix = "addb11"
                case "m" :
                    suffix = "m(addb11)"
                case "dim" :
                    suffix = "dim(addb11)"
                case "+" :
                    suffix = "+(addb11)"
                case "maj9":
                    suffix = "majb11"
                case "dim9":
                    suffix = "dim(b11)"
                case "9":
                    suffix = "(b11)"
                case "m9(maj7)":
                    suffix = "m b11(maj7)"
                case "dim9(maj7)":
                    suffix = "dim b11(maj7)"
                case "m9":
                    suffix = "m b11"
                case "m9b5":
                    suffix = "m b11b5"
                default:
                    suffix = suffix + "(b11)"
                }
            } else if eleventhNoteNumber - rootNoteNumber == 17 {
                switch suffix {
                case "", "5":
                    suffix = "add11"
                case "m" :
                    suffix = "m(add11)"
                case "dim" :
                    suffix = "dim(add11)"
                case "+" :
                    suffix = "+(add11)"
                case "maj9":
                    suffix = "maj11"
                case "dim9":
                    suffix = "dim11"
                case "9":
                    suffix = "11"
                case "m9(maj7)":
                    suffix = "m11(maj7)"
                case "dim9(maj7)":
                    suffix = "dim11(maj7)"
                case "m9":
                    suffix = "m11"
                case "m9b5":
                    suffix = "m11b5"
                default:
                    suffix = suffix + "(add11)"
                }
            } else if eleventhNoteNumber - rootNoteNumber == 18 {
                switch suffix {
                case "", "5":
                    suffix = "add#11"
                case "m" :
                    suffix = "m(add#11)"
                case "dim" :
                    suffix = "dim(add#11)"
                case "+" :
                    suffix = "+(add#11)"
                case "maj9":
                    suffix = "maj#11"
                case "dim9":
                    suffix = "dim#11"
                case "9":
                    suffix = "(#11)"
                case "m9(maj7)":
                    suffix = "m#11(maj7)"
                case "dim9(maj7)":
                    suffix = "dim#11(maj7)"
                case "m9":
                    suffix = "m#11"
                case "m9b5":
                    suffix = "m#11b5"
                default:
                    suffix = suffix + "(add#11)"
                }
            }
        }
        if self.thirteenth != nil {
            thirteenthNoteNumber = self.stackedChordMembers[self.stackedChordMembers.indexOf(self.thirteenth!)!].noteNumber
            if thirteenthNoteNumber - rootNoteNumber == 20 {
                suffix = suffix + "(b13)"
            } else if thirteenthNoteNumber - rootNoteNumber == 21{
                suffix = suffix + "(13)"
            } else if thirteenthNoteNumber - rootNoteNumber == 22 {
                suffix = suffix + "(#13)"
            }
        }
        self.appendChordName(suffix, baseChordNames: baseChordNames)
    }
    
    private func createBaseChordNames(suffix: String) -> [String] {
        var baseChordNames = [String]()
        for index in 0..<2 {
            let rootNoteName = self.root.enharmonicNoteNames[index]
            baseChordNames.append(rootNoteName + suffix)
        }
        return baseChordNames
    }
    
    private func appendChordName(suffix: String, baseChordNames: [String]) {
        self.setEnharmonicChordNames(suffix, baseChordNames: baseChordNames)
        self.chordName = self.enharmonicChordNames[0]
    }
    
    private func setEnharmonicChordNames(chordSuffix: String, var baseChordNames: [String]) {
        for index in 0..<2 {
            self.enharmonicChordNames.append("\(self.root.enharmonicNoteNames[index])\(chordSuffix)")
        }
        if chordSuffix == "7" && self.fifth != nil {
            for index in 0..<2 {
                self.addEnharmonicChordName("\(self.root.enharmonicNoteNames[index])(Ger+6)")
                baseChordNames.append(baseChordNames[index])
            }
        } else if chordSuffix == "7" && self.fifth == nil {
            for index in 0..<2 {
                self.addEnharmonicChordName("\(self.root.enharmonicNoteNames[index])(It+6)")
                baseChordNames.append(baseChordNames[index])
            }
        } else if chordSuffix == "7b5" {
            
            for index in 0..<2 {
                self.addEnharmonicChordName("\(self.root.enharmonicNoteNames[index])(Fre+6)")
                baseChordNames.append(self.root.enharmonicNoteNames[index])
            }
            for index in 0..<2 {
                self.addEnharmonicChordName("\(self.fifth!.enharmonicNoteNames[index])(Fre+6)")
                baseChordNames.append(self.fifth!.enharmonicNoteNames[index])
            }
        }
        self.addBassNote(baseChordNames)
    }
    
    private func addEnharmonicChordName(enChordName: String) {
        if !self.enharmonicChordNames.contains(enChordName) {
            self.enharmonicChordNames.append(enChordName)
        }
    }
    
    private func addBassNote(baseChordNames: [String]) {
        let slash = "/"
        var bassNoteIndex = [Int]()
        for baseChordName in baseChordNames {
            bassNoteIndex.append(self.getBassNoteIndexForChordBase(baseChordName))
        }
        for index in 0..<self.enharmonicChordNames.count {
            if index < self.bass.enharmonicNoteNames.count {
                if self.root.noteName != self.bass.noteName {
                    self.enharmonicChordNames[index] = self.enharmonicChordNames[index] + slash + self.bass.enharmonicNoteNames[bassNoteIndex[index]]
                }
            }
        }
    }
    
    private func getBassNoteIndexForChordBase(baseChord: String) -> Int {
        print("Base chord: \(baseChord)")
        switch baseChord {
        case "C", "Cm", "Cdim", "Db", "Dm", "Ddim", "Eb", "F", "Fm", "Fdim", "Gb", "Gm", "Gdim", "Ab", "Bb":
            return 0
        case "D", "E", "G", "A", "B", "Bm", "C#m", "Em", "F#m", "G#m", "Am", "C+", "D+", "F+", "G+":
            return 1
        case "Ebm", "Ebdim", "Gbm", "Gbdim", "Abm", "Abdim", "Bbm", "Bbdim":
            return 2
        default:
            return 3
        }
    }
    
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
    
    private func findLowestNote(notes: [Note]) -> Note {
        var lowestNote = Note(noteName: "C", noteNumber: 264)
        for note in notes {
            if note.noteNumber < lowestNote.noteNumber {
                lowestNote = note
            }
        }
        return lowestNote
    }
    
    func chordDescription() -> String {
        var descriptionString = "\(self.chordName):\n\tRoot:\t\t\(self.root.noteName): \(self.root.noteNumber)\n"
        descriptionString = descriptionString + "\t3rd:\t\t\t\(self.third?.noteName): \(self.third?.noteNumber)\n"
        descriptionString = descriptionString + "\t5th:\t\t\t\(self.fifth?.noteName): \(self.fifth?.noteNumber)\n"
        descriptionString = descriptionString + "\t7th:\t\t\t\(self.seventh?.noteName): \(self.seventh?.noteNumber)\n"
        descriptionString = descriptionString + "\t9th:\t\t\t\(self.ninth?.noteName): \(self.ninth?.noteNumber)\n"
        descriptionString = descriptionString + "\t11th:\t\t\(self.eleventh?.noteName): \(self.eleventh?.noteNumber)\n"
        descriptionString = descriptionString + "\t13th:\t\t\(self.thirteenth?.noteName): \(self.thirteenth?.noteNumber)\n"
        descriptionString = descriptionString + "\tBass:\t\t\(self.bass.noteName): \(self.bass.noteNumber)\n\n"
        return descriptionString
    }
    
}
func == (chordOne: Chord, chordTwo: Chord) -> Bool {
    return chordOne.chordName == chordTwo.chordName
}





