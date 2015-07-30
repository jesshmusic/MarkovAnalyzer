//
//  MarkovGraph.swift
//  MarkovAn
//
//  This will store states(chords) and the probability that they move to a different chord.
//      The probabilities must always add up to 1.0
//
//  Created by Jess Hendricks on 7/18/15.
//  Copyright © 2015 Existential Music. All rights reserved.
//

import Cocoa


class MarkovGraph: NSObject {
    
    private var currentChord: Chord!
    private var currentProgressionChord: Chord!
    private var chords = Set<Chord>()
    private var chordProgression = [Chord]()
    
    func putChord(newChord: Chord) {
        
        self.chordProgression.append(newChord)
        if self.currentChord != nil {
            self.chords[self.chords.indexOf(self.currentChord)!].addChordConnection(newChord)
        }
        self.currentChord = self.chordProgression.last
        if self.chords.contains(self.currentChord){
            self.chords[self.chords.indexOf(self.currentChord)!].totalOccurences++
        } else {
            self.chords.insert(self.currentChord)
        }
    }
    
    func generateRandomChordProgressionStartingWithChord(startChord: Chord, numberOfChords: Int) -> [Chord]? {
        if !self.chords.isEmpty {
            var chordList = [Chord]()
            if let firstChord = self.resetRandomProgressionToChord(startChord) {
                chordList.append(firstChord)
                for _ in 0..<numberOfChords - 1 {
                    if let nextChord = self.getNext() {
                        chordList.append(nextChord)
                    }
                }
                return chordList
            }
        }
        return nil
    }
    
    private func resetRandomProgressionToChord(chord: Chord) -> Chord? {
        if self.chords.contains(chord) {
            //            print("Chord '\(chord.chordName)' found, setting to start chord.")
            self.currentProgressionChord = self.chords[self.chords.indexOf(chord)!]
            return self.currentProgressionChord
        } else {
            //            print("Chord '\(chord.chordName)' NOT found.")
            if self.chordProgression.count != 0 {
                //                print("Setting the starting chord to the first chord in the progression.")
                self.currentProgressionChord = self.chords[self.chords.indexOf(self.chordProgression.first!)!]
                return self.currentProgressionChord
            }
        }
        return nil
    }
    
    private func getNext() -> Chord? {
        if currentProgressionChord == nil {
            if !self.chordProgression.isEmpty {
                self.resetRandomProgressionToChord(self.chordProgression.first!)
                return self.chords[self.chords.indexOf(self.currentProgressionChord)!]
            }
        } else {
            if let returnChord = self.getRandomChordFromConnections(self.currentProgressionChord) {
                self.currentProgressionChord = self.chords[self.chords.indexOf(returnChord)!]
                return returnChord
            }
        }
        return nil
    }
    
    private func getRandomChordFromConnections(originChord: Chord) -> Chord? {
        print("\n\nChords and probabilities for next chord after \(originChord.chordName):\n")
        let randomNumberRoll = Double(Double(arc4random()) / Double(UINT32_MAX))
        print("Getting random chord, rolled: \(randomNumberRoll)")
        var chordList = [(chord: Chord, low: Double, high: Double)]()
        for chord in originChord.chordConnections {
            let chordProbability = originChord.getProbabilityOfNextForChord(chord.0)
            if chordList.isEmpty {
                chordList.append((chord: chord.0, low: 0.0, high: chordProbability))
            } else {
                let previousChordProbability = chordList[chordList.count - 1].high
                chordList.append((chord: chord.0, low: previousChordProbability, high: chordProbability + previousChordProbability))
            }
        }
        for chord in chordList {
            print("\(chord.chord.chordName): \(chord.low) - \(chord.high)")
        }
        for chord in chordList {
            if chord.low <= randomNumberRoll && chord.high > randomNumberRoll {
                print("Returning chord: \(chord.chord.chordName)")
                return chord.chord
            }
        }
        
        return nil
    }
    
    func removeChord(chord: Chord, indexInProgression: Int) {
        self.chordProgression.removeAtIndex(indexInProgression)
        if self.chords.contains(chord) {
            
            //  Decrement the total number of times this chord appears in the Set.
            let totOcc = --self.chords[self.chords.indexOf(chord)!].totalOccurences
            
            //  If it is not the first chord, then remove the connection from the previous chord in the Set
            if indexInProgression > 0 {
                let previousChord = self.chordProgression[indexInProgression - 1]
                self.chords[self.chords.indexOf(previousChord)!].removeChordConnection(chord)
            }
            
            //  If the total number of times the chord appears is now zero, remove it from the chords Set.
            if totOcc == 0 {
                self.chords.remove(chord)
            }
        }
    }
    
    func numberOfOccurencesForChord(chord: Chord) -> Int {
        if self.chords.contains(chord) {
            return self.chords[self.chords.indexOf(chord)!].totalOccurences
        } else {
            return 0
        }
    }
    
    func numberOfConnectionsForChord(chord: Chord) -> Double {
        if self.chords.contains(chord) {
            return self.chords[self.chords.indexOf(chord)!].totalConnections
        } else {
            return 0
        }
    }
    
    func hasChord(chord: Chord) -> Bool {
        //  TODO: Checks to see if the chord is in the set
        return self.chords.contains(chord)
    }
    
    func getProbabilityForChord(chord: Chord, toChord: Chord) -> Double {
        return chord.getProbabilityOfNextForChord(toChord)
    }
    
    func setCurrentChordToChord(chord: Chord) -> Chord? {
        for nextChord in self.chords {
            if nextChord == chord {
                self.currentChord = nextChord
                return self.currentChord
            }
        }
        return nil
    }
    
    func getChordProgressionCount() -> Int {
        return self.chordProgression.count
    }
    
    func getUniqueChorCount() -> Int {
        return self.chords.count
    }
    
    func getChordProgression() -> [Chord] {
        return self.chordProgression
    }
    
    func displayChords() -> String {
        var returnString = " \n---------------------------------\nChords: \n---------------------------------\n"
        for nextChord in self.chords {
            returnString = returnString + "\(nextChord.chordName)\tTotal Occurrences: \(nextChord.totalOccurences)\n"
            for nextConnection in nextChord.chordConnections {
                returnString = returnString + "\t-> \(nextConnection.0.chordName): Prob: \(nextChord.getProbabilityOfNextForChord(nextConnection.0)), total connections: \(nextConnection.1)\n"
            }
            returnString = returnString + "\n"
        }
        return returnString
    }
    
    
}
