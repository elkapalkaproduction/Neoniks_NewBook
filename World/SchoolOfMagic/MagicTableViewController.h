//
//  MagicTableViewController.h
//  World
//
//  Created by Andrei Vidrasco on 2/1/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "BaseViewController.h"

@protocol MagicTableDelegate <NSObject>

- (void)prizeDidAppear;
- (void)stopPlayerIfIsPlaying;

@end

@interface MagicTableViewController : BaseViewController

@property (weak, nonatomic) id<MagicTableDelegate> delegate;

@end
