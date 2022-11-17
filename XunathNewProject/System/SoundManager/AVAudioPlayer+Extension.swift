//
//  AVAudioPlayerExtension.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 11/11/22.
//
import AVKit

extension AVAudioPlayer {
    public enum AudioPlayerError: Error {
        case fileNotFound
    }
    
    public convenience init(soundFile: SoundFile) throws {
        guard let url = Bundle.main.url(forResource: soundFile.filename, withExtension: soundFile.type) else { throw AudioPlayerError.fileNotFound }
        try self.init(contentsOf: url)
    }
}
