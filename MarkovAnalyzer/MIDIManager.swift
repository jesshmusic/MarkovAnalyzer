//
//  MIDIManager.swift
//  MarkovAnalyzer
//
//  Created by Jess Hendricks on 7/25/15.
//  Copyright © 2015 Existential Music. All rights reserved.
//

import Cocoa
import CoreMIDI
import CoreAudio
import AudioToolbox

let midiNotifyProc: @convention(block) (UnsafePointer<MIDINotification>, UnsafeMutablePointer<Void>) -> Void = { (midiNotifyProc: UnsafePointer<MIDINotification>, refCon:UnsafeMutablePointer<Void>) in
    
    print("MIDI Notify, messageID = \(midiNotifyProc)")
}
let impNotifyProc: COpaquePointer = imp_implementationWithBlock(unsafeBitCast(midiNotifyProc, AnyObject.self))
let midiNotifyCallback: MIDINotifyProc = unsafeBitCast(impNotifyProc, MIDINotifyProc.self)

let midiReadProc: @convention(block) (MIDIPacketList, UnsafeMutablePointer<Void>, UnsafeMutablePointer<Void>) -> Void = { (packetList,readProcRefCon,srcConnRefCon) in
    let packet = packetList.packet
    let midiStatus = packet.data.96
    let data1 = packet.data.97
    let data2 = packet.data.98
    var midiStatusString = NSString(format:"%2X", midiStatus)
    
    MIDIManagerInstance.handle(packet)
}
let impReadProc: COpaquePointer = imp_implementationWithBlock(unsafeBitCast(midiReadProc, AnyObject.self))
let midiReadCallback: MIDIReadProc = unsafeBitCast(impReadProc, MIDIReadProc.self)

/// The `Singleton` instance
private let MIDIManagerInstance = MIDIManager()

class MIDIManager: NSObject {
    
    class var sharedInstance:MIDIManager {
        return MIDIManagerInstance
    }
    
    var midiClient = MIDIClientRef()
    
    var outputPort = MIDIPortRef()
    
    var inputPort = MIDIPortRef()
    
    var destEndpointRef = MIDIEndpointRef()
    
    var midiInputPortref = MIDIPortRef()
    
    var musicPlayer:MusicPlayer?
    
    var processingGraph = AUGraph()
    
    var samplerUnit = AudioUnit()
    
    /**
    This will initialize the midiClient, outputPort, and inputPort variables.
    */
    
