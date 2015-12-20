//
//  DragableSpriteNode.m
//  World
//
//  Created by Andrei Vidrasco on 9/16/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "DragableSpriteNode.h"

@interface DragableSpriteNode ()

@property (assign, nonatomic) BOOL imutable;
@property (assign, nonatomic) CGPoint initialPos;

@end

@implementation DragableSpriteNode

- (void)move:(UIPanGestureRecognizer *)sender {
    if (self.imutable) return;
    CGPoint translatedPoint = [sender translationInView:sender.view];
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(didStartDragButton:)]) {
            [self.delegate didStartDragButton:self];
        }
        self.initialPos = self.position;
    }
    self.position = CGPointMake(self.initialPos.x + translatedPoint.x * 3000 / self.parent.frame.size.width,
                                self.initialPos.y - translatedPoint.y * 3600 / self.parent.frame.size.height);
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self performActionsWithGesture:sender];
    }
}


- (void)performActionsWithGesture:(UIGestureRecognizer *)gesture {
    if (![self.delegate respondsToSelector:@selector(correctTargetPositionForButton:)]) return;
    BOOL correctPosition = [self.delegate correctTargetPositionForButton:self];
    if (!correctPosition) return;
    self.imutable = YES;
    if ([self.delegate respondsToSelector:@selector(putButtonOnRightPosition:)]) {
        [self.delegate putButtonOnRightPosition:self];
    }
}

@end
