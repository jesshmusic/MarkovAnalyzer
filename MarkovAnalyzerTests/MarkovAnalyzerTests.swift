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
    

    
    let markovProgression = MarkovGraph()
    
    override func setUp() {
        super.setUp()
//        for nextChord in testProgression {
//            self.markovProgression.putChord(nextChord)
//        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //        print(self.markovProgression.displayChords())
        super.tearDown()
    }
    
    
    func testCreateProgression() {
        // This is an example of a functional test case.
//        XCTAssertEqual(self.markovProgression.getChordProgressionCount(), self.testProgression.count, "Fail... should be \(self.testProgression.count)")
    }
    
    func testEqualProgressions() {
//        if self.markovProgression.getChordProgressionCount() == self.testProgression.count {
//            let progression = self.markovProgression.getChordProgression()
//            for index in 0..<self.testProgression.count {
//                XCTAssert(testProgression[index] == progression[index], "PASS... Progressions are equal")
//            }
//        } else {
//            XCTFail()
//        }
    }
    
    func testChordEquality() {
//        XCTAssertNotEqual(self.testProgression[2], self.testProgression[6], "Gm7/Bb should NOT equal Gm7")
//        XCTAssert(self.testProgression[0]==self.testProgression[5], "Chords should be equal.")
    }
    
    func testChordsInMarkovSet() {
//        for index in 0..<self.testProgression.count {
//            XCTAssertEqual(self.markovProgression.hasChord(testProgression[index]), true, "Should have chord \(self.testProgression[index].chordName)")
//        }
    }
    
    func testChordSetCount() {
        XCTAssertEqual(self.markovProgression.getUniqueChorCount(), 20, "There should be 20 unique chords in the Set")
    }
    
    func testChordFrequenciesInMarkov() {
        //        print(self.markovProgression.displayChords())
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

    }
    

    
    func testStackInThirds() {

    }
    

    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measureBlock() {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
   
}
