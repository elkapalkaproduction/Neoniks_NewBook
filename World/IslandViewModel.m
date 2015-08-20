//
//  IslandViewModel.m
//  World
//
//  Created by Andrei Vidrasco on 3/7/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "IslandViewModel.h"
#import "PopUpViewController.h"
#import "SoundPlayer.h"

@interface NSMutableArray (ArchUtils_Shuffle)
- (void)shuffle;

@end


static NSUInteger random_below(NSUInteger n) {
    NSUInteger m = 1;
    
    do {
        m <<= 1;
    } while(m < n);
    
    NSUInteger ret;
    
    do {
        ret = random() % m;
    } while(ret >= n);
    
    return ret;
}

@implementation NSMutableArray (ArchUtils_Shuffle)

- (void)shuffle {
    for (NSUInteger i = [self count]; i > 1; i--) {
        NSUInteger j = random_below(i);
        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
}

@end

NSString *const LastSolvedIsland = @"LastSolvedIsland";

@interface IslandViewModel () <PopUpDelegate>

@property (strong, nonatomic) UIImage *answersImage;
@property (strong, nonatomic) NSArray *answersColor;
@property (weak, nonatomic) id<IslandViewModelDelegate> delegate;

@end

@implementation IslandViewModel

- (instancetype)initWithDelegate:(id<IslandViewModelDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}


- (NSArray *)answersColor {
    if (!_answersColor) {
        _answersColor = [NSArray arrayWithArray:[self array]];
    }
    
    return _answersColor;
}


- (NSMutableArray *)array {
    NSString *fileName = @"answers_colors.plist";
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    
    NSMutableArray *answersColor = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if (!answersColor) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        answersColor = [[NSMutableArray alloc] initWithContentsOfFile:bundlePath];
    }
    if ([self maxSolved] == 0) {
        [answersColor shuffle];
    }
    
    [answersColor writeToFile:path atomically:YES];
    
    return answersColor;
}


- (UIImage *)answersImage {
    if (!_answersImage) {
        _answersImage = [UIImage imageNamed:@"Island_Answers"];
    }
    
    return _answersImage;
}


- (void)didTapOnPoint:(CGPoint)point {
    UIColor *pixelColor = [self.answersImage colorAtPixel:point];
    BOOL find = [pixelColor isEqual:[self correctColorForIndex:[self maxSolved]]];
    if (find) {
        [[SoundPlayer sharedPlayer] playCorrectAnswer];
        [self.delegate openPopUpViewController:[self popUpForIndex:[self currentNeedToFind]]];
        [self increaeCurrentAnswer];
    } else {
        BOOL foundSomething = NO;
        for (NSInteger index = 0; index < [self currentNeedToFind]; index++) {
            BOOL openPopUp = [pixelColor isEqual:[self correctColorForIndex:index]];
            if (openPopUp) {
                foundSomething = YES;
                [self.delegate openPopUpViewController:[self popUpForIndex:index]];
            }
        }
        if (!foundSomething && [self currentNeedToFind] != IslandToFindSolvedAll) {
            [[SoundPlayer sharedPlayer] playWrongAnswer];
        }
    }
}


- (UIColor *)correctColorForIndex:(NSInteger)index {
    if (index == [self.answersColor count]) {
        return nil;
    }
    NSDictionary *dict = self.answersColor[index];
    CGFloat red = [dict[@"red"] floatValue] / 255.f;
    CGFloat green = [dict[@"green"] floatValue] / 255.f;
    CGFloat blue = [dict[@"blue"] floatValue] / 255.f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
}


- (IslandToFind)currentNeedToFind {
    IslandToFind maxSolved = [self maxSolved];
    if (maxSolved >= [self.answersColor count]) {
        return IslandToFindSolvedAll;
    }
    
    return [self.answersColor[maxSolved][@"idx"] integerValue];
    
}


- (IslandToFind)maxSolved {
    return [[NSUserDefaults standardUserDefaults] integerForKey:LastSolvedIsland];
    
}


- (void)increaeCurrentAnswer {
    IslandToFind current = [self maxSolved];
    if (current != IslandToFindSolvedAll) {
        current++;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:current forKey:LastSolvedIsland];
}


- (PopUpViewController *)popUpForIndex:(NSInteger)index {
    PopUpViewController *popUp = [PopUpViewController instantiateWithType:index delegate:self];
    
    return popUp;
}


- (void)didClosePopUp {
    [self.delegate updateInterface];
}


- (void)resetAnswers {
    [[self class] deleteAnswers];
    [self.delegate updateInterface];
}


+ (void)deleteAnswers {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:LastSolvedIsland];
}

@end
