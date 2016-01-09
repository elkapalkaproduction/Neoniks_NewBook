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
#import "Storage.h"

typedef NS_ENUM(NSInteger, IslandToFind) {
    IslandToFindSchool,
    IslandToFindHouse,
    IslandToFindCafe,
    IslandToFindLighthouse,
    IslandToFindMuseum,
    IslandToFindCastle,
    IslandToFindBottomles,
    IslandToFindSolvedAll,
};

@interface NSMutableArray (ArchUtils_Shuffle)
- (void)shuffle;

- (NSArray *)addArray:(NSArray *)array;
- (NSArray *)appendObject:(id)object;

- (id)removeLast;

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


- (NSArray *)addArray:(NSArray *)array {
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self];
    [newArray addObjectsFromArray:array];
    
    return newArray;
}


- (NSArray *)appendObject:(id)object {
    if (!object) return self;
    
    return [self addArray:@[object]];
}


- (id)removeLast {
    id obj = self.lastObject;
    [self removeLastObject];
    
    return obj;
}

@end

NSString *const LastSolvedIsland = @"LastSolvedIsland";

@interface IslandViewModel () <PopUpDelegate>

@property (strong, nonatomic) UIImage *answersImage;
@property (strong, nonatomic) NSMutableArray *answersColor;
@property (strong, nonatomic) NSMutableArray *foundedAnswers;
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


- (NSMutableArray *)answersColor {
    if (!_answersColor) {
        [self loadArrays];
    }
    
    return _answersColor;
}


- (NSMutableArray *)foundedAnswers {
    if (!_foundedAnswers) {
        [self loadArrays];
    }
    
    return _foundedAnswers;
}


- (void)loadArrays {
    NSString *fileName = @"answers_colors.plist";
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSArray *answersColor = [[NSArray alloc] initWithContentsOfFile:bundlePath];
    self.foundedAnswers = [[NSMutableArray alloc] init];
    self.answersColor = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < IslandToFindSolvedAll; i++) {
        if ([Storage loadIntegerForKey:[self keyForIndex:i]]) {
            [self.foundedAnswers addObject:answersColor[i]];
        } else {
            [self.answersColor addObject:answersColor[i]];
        }
    }
    [self.answersColor shuffle];
}


- (UIImage *)answersImage {
    if (!_answersImage) {
        _answersImage = [UIImage imageNamed:@"Island_Answers"];
    }
    
    return _answersImage;
}


- (void)didTapOnPoint:(CGPoint)point {
    UIColor *pixelColor = [self.answersImage colorAtPixel:point];
    BOOL find = [pixelColor isEqual:[self correctColorForIndex:[self currentNeedToFind]]];
    if (find) {
        NSInteger currentToFind = [self currentNeedToFind];
        [self.foundedAnswers addObject:[self.answersColor removeLast]];
        [Storage saveInteger:1 forKey:[self keyForIndex:currentToFind]];
        [[SoundPlayer sharedPlayer] playCorrectAnswer];
        [self.delegate openPopUpViewController:[self popUpForIndex:currentToFind]];
        [self increaeCurrentAnswer];
    } else {
        BOOL foundSomething = NO;
        for (NSInteger index = 0; index < self.foundedAnswers.count; index++) {
            NSInteger idx = [self.foundedAnswers[index][@"idx"] integerValue];
            BOOL openPopUp = [pixelColor isEqual:[self correctColorForIndex:idx]];
            if (openPopUp) {
                foundSomething = YES;
                [self.delegate openPopUpViewController:[self popUpForIndex:idx]];
            }
        }
        if (!foundSomething && [self currentNeedToFind] != IslandToFindSolvedAll) {
            [[SoundPlayer sharedPlayer] playWrongAnswer];
        }
    }
}


- (UIColor *)correctColorForIndex:(NSInteger)index {
    NSDictionary *dict;
    for (NSDictionary *color in [self.foundedAnswers appendObject:self.answersColor.lastObject]) {
        if ([color[@"idx"] integerValue] == index) {
            dict = color;
        }
    }
    if (!dict) return nil;
    CGFloat red = [dict[@"red"] floatValue] / 255.f;
    CGFloat green = [dict[@"green"] floatValue] / 255.f;
    CGFloat blue = [dict[@"blue"] floatValue] / 255.f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
}


- (NSInteger)currentNeedToFind {
    if (0 == [self.answersColor count]) {
        return IslandToFindSolvedAll;
    }
    
    return [self.answersColor.lastObject[@"idx"] integerValue];
    
}


- (NSInteger)maxSolved {
    return [Storage loadIntegerForKey:LastSolvedIsland];
}


- (void)increaeCurrentAnswer {
    IslandToFind current = [self maxSolved];
    if (current != IslandToFindSolvedAll) {
        current++;
    }
    [Storage saveInteger:current forKey:LastSolvedIsland];
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
    self.answersColor = nil;
    [self.delegate updateInterface];
}


+ (void)deleteAnswers {
    for (int i = 0; i < IslandToFindSolvedAll; i++) {
        [Storage saveInteger:0 forKey:[self keyForIndex:i]];
    }
    [Storage saveInteger:0 forKey:LastSolvedIsland];
}


- (BOOL)foundAll {
    return [self maxSolved] == IslandToFindSolvedAll;
}


+ (NSString *)keyForIndex:(IslandToFind)index {
    return [NSString stringWithFormat:@"inslandToFind%ld", index];
}


- (NSString *)keyForIndex:(IslandToFind)index {
    return [[self class] keyForIndex:index];
}

@end
