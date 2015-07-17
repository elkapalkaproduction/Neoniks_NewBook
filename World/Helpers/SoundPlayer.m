//
//  SoundPlayer.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "SoundPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *correctAnswerPlayer;
@property (strong, nonatomic) AVAudioPlayer *wrongAnswerPlayer;

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


- (AVAudioPlayer *)audioPlayerWithSoundName:(NSString *)soundName {
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
    if (!soundFilePath) return nil;
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    
    return audioPlayer;
}


- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [self audioPlayerWithSoundName:@"button_click.mp3"];
        [_audioPlayer prepareToPlay];
    }
    
    return _audioPlayer;
}


- (AVAudioPlayer *)correctAnswerPlayer {
    if (!_correctAnswerPlayer) {
        _correctAnswerPlayer = [self audioPlayerWithSoundName:@"right.mp3"];
    }
    
    return _correctAnswerPlayer;
}


- (AVAudioPlayer *)wrongAnswerPlayer {
    if (!_wrongAnswerPlayer) {
        _wrongAnswerPlayer = [self audioPlayerWithSoundName:@"wrong.mp3"];
    }
    
    return _wrongAnswerPlayer;
}


- (void)playClick {
    [self.audioPlayer play];
}


- (void)playCorrectAnswer {
    [self.correctAnswerPlayer play];
}


- (void)playWrongAnswer {
    [self.wrongAnswerPlayer play];
}

@end
