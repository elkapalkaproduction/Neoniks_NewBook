//
//  WYPopoverOverlayView.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol WYPopoverOverlayViewDelegate;

@interface WYPopoverOverlayView : UIView {
    BOOL _testHits;
}

@property (nonatomic, assign) id <WYPopoverOverlayViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) NSArray *passthroughViews;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - WYPopoverOverlayViewDelegate

@protocol WYPopoverOverlayViewDelegate <NSObject>

@optional
- (BOOL)dismissOnPassthroughViewTap;
- (void)popoverOverlayViewDidTouch:(WYPopoverOverlayView *)overlayView;

@end
