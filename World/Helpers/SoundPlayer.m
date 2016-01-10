//
//  SoundPlayer.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "SoundPlayer.h"
#import "AVAudioPlayer+Creation.h"

@interface SoundPlayer ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *correctAnswerPlayer;
@property (strong, nonatomic) AVAudioPlayer *wrongAnswerPlayer;
@property (strong, nonatomic) AVAudioPlayer *dsynPlayer;

@end

@implementation SoundPlayer

+ (instancetype)sharedPlayer {
    static SoundPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}


- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [AVAudioPlayer audioPlayerWithSoundName:@"button_click.mp3"];
        [_audioPlayer prepareToPlay];
    }
    
    return _audioPlayer;
}


- (AVAudioPlayer *)correctAnswerPlayer {
    if (!_correctAnswerPlayer) {
        _correctAnswerPlayer = [AVAudioPlayer audioPlayerWithSoundName:@"right.mp3"];
    }
    
    return _correctAnswerPlayer;
}


- (AVAudioPlayer *)wrongAnswerPlayer {
    if (!_wrongAnswerPlayer) {
        _wrongAnswerPlayer = [AVAudioPlayer audioPlayerWithSoundName:@"wrong.mp3"];
    }
    
    return _wrongAnswerPlayer;
}


- (AVAudioPlayer *)dsynPlayer {
    if (!_dsynPlayer) {
        _dsynPlayer = [AVAudioPlayer audioPlayerWithSoundName:@"dsyn.mp3"];
    }
    
    return _dsynPlayer;
}


- (void)playClick {
    self.audioPlayer.volume = SoundStatus.volume;
    [self.audioPlayer play];
}


- (void)playCorrectAnswer {
    self.correctAnswerPlayer.volume = SoundStatus.volume;
    [self.correctAnswerPlayer play];
}


- (void)playWrongAnswer {
    self.wrongAnswerPlayer.volume = SoundStatus.volume;
    [self.wrongAnswerPlayer play];
}


- (void)playDsyn {
    self.dsynPlayer.volume = SoundStatus.volume;
    [self.dsynPlayer play];
}

@end
