//
//  SoundSampler.swift
//  SoundWave
//
//  Created by Ikuo Kudo on 2016/03/23.
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Foundation
import AVFoundation

public class SoundSampler {
    
    public var data: NSData!
    
    init(url: NSURL) {
        self.data = aquireSoundData(url)
    }
    
    public func aquireSoundData(url: NSURL) -> NSData! {
        let asset = AVAsset(URL: url)
        var assetReader:AVAssetReader
        
        do{
            assetReader = try AVAssetReader(asset: asset)
        }catch{
            fatalError("Unable to read Asset: \(error) : \(__FUNCTION__).")
        }
        
        let track = asset.tracksWithMediaType(AVMediaTypeAudio).first
        let outputSettings: [String:Int] =
        [ AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVLinearPCMIsBigEndianKey: 0,
            AVLinearPCMIsFloatKey: 0,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsNonInterleaved: 0]
        
        let trackOutput = AVAssetReaderTrackOutput(track: track!, outputSettings: outputSettings)
        
        assetReader.addOutput(trackOutput)
        assetReader.startReading()
        
        let sampleData = NSMutableData()
        while assetReader.status == AVAssetReaderStatus.Reading {
            if let sampleBufferRef = trackOutput.copyNextSampleBuffer() {
                if let blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef) {
                    let bufferLength = CMBlockBufferGetDataLength(blockBufferRef)
                    let data = NSMutableData(length: bufferLength)
                    CMBlockBufferCopyDataBytes(blockBufferRef, 0, bufferLength, data!.mutableBytes)
                    let samples = UnsafeMutablePointer<Int16>(data!.mutableBytes)
                    sampleData.appendBytes(samples, length: bufferLength)
                    CMSampleBufferInvalidate(sampleBufferRef)
                }
            }
        }
        
        if assetReader.status == AVAssetReaderStatus.Completed {
            print("complete")
            return sampleData
        }
        else {
            return nil
        }
    }
}