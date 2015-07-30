//
//  ChordCellView.swift
//  MarkovAnalyzer
//
//  Created by Jess Hendricks on 7/26/15.
//  Copyright © 2015 Existential Music. All rights reserved.
//

import Cocoa

class ChordCellView: NSTableCellView {

    @IBOutlet weak var chordNameTextField: NSTextField!
    @IBOutlet weak var romanNumberalTextField: NSTextField!
    @IBOutlet weak var chordNumberTextField: NSTextField!
    
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
