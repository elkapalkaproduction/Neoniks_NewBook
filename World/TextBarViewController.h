//
//  TextBarViewController.h
//  World
//
//  Created by Andrei Vidrasco on 7/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextBarDelegate <NSObject>

@optional
- (void)soundDidFinish;

@end

@interface TextBarViewController : UIView

+ (instancetype)instantiate;
@property (weak, nonatomic) id<TextBarDelegate> delegate;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) BOOL object;

- (void)stopStound;

@end
