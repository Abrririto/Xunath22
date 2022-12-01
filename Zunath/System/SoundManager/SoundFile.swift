//
//  SoundManager.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 11/11/22.
//
import AVKit

public protocol SoundFile {
    var filename: String { get }
    var type: String { get }
}

public struct Music: SoundFile {
    public var filename: String
    public var type: String
}

public struct Effect: SoundFile {
    public var filename: String
    public var type: String
}


