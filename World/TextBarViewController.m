//
//  TextBarViewController.m
//  World
//
//  Created by Andrei Vidrasco on 7/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "TextBarViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TextBarViewController () <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *objectIcon;
@property (weak, nonatomic) IBOutlet UIImageView *characterIcon;

@property (strong, nonatomic) NSString *soundName;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXLabel;

@end

@implementation TextBarViewController

+ (instancetype)instantiate {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TextBarViewController class])
                                          owner:self
                                        options:nil] firstObject];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.font = [UIFont baseFontOfSize:12.f];
}


- (void)setImage:(UIImage *)image {
    self.objectIcon.image = image;
    self.characterIcon.image = image;
}


- (void)setObject:(BOOL)object {
    self.objectIcon.hidden = !object;
    self.centerXLabel.constant = (object ? -self.objectIcon.frame.size.width : self.characterIcon.frame.size.width) / 2;
    self.characterIcon.hidden = object;
}


- (void)setText:(NSString *)text {
    self.label.text = NSLocalizedString(text, nil);
    self.soundName = [text stringByAppendingString:@"_sound"];
}


- (void)setSoundName:(NSString *)soundName {
    _soundName = NSLocalizedString(soundName, nil);
    [self stopStound];
    self.player.volume = SoundStatus.volume;
    [self.player play];
}


- (AVAudioPlayer *)player {
    if (!_player) {
        if (!self.soundName) return nil;
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:self.soundName ofType:@"mp3"];
        if (!soundFilePath) return nil;
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        [_player prepareToPlay];
        _player.delegate = self;
    }
    
    return _player;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(textBarSoundDidFinish:)]) {
        [self.delegate textBarSoundDidFinish:self];
    }
    if (self.block) self.block();
}


- (void)updateVolume {
    self.player.volume = SoundStatus.volume;
}


- (void)stopStound {
    [self.player stop];
    self.player = nil;
}


- (void)stop {
    self.block = nil;
    [self stopStound];
}

@end
