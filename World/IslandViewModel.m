//
//  IslandViewModel.m
//  World
//
//  Created by Andrei Vidrasco on 3/7/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "IslandViewModel.h"
#import "PopUpViewController.h"

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
        _answersColor = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answers_colors.plist" ofType:nil]];
    }
    
    return _answersColor;
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
        [self.delegate openPopUpViewController:[self popUpForIndex:[self currentNeedToFind]]];
        [self increaeCurrentAnswer];
    } else {
        for (NSInteger index = 0; index < [self currentNeedToFind]; index++) {
            BOOL openPopUp = [pixelColor isEqual:[self correctColorForIndex:index]];
            if (openPopUp) {
                [self.delegate openPopUpViewController:[self popUpForIndex:index]];
            }
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
    return [[NSUserDefaults standardUserDefaults] integerForKey:LastSolvedIsland];
}

- (void)increaeCurrentAnswer {
    IslandToFind current = [self currentNeedToFind];
    if (current != IslandToFindSolvedAll) {
        current++;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:current forKey:LastSolvedIsland];
}


- (PopUpViewController *)popUpForIndex:(NSInteger)index {
    NSString *text = [NSString stringWithFormat:@"island_popup_description_%ld", (long)index];
    NSString *mainImageName = [NSString stringWithFormat:@"pop_up_image_%ld", (long)index];
    NSString *bannerImageName = [NSString stringWithFormat:@"pop_up_banner_%ld", (long)index];
    PopUpViewController *popUp = [PopUpViewController instantiateWithMainImage:[UIImage imageNamed:mainImageName]
                                                                   bannerImage:[UIImage imageNamed:NSLocalizedString(bannerImageName, nil)]
                                                                          text:NSLocalizedString(text, nil)
                                                                      delegate:self];

    return popUp;
}


- (void)didClosePopUp {
    [self.delegate updateInterface];
}


- (void)resetAnswers {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:LastSolvedIsland];
    [self.delegate updateInterface];
}

@end
