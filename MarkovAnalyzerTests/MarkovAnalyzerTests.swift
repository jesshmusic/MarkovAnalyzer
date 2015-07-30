//
//  MarkovAnalyzerTests.swift
//  MarkovAnalyzerTests
//
//  Created by Fupduck Central MBP on 5/21/15.
//  Copyright (c) 2015 Existential Music. All rights reserved.
//

import Cocoa
import XCTest

class MarkovAnalyzerTests: XCTestCase {
    
    let testProgression = [
        Chord(chordName: "vi"),
        Chord(chordName: "I6"),
        Chord(chordName: "ii65"),
        Chord(chordName: "V7"),
        Chord(chordName: "I"),
        Chord(chordName: "vi"),
        Chord(chordName: "ii7"),
        Chord(chordName: "I6"),
        Chord(chordName: "ii65"),
        Chord(chordName: "V7"),
        Chord(chordName: "I"),
        Chord(chordName: "I"),
        Chord(chordName: "V6"),
        Chord(chordName: "vi"),
        Chord(chordName: "IV"),
        Chord(chordName: "ii"),
        Chord(chordName: "V6"),
        Chord(chordName: "I"),
        Chord(chordName: "I6"),
        Chord(chordName: "V7"),
        Chord(chordName: "vi"),
        Chord(chordName: "viiø65"),
        Chord(chordName: "V7"),
        Chord(chordName: "vi"),
        Chord(chordName: "iii6"),
        Chord(chordName: "vi42"),
        Chord(chordName: "V6/V"),
        Chord(chordName: "V"),
        Chord(chordName: "V42"),
        Chord(chordName: "I6"),
        Chord(chordName: "I"),
        Chord(chordName: "vi42"),
        Chord(chordName: "ii6"),
        Chord(chordName: "V43"),
        Chord(chordName: "V7"),
        Chord(chordName: "vi6"),
        Chord(chordName: "vi"),
        Chord(chordName: "viio42"),
        Chord(chordName: "vi"),
        Chord(chordName: "viiø65"),
        Chord(chordName: "V7/vi"),
        Chord(chordName: "vi")
    ]
    
    let markovProgression = MarkovGraph()
    
