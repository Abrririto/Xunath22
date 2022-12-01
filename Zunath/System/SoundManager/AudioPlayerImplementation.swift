//
//  AudioPlayerImplementation.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 11/11/22.
//

import AVKit

protocol AudioPlayer {
    var musicVolume: Float { get set }
    func play(music: Music)
    func playInLoop(music: Music)
    func pause(music: Music)
    
    var effectsVolume: Float { get set }
    func play(effect: Effect)
}

class AudioPlayerImpl {
    static var shared = AudioPlayerImpl()
    
    private init () { }
    
    private var currentMusicPlayer: AVAudioPlayer?
    private var currentEffectPlayer: AVAudioPlayer?
    
    private var simultaneosMusicPlayer: [AVAudioPlayer]?
    
    var musicVolume: Float = 1.0 {
        didSet {
            currentMusicPlayer?.volume = musicVolume
        }
    }
    
    var effectsVolume: Float = 1.0
}

extension AudioPlayerImpl: AudioPlayer {
    func playInLoop(music: Music) {
        currentMusicPlayer?.stop()
        guard let newPlayer = try? AVAudioPlayer(soundFile: music) else { return }
        newPlayer.volume = musicVolume
        newPlayer.play()
        newPlayer.numberOfLoops = -1
        currentMusicPlayer = newPlayer
    }
    
    func playManyAudios(musics: [Music]) {
        currentMusicPlayer?.stop()
        
        for music in musics {
            guard let player = try? AVAudioPlayer(soundFile: music) else { return }
            player.volume = musicVolume
            player.play()
            simultaneosMusicPlayer?.append(player)
        }
    }
    
    func play(music: Music) {
        currentMusicPlayer?.stop()
        guard let newPlayer = try? AVAudioPlayer(soundFile: music) else { return }
        newPlayer.volume = musicVolume
        newPlayer.play()
        currentMusicPlayer = newPlayer
    }
    
    func pause(music: Music) {
        currentMusicPlayer?.pause()
    }
    
    func pauseAll() {
        guard let simultaneosMusic = simultaneosMusicPlayer else { return }
        for music in simultaneosMusic {
            music.pause()
        }
    }
    
    func play(effect: Effect) {
        guard let effectPlayer = try? AVAudioPlayer(soundFile: effect) else { return }
        effectPlayer.volume = effectsVolume
        effectPlayer.play()
        currentEffectPlayer = effectPlayer
    }
}
