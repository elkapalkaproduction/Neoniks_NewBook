//
//  MoveableButton.h
//  World
//
//  Created by Andrei Vidrasco on 2/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NNKShapedButton.h"
@class DragableButton;

@protocol DragableButtonDelegate <NSObject>

- (BOOL)correctTargetPositionForButton:(DragableButton *)button;
@end

@interface DragableButton : NNKShapedButton

@property (assign, nonatomic) CGRect correctRect;
@property (weak, nonatomic) id <DragableButtonDelegate> delegate;

@end
