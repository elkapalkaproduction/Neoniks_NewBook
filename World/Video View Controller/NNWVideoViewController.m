//
//  ViewController.m
//  NewWorld
//
//  Created by Andrei Vidrasco on 12/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNWVideoViewController.h"

NSString *const SVPVideoTitleImageName = @"video_title";
NSString *const SVPVideoPlayImageName = @"video_play";
NSString *const SVPVideoPauseImageName = @"video_pause";
NSString *const SVPVideoPath = @"start_video_path";

@import MediaPlayer;

@interface NNWVideoViewController ()

@property (weak, nonatomic) IBOutlet UIView *playerSuperview;
@property (weak, nonatomic) IBOutlet UIButton *mediaControlButton;
@property (strong, nonatomic) MPMoviePlayerController *videoPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@end

@implementation NNWVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleImage.image = [UIImage imageNamed:NSLocalizedString(SVPVideoTitleImageName, nil)];
    [self.playerSuperview addSubview:self.videoPlayer.view];
    [self.videoPlayer play];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinishedNotification:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.videoPlayer];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (MPMoviePlayerController *)videoPlayer {
    if (_videoPlayer) {
        return _videoPlayer;
    }
    MPMoviePlayerController *videoPlayer = [[MPMoviePlayerController alloc] init];
    videoPlayer.shouldAutoplay = NO;
    videoPlayer.movieSourceType = MPMovieSourceTypeFile;
    videoPlayer.fullscreen = YES;
    videoPlayer.controlStyle = MPMovieControlStyleNone;
    videoPlayer.view.userInteractionEnabled = NO;
    videoPlayer.contentURL = [NSURL URLWithString:NSLocalizedString(SVPVideoPath, nil)];
    _videoPlayer = videoPlayer;
    
    return _videoPlayer;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.videoPlayer.view.frame = self.playerSuperview.bounds;
}


- (void)playbackFinishedNotification:(NSNotification *)notification {
    [self changeButtonImageToPauseState];
}


- (IBAction)changePlayerState {
    if ([self isPlayingVideo]) {
        [self.videoPlayer pause];
        [self changeButtonImageToPauseState];
    } else {
        [self.videoPlayer play];
        [self changeButtonImageToPlayState];
    }
}


- (void)changeButtonImageToPauseState {
    [self.mediaControlButton setImage:[UIImage imageNamed:SVPVideoPlayImageName] forState:UIControlStateNormal];
}


- (void)changeButtonImageToPlayState {
    [self.mediaControlButton setImage:[UIImage imageNamed:SVPVideoPauseImageName] forState:UIControlStateNormal];
}


- (BOOL)isPlayingVideo {
    return self.videoPlayer.playbackState == MPMoviePlaybackStatePlaying;
}

@end