    func initMIDI(midiNotifier: MIDINotifyBlock? = nil, reader: MIDIReadBlock? = nil) {
        if #available(OSX 10.11, *) {
            self.initMIDIForOS1011(midiNotifier, reader: reader)
        } else {
            self.initMIDIForEarlier()
        }
        
    }
    
    /**
        Initializes MIDI for OS 10.11
    */
    @available(OSX 10.11, *)
    private func initMIDIForOS1011(midiNotifier: MIDINotifyBlock? = nil, reader: MIDIReadBlock? = nil) {
        var notifyBlock: MIDINotifyBlock
        
        if midiNotifier != nil {
            notifyBlock = midiNotifier!
        } else {
            notifyBlock = MyMIDINotifyBlock
        }
        
        var readBlock: MIDIReadBlock
        if reader != nil {
            readBlock = reader!
        } else {
            readBlock = MyMIDIReadBlock
        }
        
        var status = OSStatus(noErr)
        status = MIDIClientCreateWithBlock("MyMIDIClient", &midiClient, notifyBlock)
        
        if status == OSStatus(noErr) {
            print("created client")
        } else {
            print("error creating client : \(status)")
            showError(status)
        }
        if status == OSStatus(noErr) {
            
            status = MIDIInputPortCreateWithBlock(midiClient, "MyClient In", &inputPort, readBlock)
            if status == OSStatus(noErr) {
                print("created input port")
            } else {
                print("error creating input port : \(status)")
                showError(status)
            }
            
            status = MIDIOutputPortCreate(midiClient,
                "My Output Port",
                &outputPort)
            if status == OSStatus(noErr) {
                print("created output port \(outputPort)")
            } else {
                print("error creating output port : \(status)")
                showError(status)
            }
            
            status = MIDIDestinationCreateWithBlock(midiClient,
                    "Virtual Dest",
                    &destEndpointRef,
                    readBlock)
            
            if status != noErr {
                print("error creating virtual destination: \(status)")
            } else {
                print("midi virtual destination created \(destEndpointRef)")
            }
            
            connectSourcesToInputPort()
            initGraph()
        }
    }
    
    /**
        Initializes MIDI for earlier
    */
    private func initMIDIForEarlier() {

        var status = OSStatus(noErr)
        
        status = MIDIClientCreate("MyMIDIClient", midiNotifyCallback, nil, &midiClient)
        
        if status == OSStatus(noErr) {
            print("created client")
        } else {
            print("error creating client : \(status)")
            showError(status)
        }
        if status == OSStatus(noErr) {
            
            status = MIDIInputPortCreate(midiClient, "Input Port", midiReadCallback, &processingGraph, &inputPort)
            if status == OSStatus(noErr) {
                print("created input port")
            } else {
                print("error creating input port : \(status)")
                showError(status)
            }
            
            status = MIDIOutputPortCreate(midiClient,
                "My Output Port",
                &outputPort)
            if status == OSStatus(noErr) {
                print("created output port \(outputPort)")
            } else {
                print("error creating output port : \(status)")
                showError(status)
            }
            
            status = MIDIDestinationCreate(midiClient, "Virtual Destination", midiReadCallback, &outputPort, &destEndpointRef)
            
            if status != noErr {
                print("error creating virtual destination: \(status)")
            } else {
                print("midi virtual destination created \(destEndpointRef)")
            }
            
            connectSourcesToInputPort()
            initGraph()
        }
    }
    
    
    func initGraph() {
        augraphSetup()
        graphStart()
        // after the graph starts
        loadSF2Preset(0)
        CAShow(UnsafeMutablePointer<MusicSequence>(self.processingGraph))
    }
    
    
    // typealias MIDIReadBlock = (UnsafePointer<MIDIPacketList>, UnsafeMutablePointer<Void>) -> Void
    
    func MyMIDIReadBlock(packetList: UnsafePointer<MIDIPacketList>, srcConnRefCon: UnsafeMutablePointer<Void>) -> Void {
        
        //debugPrint("MyMIDIReadBlock \(packetList)")
        
        let packets = packetList.memory
        
        let packet:MIDIPacket = packets.packet
        
        // don't do this
        //        print("packet \(packet)")
        
        var ap = UnsafeMutablePointer<MIDIPacket>.alloc(1)
        ap.initialize(packet)
        
        for _ in 0 ..< packets.numPackets {
            
            let p = ap.memory
            print("timestamp \(p.timeStamp)", appendNewline:false)
            var hex = String(format:"0x%X", p.data.0)
            print(" \(hex)", appendNewline:false)
            hex = String(format:"0x%X", p.data.1)
            print(" \(hex)", appendNewline:false)
            hex = String(format:"0x%X", p.data.2)
            print(" \(hex)")
            
            handle(p)
            
            ap = MIDIPacketNext(ap)
            
        }
        
    }
    
    func handle(packet:MIDIPacket) {
        var status: UInt8!
        var d1: UInt8!
        var d2: UInt8!
        if #available(OSX 10.11, *) {
            status = packet.data.0
            d1 = packet.data.1
            d2 = packet.data.2
        } else {
            status = packet.data.96
            d1 = packet.data.97
            d2 = packet.data.98
        }
        MusicDeviceMIDIEvent(self.samplerUnit, UInt32(status), UInt32(d1), UInt32(d2), 0)
        
        let rawStatus = status & 0xF0 // without channel
        let channel = status & 0x0F
        
        switch rawStatus {
            
        case 0x80:
            _ = 1
            // forward to sampler
            
        case 0x90:
            // forward to sampler
            let notifyName = "MIDINoteNotifictation"
            let userInfo = ["Note": Int(d1!)]
            print("Note pressed: \(d1)")
            NSNotificationCenter.defaultCenter().postNotificationName(notifyName, object: self, userInfo: userInfo)
            
        case 0xA0:
            print("Polyphonic Key Pressure (Aftertouch). Channel \(channel) note \(d1) pressure \(d2)")
        case 0xB0:
            print("Control Change. Channel \(channel) controller \(d1) value \(d2)")
            
        case 0xC0:
            print("Program Change. Channel \(channel) program \(d1)")
            
        case 0xD0:
            print("Channel Pressure (Aftertouch). Channel \(channel) pressure \(d1)")
            
        case 0xE0:
            print("Pitch Bend Change. Channel \(channel) lsb \(d1) msb \(d2)")
            
        default: print("Unhandled message \(status)")
        }
        
        
    }
    
    //typealias MIDINotifyBlock = (UnsafePointer<MIDINotification>) -> Void
    func MyMIDINotifyBlock(midiNotification: UnsafePointer<MIDINotification>) {
        print("got a MIDINotification!")
        
        let notification = midiNotification.memory
        print("MIDI Notify, messageId= \(notification.messageID)")
        print("MIDI Notify, messageSize= \(notification.messageSize)")
        
        // values are now an enum!
        
        switch (notification.messageID) {
        case .MsgSetupChanged:
            print("MIDI setup changed")
            break
            
            //TODO: so how to "downcast" to MIDIObjectAddRemoveNotification
        case .MsgObjectAdded:
            
            print("added")
            
            var mem = midiNotification.memory
            withUnsafePointer(&mem) { ptr -> Void in
                let mp = unsafeBitCast(ptr, UnsafePointer<MIDIObjectAddRemoveNotification>.self)
                let m = mp.memory
                print("id \(m.messageID)")
                print("size \(m.messageSize)")
                print("child \(m.child)")
                print("child type \(m.childType)")
                print("parent \(m.parent)")
                print("parentType \(m.parentType)")
            }
            
            break
            
        case .MsgObjectRemoved:
            print("kMIDIMsgObjectRemoved")
            break
            
        case .MsgPropertyChanged:
            print("kMIDIMsgPropertyChanged")
            
            var mem = midiNotification.memory
            withUnsafePointer(&mem) { ptr -> Void in
                let mp = unsafeBitCast(ptr, UnsafePointer<MIDIObjectPropertyChangeNotification>.self)
                let m = mp.memory
                print("id \(m.messageID)")
                print("size \(m.messageSize)")
                print("object \(m.object)")
                print("objectType  \(m.objectType)")
                //                if m.propertyName.takeUnretainedValue() == kMIDIPropertyOffline {
                //                    var value = Int32(0)
                //                    let status = MIDIObjectGetIntegerProperty(m.object, kMIDIPropertyOffline, &value)
                //                    if status != noErr {
                //                        print("oops")
                //                    }
                //                    print("The offline property is \(value)")
                //                }
                
            }
            
            break
            
        case .MsgThruConnectionsChanged:
            print("MIDI thru connections changed.")
            break
            
        case .MsgSerialPortOwnerChanged:
            print("MIDI serial port owner changed.")
            break
            
        case .MsgIOError:
            print("MIDI I/O error.")
            //MIDIIOErrorNotification
            break
            
        }
        
    }
    
    
    func showError(status:OSStatus) {
        
        switch status {
            
        case OSStatus(kMIDIInvalidClient):
            print("invalid client")
            break
        case OSStatus(kMIDIInvalidPort):
            print("invalid port")
            break
        case OSStatus(kMIDIWrongEndpointType):
            print("invalid endpoint type")
            break
        case OSStatus(kMIDINoConnection):
            print("no connection")
            break
        case OSStatus(kMIDIUnknownEndpoint):
            print("unknown endpoint")
            break
            
        case OSStatus(kMIDIUnknownProperty):
            print("unknown property")
            break
        case OSStatus(kMIDIWrongPropertyType):
            print("wrong property type")
            break
        case OSStatus(kMIDINoCurrentSetup):
            print("no current setup")
            break
        case OSStatus(kMIDIMessageSendErr):
            print("message send")
            break
        case OSStatus(kMIDIServerStartErr):
            print("server start")
            break
        case OSStatus(kMIDISetupFormatErr):
            print("setup format")
            break
        case OSStatus(kMIDIWrongThread):
            print("wrong thread")
            break
        case OSStatus(kMIDIObjectNotFound):
            print("object not found")
            break
            
        case OSStatus(kMIDIIDNotUnique):
            print("not unique")
            break
            
        case OSStatus(kMIDINotPermitted):
            print("not permitted")
            break
            
        default:
            print("dunno \(status)")
        }
    }
    
    //
    //    func enableNetwork() {
    //        let session = MIDINetworkSession.defaultSession()
    //        session.enabled = true
    //        session.connectionPolicy = .Anyone
    //        print("net session enabled \(MIDINetworkSession.defaultSession().enabled)")
    //    }
    
    func connectSourcesToInputPort() {
        var status = OSStatus(noErr)
        let sourceCount = MIDIGetNumberOfSources()
        print("source count \(sourceCount)")
        
        for srcIndex in 0 ..< sourceCount {
            let midiEndPoint = MIDIGetSource(srcIndex)
            status = MIDIPortConnectSource(inputPort,
                midiEndPoint,
                nil)
            if status == OSStatus(noErr) {
                print("yay connected endpoint to inputPort!")
            } else {
                print("oh crap!")
            }
        }
    }
    
    
    
    func augraphSetup() {
        var status = OSStatus(noErr)
        status = NewAUGraph(&self.processingGraph)
        CheckError(status)
        
        // create the sampler
        
        //https://developer.apple.com/library/prerelease/ios/documentation/AudioUnit/Reference/AudioComponentServicesReference/index.html#//apple_ref/swift/struct/AudioComponentDescription
        
        var samplerNode = AUNode()
        var cd = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_MusicDevice),
            componentSubType: OSType(kAudioUnitSubType_Sampler),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0)
        status = AUGraphAddNode(self.processingGraph, &cd, &samplerNode)
        CheckError(status)
        
        // create the ionode
        var ioNode = AUNode()
        var ioUnitDescription = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_Output),
            componentSubType: OSType(kAudioUnitSubType_DefaultOutput),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0)
        status = AUGraphAddNode(self.processingGraph, &ioUnitDescription, &ioNode)
        CheckError(status)
        
        // now do the wiring. The graph needs to be open before you call AUGraphNodeInfo
        status = AUGraphOpen(self.processingGraph)
        CheckError(status)
        
        status = AUGraphNodeInfo(self.processingGraph, samplerNode, nil, &self.samplerUnit)
        CheckError(status)
        
        var ioUnit  = AudioUnit()
        status = AUGraphNodeInfo(self.processingGraph, ioNode, nil, &ioUnit)
        CheckError(status)
        
        let ioUnitOutputElement = AudioUnitElement(0)
        let samplerOutputElement = AudioUnitElement(0)
        status = AUGraphConnectNodeInput(self.processingGraph,
            samplerNode, samplerOutputElement, // srcnode, inSourceOutputNumber
            ioNode, ioUnitOutputElement) // destnode, inDestInputNumber
        CheckError(status)
    }
    
    
    func graphStart() {
        //https://developer.apple.com/library/prerelease/ios/documentation/AudioToolbox/Reference/AUGraphServicesReference/index.html#//apple_ref/c/func/AUGraphIsInitialized
        
        var status = OSStatus(noErr)
        var outIsInitialized:Boolean = 0
        status = AUGraphIsInitialized(self.processingGraph, &outIsInitialized)
        print("isinit status is \(status)")
        print("bool is \(outIsInitialized)")
        if outIsInitialized == 0 {
            status = AUGraphInitialize(self.processingGraph)
            CheckError(status)
        }
        
        var isRunning = Boolean(0)
        AUGraphIsRunning(self.processingGraph, &isRunning)
        print("running bool is \(isRunning)")
        if isRunning == 0 {
            status = AUGraphStart(self.processingGraph)
            CheckError(status)
        }
        
    }
    
    func playNoteOn(channel:UInt32, noteNum:UInt32, velocity:UInt32)    {
        let noteCommand = UInt32(0x90 | channel)
        var status  = OSStatus(noErr)
        status = MusicDeviceMIDIEvent(self.samplerUnit, noteCommand, noteNum, velocity, 0)
        CheckError(status)
    }
    
    func playNoteOff(channel:UInt32, noteNum:UInt32)    {
        let noteCommand = UInt32(0x80 | channel)
        var status : OSStatus = OSStatus(noErr)
        status = MusicDeviceMIDIEvent(self.samplerUnit, noteCommand, noteNum, 0, 0)
        CheckError(status)
    }
    
    
    /// loads preset into self.samplerUnit
    func loadSF2Preset(preset:UInt8)  {
        
        // This is the MuseCore soundfont. Change it to the one you have.
        //        if let bankURL = NSBundle.mainBundle().URLForResource("GeneralUser GS MuseScore v1.442", withExtension: "sf2") {
        if let bankURL = NSBundle.mainBundle().URLForResource("32MbGMStereo", withExtension: "sf2") {
            var instdata = AUSamplerInstrumentData(fileURL: Unmanaged.passUnretained(bankURL),
                instrumentType: UInt8(kInstrumentType_DLSPreset),
                bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                bankLSB: UInt8(kAUSampler_DefaultBankLSB),
                presetID: preset)
            
            print("Instrument\n\t\(instdata.presetID)")
            let status = AudioUnitSetProperty(
                self.samplerUnit,
                AudioUnitPropertyID(kAUSamplerProperty_LoadInstrument),
                AudioUnitScope(kAudioUnitScope_Global),
                0,
                &instdata,
                UInt32(sizeof(AUSamplerInstrumentData)))
            CheckError(status)
        }
    }
    
    
    
    /**
    Not as detailed as Adamson's CheckError, but adequate.
    For other projects you can uncomment the Core MIDI constants.
    */
    func CheckError(error:OSStatus) {
        if error == 0 {return}
        
        switch error {
        case kMIDIInvalidClient :
            print( "kMIDIInvalidClient ")
            
        case kMIDIInvalidPort :
            print( "kMIDIInvalidPort ")
            
        case kMIDIWrongEndpointType :
            print( "kMIDIWrongEndpointType")
            
        case kMIDINoConnection :
            print( "kMIDINoConnection ")
            
        case kMIDIUnknownEndpoint :
            print( "kMIDIUnknownEndpoint ")
            
        case kMIDIUnknownProperty :
            print( "kMIDIUnknownProperty ")
            
        case kMIDIWrongPropertyType :
            print( "kMIDIWrongPropertyType ")
            
        case kMIDINoCurrentSetup :
            print( "kMIDINoCurrentSetup ")
            
        case kMIDIMessageSendErr :
            print( "kMIDIMessageSendErr ")
            
        case kMIDIServerStartErr :
            print( "kMIDIServerStartErr ")
            
        case kMIDISetupFormatErr :
            print( "kMIDISetupFormatErr ")
            
        case kMIDIWrongThread :
            print( "kMIDIWrongThread ")
            
        case kMIDIObjectNotFound :
            print( "kMIDIObjectNotFound ")
            
        case kMIDIIDNotUnique :
            print( "kMIDIIDNotUnique ")
            
        default: print( "huh? \(error) ")
        }
        
        
        switch(error) {
            //AUGraph.h
        case kAUGraphErr_NodeNotFound:
            print("Error:kAUGraphErr_NodeNotFound \n")
            
        case kAUGraphErr_OutputNodeErr:
            print( "Error:kAUGraphErr_OutputNodeErr \n")
            
        case kAUGraphErr_InvalidConnection:
            print("Error:kAUGraphErr_InvalidConnection \n")
            
        case kAUGraphErr_CannotDoInCurrentContext:
            print( "Error:kAUGraphErr_CannotDoInCurrentContext \n")
            
        case kAUGraphErr_InvalidAudioUnit:
            print( "Error:kAUGraphErr_InvalidAudioUnit \n")
            
            // core audio
            
        case kAudio_UnimplementedError:
            print("kAudio_UnimplementedError")
        case kAudio_FileNotFoundError:
            print("kAudio_FileNotFoundError")
        case kAudio_FilePermissionError:
            print("kAudio_FilePermissionError")
        case kAudio_TooManyFilesOpenError:
            print("kAudio_TooManyFilesOpenError")
        case kAudio_BadFilePathError:
            print("kAudio_BadFilePathError")
        case kAudio_ParamError:
            print("kAudio_ParamError")
        case kAudio_MemFullError:
            print("kAudio_MemFullError")
            
            
            // AudioToolbox
            
        case kAudioToolboxErr_InvalidSequenceType :
            print( " kAudioToolboxErr_InvalidSequenceType ")
            
        case kAudioToolboxErr_TrackIndexError :
            print( " kAudioToolboxErr_TrackIndexError ")
            
        case kAudioToolboxErr_TrackNotFound :
            print( " kAudioToolboxErr_TrackNotFound ")
            
        case kAudioToolboxErr_EndOfTrack :
            print( " kAudioToolboxErr_EndOfTrack ")
            
        case kAudioToolboxErr_StartOfTrack :
            print( " kAudioToolboxErr_StartOfTrack ")
            
        case kAudioToolboxErr_IllegalTrackDestination :
            print( " kAudioToolboxErr_IllegalTrackDestination")
            
        case kAudioToolboxErr_NoSequence :
            print( " kAudioToolboxErr_NoSequence ")
            
        case kAudioToolboxErr_InvalidEventType :
            print( " kAudioToolboxErr_InvalidEventType")
            
        case kAudioToolboxErr_InvalidPlayerState :
            print( " kAudioToolboxErr_InvalidPlayerState")
            
            // AudioUnit
            
            
        case kAudioUnitErr_InvalidProperty :
            print( " kAudioUnitErr_InvalidProperty")
            
        case kAudioUnitErr_InvalidParameter :
            print( " kAudioUnitErr_InvalidParameter")
            
        case kAudioUnitErr_InvalidElement :
            print( " kAudioUnitErr_InvalidElement")
            
        case kAudioUnitErr_NoConnection :
            print( " kAudioUnitErr_NoConnection")
            
        case kAudioUnitErr_FailedInitialization :
            print( " kAudioUnitErr_FailedInitialization")
            
        case kAudioUnitErr_TooManyFramesToProcess :
            print( " kAudioUnitErr_TooManyFramesToProcess")
            
        case kAudioUnitErr_InvalidFile :
            print( " kAudioUnitErr_InvalidFile")
            
        case kAudioUnitErr_FormatNotSupported :
            print( " kAudioUnitErr_FormatNotSupported")
            
        case kAudioUnitErr_Uninitialized :
            print( " kAudioUnitErr_Uninitialized")
            
        case kAudioUnitErr_InvalidScope :
            print( " kAudioUnitErr_InvalidScope")
            
        case kAudioUnitErr_PropertyNotWritable :
            print( " kAudioUnitErr_PropertyNotWritable")
            
        case kAudioUnitErr_InvalidPropertyValue :
            print( " kAudioUnitErr_InvalidPropertyValue")
            
        case kAudioUnitErr_PropertyNotInUse :
            print( " kAudioUnitErr_PropertyNotInUse")
            
        case kAudioUnitErr_Initialized :
            print( " kAudioUnitErr_Initialized")
            
        case kAudioUnitErr_InvalidOfflineRender :
            print( " kAudioUnitErr_InvalidOfflineRender")
            
        case kAudioUnitErr_Unauthorized :
            print( " kAudioUnitErr_Unauthorized")
            
        default:
            print("huh?")
        }
    }
}
