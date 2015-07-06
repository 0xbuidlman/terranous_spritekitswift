//
//  GameSettings.swift
//  Terranous
//
//  Created by Jeremy Novak on 7/5/15.
//  Copyright (c) 2015 Jeremy Novak. All rights reserved.
//

import Foundation

let GameSettingsSharedInstance = GameSettings()

class GameSettings {
    
    class var sharedInstance:GameSettings {
        return GameSettingsSharedInstance
    }
    
    // MARK: - Private class properties
    private let localDefaults = NSUserDefaults.standardUserDefaults()
    private let keyFirstRun = "FirstRun"
    private let keyBestStars = "BestStars"
    private let keyBestScore = "BestScore"
    private let keyMusicEnabled = "MusicEnabled"
    private let keyMusicVolume = "MusicVolume"
    private let keyLaunchedSessions = "LaunchedSessions"
    private let keyNeverRate = "NeverRate"
    
    private let promptSessions = 4
    private var launchedSessions = 0
    
    // MARK: - Public class properties
    
    // MARK: - Init
    init() {
        if self.localDefaults.objectForKey(keyFirstRun) == nil {
            self.firstLaunch()
        }
    }
    
    // MARK: - Private Functions
    private func firstLaunch() {
        self.localDefaults.setInteger(0, forKey: keyBestScore)
        self.localDefaults.setInteger(0, forKey: keyBestStars)
        self.localDefaults.setBool(true, forKey: keyMusicEnabled)
        self.localDefaults.setFloat(0.5, forKey: keyMusicVolume)
        self.localDefaults.setInteger(0, forKey: keyLaunchedSessions)
        self.localDefaults.setBool(false, forKey: keyFirstRun)
        self.localDefaults.setBool(false, forKey: keyNeverRate)
        self.localDefaults.synchronize()
    }
    
    // MARK: - Public saving functions
    func saveStarsCollected(collected: Int) {
        self.localDefaults.setInteger(collected, forKey: keyBestStars)
        self.localDefaults.synchronize()
    }
    
    func saveBestScore(score: Int) {
        self.localDefaults.setInteger(score, forKey: keyBestScore)
        self.localDefaults.synchronize()
    }
    
    func saveMusicVolume(volume: Float) {
        self.localDefaults.setFloat(volume, forKey: keyMusicVolume)
        self.localDefaults.synchronize()
    }
    
    func saveMusicEnabled(enabled: Bool) {
        self.localDefaults.setBool(enabled, forKey: keyMusicEnabled)
        self.localDefaults.synchronize()
    }
    
    func saveNeverRate() {
        self.localDefaults.setBool(true, forKey: keyNeverRate)
        self.localDefaults.synchronize()
    }
    
    // MARK: - Public retreiving functions
    func getBestStars() -> Int {
        return self.localDefaults.integerForKey(keyBestStars)
    }
    
    func getBestScore() -> Int {
        return self.localDefaults.integerForKey(keyBestScore)
    }
    
    func getMusicEnabled() -> Bool {
        return self.localDefaults.boolForKey(keyMusicEnabled)
    }
    
    func getMusicVolume() -> Float {
        return self.localDefaults.floatForKey(keyMusicVolume)
    }
    
    // MARK: - Launch count
    func shouldRateApp() -> Bool {
        if self.localDefaults.boolForKey(keyNeverRate) == false || localDefaults.objectForKey(keyNeverRate) == nil {
            self.launchedSessions = self.localDefaults.integerForKey(keyLaunchedSessions)
            self.launchedSessions++
            self.localDefaults.setInteger(self.launchedSessions, forKey: keyLaunchedSessions)
            self.localDefaults.setBool(false, forKey: keyNeverRate)
            self.localDefaults.synchronize()
            
            return self.launchedSessions % self.promptSessions == 0 ? true : false
        } else {
            return false
        }
    }
}