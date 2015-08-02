//
//  AVAudioPlayer+Creation.m
//  World
//
//  Created by Andrei Vidrasco on 8/2/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "AVAudioPlayer+Creation.h"

@implementation AVAudioPlayer (Creation)

+ (AVAudioPlayer *)audioPlayerWithSoundName:(NSString *)soundName {
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
    if (!soundFilePath) soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"];
    if (!soundFilePath) return nil;
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    [audioPlayer prepareToPlay];
    
    return audioPlayer;
}

@end
