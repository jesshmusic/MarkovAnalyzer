//
//  KeySignature.swift
//  MarkovAnalyzer
//
//  Created by Jess Hendricks on 10/5/15.
//  Copyright © 2015 Existential Music. All rights reserved.
//

import Cocoa

class KeySignature: Hashable {
    
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
