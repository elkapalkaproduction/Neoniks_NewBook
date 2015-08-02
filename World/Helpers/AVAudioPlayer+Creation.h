//
//  AVAudioPlayer+Creation.h
//  World
//
//  Created by Andrei Vidrasco on 8/2/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (Creation)

+ (AVAudioPlayer *)audioPlayerWithSoundName:(NSString *)soundName;

@end