    override func setUp() {
        super.setUp()
        for nextChord in testProgression {
            self.markovProgression.putChord(nextChord)
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //        print(self.markovProgression.displayChords())
        super.tearDown()
    }
    
    
    func testCreateProgression() {
        // This is an example of a functional test case.
        XCTAssertEqual(self.markovProgression.getChordProgressionCount(), self.testProgression.count, "Fail... should be \(self.testProgression.count)")
    }
    
    func testEqualProgressions() {
        if self.markovProgression.getChordProgressionCount() == self.testProgression.count {
            let progression = self.markovProgression.getChordProgression()
            for index in 0..<self.testProgression.count {
                XCTAssert(testProgression[index] == progression[index], "PASS... Progressions are equal")
            }
        } else {
            XCTFail()
        }
    }
    
    func testChordEquality() {
        XCTAssertNotEqual(self.testProgression[2], self.testProgression[6], "Gm7/Bb should NOT equal Gm7")
        XCTAssert(self.testProgression[0]==self.testProgression[5], "Chords should be equal.")
    }
    
    func testChordsInMarkovSet() {
        for index in 0..<self.testProgression.count {
            XCTAssertEqual(self.markovProgression.hasChord(testProgression[index]), true, "Should have chord \(self.testProgression[index].chordName)")
        }
    }
    
    func testChordSetCount() {
        XCTAssertEqual(self.markovProgression.getUniqueChorCount(), 20, "There should be 20 unique chords in the Set")
    }
    
    func testChordFrequenciesInMarkov() {
        //        print(self.markovProgression.displayChords())
        XCTAssertEqual(self.markovProgression.numberOfOccurencesForChord(testProgression[0]), 8, "Dm should occur 5 times")
        XCTAssertEqual(self.markovProgression.numberOfOccurencesForChord(testProgression[1]), 4, "F/A should occur 3 times")
        XCTAssertEqual(self.markovProgression.numberOfOccurencesForChord(testProgression[2]), 2, "Gm7/Bb should occur 2 times")
        XCTAssertEqual(self.markovProgression.numberOfOccurencesForChord(testProgression[3]), 5, "C7 should occur 3 times")
        XCTAssertEqual(self.markovProgression.numberOfOccurencesForChord(testProgression[4]), 5, "F should occur 4 times")
        XCTAssertEqual(self.markovProgression.numberOfOccurencesForChord(testProgression[6]), 1, "Gm7 should occur 1 time")
    }
    
    func testNextChordProbability() {
        //        let dmtoFAProb = self.markovProgression.getProbabilityForChord(testProgression[0], toChord: testProgression[1])
        //        let dmToGm7 = self.markovProgression.getProbabilityForChord(testProgression[0], toChord: testProgression[6])
        //        let fAToGm7Bb = self.markovProgression.getProbabilityForChord(testProgression[1], toChord: testProgression[2])
        //        let C7ToF = self.markovProgression.getProbabilityForChord(testProgression[3], toChord: testProgression[4])
        //        let C7ToDm = self.markovProgression.getProbabilityForChord(testProgression[3], toChord: testProgression[0])
        //
        //        XCTAssertEqual(dmtoFAProb, 0.25, "The probability that Dm goes to F/A should be 0.5")
        //        XCTAssertEqual(dmToGm7, 0.25, "The probability that Dm goes to Gm7/Bb should be 0.5")
        //        XCTAssertEqual(fAToGm7Bb, 2.0/3.0, "The probability that F/A goes to Gm7/Bb should be 2/3")
        //        XCTAssertEqual(C7ToF, 2.0/3.0, "The probability that Dm goes to F/A should be 2/3")
        //        XCTAssertEqual(C7ToDm, 1.0/3.0, "The probability that Dm goes to F/A should be 1/3")
    }
    
    func testNextChordGeneration() {
        if var newChordList = self.markovProgression.generateRandomChordProgressionStartingWithChord(self.testProgression[4], numberOfChords: 20) {
            
            XCTAssertEqual(newChordList[0].chordName, self.testProgression[4].chordName, "The first Chord should be F.")
            XCTAssertEqual(newChordList.count, 20, "New list of chords should have 20 elements")
            print("\n\nList of chords generated:\n")
            for newChord in newChordList {
                print("\(newChord.chordName)")
            }
        } else {
            XCTFail()
        }
    }
    
    func testGetChordsFromNotes() {
//        let chordAnalyzer = ChordAnalysis()
//        let testNotes1 = [Note(noteName: "C", noteNumber: 60), Note(noteName: "E", noteNumber: 52), Note(noteName: "G", noteNumber: 55)]
//        let expectedChords1 = [Chord(chordName: "C/E"), Chord(chordName: "B#/E")]
//        let testResults1 = chordAnalyzer.generateChordFromNotes(testNotes1)
//        for testResult in testResults1 {
//            print("Chord name: \(testResult.chordName)")
//        }
//        XCTAssertEqual(testResults1, expectedChords1, "FAIL")
//        
//        let testNotes2 = [Note(noteName: "C", noteNumber: 60), Note(noteName: "E", noteNumber: 52), Note(noteName: "G", noteNumber: 55), Note(noteName: "Bb", noteNumber: 70)]
//        let expectedChords2 = [Chord(chordName: "C7/E"), Chord(chordName: "B#7/E"), Chord(chordName: "GerA6/E")]
//        let testResults2 = chordAnalyzer.generateChordFromNotes(testNotes2)
//        for testResult in testResults2 {
//            print("Chord name: \(testResult.chordName)")
//        }
//        XCTAssertEqual(testResults2, expectedChords2, "FAIL")
    }
    
//    func testChordWithMembersInit() {
//        let chord1 = Chord(root: Note(noteNumber: 60), third: Note(noteNumber: 64), fifth: Note(noteNumber: 67), bassNote: Note(noteNumber: 52))
//        XCTAssertEqual(chord1.enharmonicChordNames, ["C/E", "B#/E"])
//        
//        let chord2 = Chord(root: Note(noteNumber: 7), third: Note(noteNumber: 10), seventh: Note(noteNumber: 17), bassNote: Note(noteNumber: 7))
//        XCTAssertEqual(chord2.enharmonicChordNames, ["Gm7"])
//        
//        let chord3 = Chord(root: Note(noteNumber: 7), third: Note(noteNumber: 10), ninth: Note(noteNumber: 21), bassNote: Note(noteNumber: 7))
//        XCTAssertEqual(chord3.enharmonicChordNames, ["Gm9"])
//        
//        let chord4 = Chord(root: Note(noteNumber: 6), third: Note(noteNumber: 9), fifth: Note(noteNumber: 12), seventh: Note(noteNumber: 15), bassNote: Note(noteNumber: 9))
//        XCTAssertEqual(chord4.enharmonicChordNames, ["F#dim(b7)/A", "Gbdim(b7)/A"])
//        
//        let chord5 = Chord(root: Note(noteNumber: 8), third: Note(noteNumber: 12), fifth: Note(noteNumber: 15), sixth: Note(noteNumber: 18), bassNote: Note(noteNumber: 8))
//        XCTAssertEqual(chord5.enharmonicChordNames, ["AbGermanA6", "G#GermanA6"])
//        
//        let chord6 = Chord(root: Note(noteNumber: 8), third: Note(noteNumber: 12), fourth: Note(noteNumber: 14), sixth: Note(noteNumber: 18), bassNote: Note(noteNumber: 8))
//        XCTAssertEqual(chord6.enharmonicChordNames, ["AbFrenchA6", "G#FrenchA6"])
//    }
    
    func testStackInThirds() {
        let chord1 = Chord(notes: [Note(noteNumber: 62), Note(noteNumber: 54), Note(noteNumber: 69)])
        XCTAssertEqual(chord1.enharmonicChordNames, ["D/F#", "Ebb/Gb"])
        let chord2 = Chord(notes: [Note(noteNumber: 74), Note(noteNumber: 77), Note(noteNumber: 64), Note(noteNumber: 60)])
        XCTAssertEqual(chord2.enharmonicChordNames, ["C11", "B#11"])
        let chord3 = Chord(notes: [Note(noteNumber: 74), Note(noteNumber: 77), Note(noteNumber: 52), Note(noteNumber: 60)])
        XCTAssertEqual(chord3.enharmonicChordNames, ["C11/E", "B#11/D##"])
        let chord4 = Chord(notes: [Note(noteNumber: 69), Note(noteNumber: 73), Note(noteNumber: 65)])
        XCTAssertEqual(chord4.enharmonicChordNames, ["F+", "E#+"])
        let chord5 = Chord(notes: [Note(noteNumber: 62), Note(noteNumber: 68), Note(noteNumber: 78), Note(noteNumber: 84)])
        XCTAssertEqual(chord5.enharmonicChordNames, ["Ddim(no 3rd)(b11)", "Ebbdim(no 3rd)(b11)", "DFre+6", "EbbFre+6", "AbFre+6", "G#Fre+6"])
        let chord5a = Chord(notes: [Note(noteNumber: 62), Note(noteNumber: 68), Note(noteNumber: 78), Note(noteNumber: 72)])
        print("Chord5a: \(chord5a.chordDescription())")
        XCTAssertEqual(chord5a.enharmonicChordNames, ["Ddim(no 3rd)(b11)", "Ebbdim(no 3rd)(b11)", "DFre+6", "EbbFre+6", "AbFre+6", "G#Fre+6"])
        let chord6 = Chord(notes: [Note(noteNumber: 24), Note(noteNumber: 28), Note(noteNumber: 30), Note(noteNumber: 34)])
        XCTAssertEqual(chord6.enharmonicChordNames, ["F#dim(no 3rd)(b11)/C", "Gbdim(no 3rd)(b11)/B#", "F#Fre+6", "GbFre+6", "CFre+6", "B#Fre+6"])
        print("Chord6: \(chord6.chordDescription())")
    }
    

    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measureBlock() {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
   
}
