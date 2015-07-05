//
//  MoveableButton.m
//  StrangeParcel
//

#import "DragableButton.h"

@interface DragableButton () <UIGestureRecognizerDelegate>

@property (assign, nonatomic) CGFloat lastScale;
@property (assign, nonatomic) CGFloat lastRotation;
@property (assign, nonatomic) CGFloat firstX;
@property (assign, nonatomic) CGFloat firstY;

@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;

@end

@implementation DragableButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGesturesRecognizer];
    }

    return self;
}


- (UIPanGestureRecognizer *)panRecognizer {
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        _panRecognizer.minimumNumberOfTouches = 1;
        _panRecognizer.maximumNumberOfTouches = 1;
        _panRecognizer.delegate = self;
    }

    return _panRecognizer;
}


- (void)move:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [sender translationInView:self.superview];

    if ([sender state] == UIGestureRecognizerStateBegan) {
        self.firstX = [self center].x;
        self.firstY = [self center].y;
        if ([self.delegate respondsToSelector:@selector(didStartDragButton:)]) {
            [self.delegate didStartDragButton:self];
        }
    }
    translatedPoint = CGPointMake(self.firstX + translatedPoint.x, self.firstY + translatedPoint.y);

    [self setCenter:translatedPoint];
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self performActionsWithGesture:sender];
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}


- (void)performActionsWithGesture:(UIGestureRecognizer *)gesture {
    if (![self.delegate respondsToSelector:@selector(correctTargetPositionForButton:)]) return;
    BOOL correctPosition = [self.delegate correctTargetPositionForButton:self];
    if (correctPosition) {
        [self removeDragableProperty];
        if ([self.delegate respondsToSelector:@selector(putButtonOnRightPosition:)]) {
            [self.delegate putButtonOnRightPosition:self];
        }
    } else {
        [UIView animateWithDuration:0.4 animations:^{
             self.center = CGPointMake(self.firstX, self.firstY);
         }];
    }
}


- (void)setupGesturesRecognizer {
    [self addGestureRecognizer:self.panRecognizer];
}


- (void)removeDragableProperty {
    [self removeGestureRecognizer:self.panRecognizer];
}

@end
