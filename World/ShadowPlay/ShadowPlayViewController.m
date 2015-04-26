//
//  ShadowPlayViewController.m
//  World
//
//  Created by Andrei Vidrasco on 2/2/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "ShadowPlayViewController.h"
#import "CharacterShadowViewController.h"
#import "ShadowPlayOpenedHandler.h"
#import "DragableButton.h"

NSString *const NSPSegueIdentifierPattern = @"character";

NSString *const NSPTextPatternDescription = @"shadow_description_%ld";
NSString *const NSPImagePatternPortraitColor = @"full_portret_color_%ld";
NSString *const NSPImagePatternPortraitShadow = @"full_portret_shadow_%ld";

NSString *const NSPImageNameTitle = @"shadow_title";
NSString *const NSPFileNameWrongPosition = @"shadow_wrong_position.plist";
NSString *const NSPFileNameCorrectPosition = @"shadow_correct_position.plist";

@interface ShadowPlayViewController () <CharacterShadowDelegate, DragableButtonDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIView *viewForElements;
@property (weak, nonatomic) IBOutlet UIView *viewForResults;
@property (weak, nonatomic) IBOutlet UIImageView *fullPortret;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (assign, nonatomic) ShadowCharacter loadedCharacter;
@property (strong, nonatomic) NSMutableArray *shadowElements;
@property (strong, nonatomic) NSMutableSet *arrayOfSegues;
@property (weak, nonatomic, readonly) NSDictionary *wrongAnswers;
@property (weak, nonatomic, readonly) NSDictionary *correctAnswers;
@property (assign, nonatomic, readonly) CGFloat imageRatio;

@end

@implementation ShadowPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shadowElements = [[NSMutableArray alloc] init];
    self.descriptionLabel.font = [UIFont baseFontOfSize:[UIDevice isIpad] ? 30 : 18];
    self.bannerImage.image = [UIImage imageNamed:NSLocalizedString(NSPImageNameTitle, nil)];
    self.loadedCharacter = ShadowCharacterJay;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self didPressCharacter:self.loadedCharacter];
    self.viewForElements.hidden = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self didPressCharacter:self.loadedCharacter];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier rangeOfString:NSPSegueIdentifierPattern].location != NSNotFound) {
        if (self.arrayOfSegues) {
            [self.arrayOfSegues addObject:segue];
        } else {
            self.arrayOfSegues = [[NSMutableSet alloc] initWithObjects:segue, nil];
        }
    }
}


- (void)setLoadedCharacter:(ShadowCharacter)loadedCharacter {
    _loadedCharacter = loadedCharacter;
    [self updateCharactersMenuInformation];
}


- (NSDictionary *)wrongAnswers {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSPFileNameWrongPosition ofType:nil];
    
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}


- (NSDictionary *)correctAnswers {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSPFileNameCorrectPosition ofType:nil];
    
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}


- (void)didPressCharacter:(ShadowCharacter)character {
    self.loadedCharacter = character;
    if ([[ShadowPlayOpenedHandler sharedHandler] isOpenedCharacter:character]) {
        [self loadUnlockedCharacter:character];
    } else {
        [self loadLockedCharacter:character];
    }
}


- (void)removeAllShadowsFromTheScreen {
    [self.shadowElements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.shadowElements removeAllObjects];
}


- (void)loadShadowsForCharacter:(ShadowCharacter)character {
    [self removeAllShadowsFromTheScreen];
    NSString *key = [NSString stringWithFormat:@"character%ld", character];
    NSDictionary *wrongCharacterPositions = self.wrongAnswers[key];
    NSDictionary *correctCharacterPositions = self.correctAnswers[key];
    NSArray *allKeys = [wrongCharacterPositions allKeys];
    for (NSString *currentKey in allKeys) {
        [self createShadowElement:[UIImage imageNamed:currentKey]
              wrongCharacterPositions:CGPointFromString(wrongCharacterPositions[currentKey])
            correctCharacterPositions:CGRectFromString(correctCharacterPositions[currentKey])];
    }
}


- (CGRect)scaledRectFromRect:(CGRect)rect {
    CGRect newRect = rect;
    newRect.origin.x *= self.imageRatio;
    newRect.origin.y *= self.imageRatio;
    newRect.size.width *= self.imageRatio;
    newRect.size.height *= self.imageRatio;
    
    return newRect;
}


- (CGFloat)imageRatio {
    return self.fullPortret.frame.size.width / 814;
}


- (void)hideShadowsAndMarksAsSolved {
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:self.loadedCharacter];
    if ([[[ShadowPlayOpenedHandler sharedHandler] allOpenedCharacter] count] == 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Now you should see prize"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateCharactersMenuInformation];
    [self.shadowElements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.3 animations:^{
            [obj setAlpha:0.f];
        } completion:^(BOOL finished) {
            [obj removeFromSuperview];
            [self loadUnlockedCharacter:self.loadedCharacter];
        }];
    }];
}


- (void)putButton:(DragableButton *)button onRightFrame:(CGRect)newFrame {
    [button removeFromSuperview];
    [self.viewForResults addSubview:button];
    [button setFrame:newFrame];
    [UIView animateWithDuration:0.4 animations:^{
        [button setFrame:button.correctRect];
    } completion:^(BOOL finished) {
        if ([self.viewForElements.subviews count] == 0) {
            [self hideShadowsAndMarksAsSolved];
        }
    }];
}


- (BOOL)correctTargetPositionForButton:(DragableButton *)button {
    CGRect newFrame = [button.superview convertRect:button.frame toView:self.viewForResults];
    if (CGRectIntersectsRect(newFrame, button.correctRect)) {
        [self putButton:button onRightFrame:newFrame];
        
        return YES;
    }
    
    return NO;
}


- (CharactersInteraction)characterInteractionForCharacter:(ShadowCharacter)character {
    if ([[ShadowPlayOpenedHandler sharedHandler] isOpenedCharacter:character]) {
        return CharactersInteractionOpened;
    }
    if (self.loadedCharacter == character) {
        return CharactersInteractionSelected;
    }
    
    return CharactersInteractionClosed;
}


- (void)updateCharactersMenuInformation {
    for (UIStoryboardSegue *segue in self.arrayOfSegues) {
        [self updateCharacterInfoFromSegue:segue];
    }
}


- (void)updateCharacterInfoFromSegue:(UIStoryboardSegue *)segue {
    NSString *identifier = [segue.identifier stringByReplacingOccurrencesOfString:NSPSegueIdentifierPattern withString:@""];
    NSInteger characterID = [identifier integerValue];
    CharacterShadowViewController *character = segue.destinationViewController;
    character.delegate = self;
    CharactersInteraction characterInteraction = [self characterInteractionForCharacter:characterID];
    [character updateInterfaceWithCharacter:characterID characterInteraction:characterInteraction];
}


- (void)loadUnlockedCharacter:(ShadowCharacter)character {
    NSString *string = [NSString stringWithFormat:NSPTextPatternDescription, character];
    self.descriptionLabel.text = NSLocalizedString(string, nil);
    self.fullPortret.image = [UIImage imageNamed:[NSString stringWithFormat:NSPImagePatternPortraitColor, character]];
    self.viewForElements.hidden = YES;
    self.descriptionLabel.hidden = NO;
}


- (void)loadLockedCharacter:(ShadowCharacter)character {
    self.descriptionLabel.hidden = YES;
    self.fullPortret.image = [UIImage imageNamed:[NSString stringWithFormat:NSPImagePatternPortraitShadow, character]];
    self.viewForElements.hidden = NO;
    [self loadShadowsForCharacter:character];
}


- (void)createShadowElement:(UIImage *)image
    wrongCharacterPositions:(CGPoint)wrongCharacterPositions
  correctCharacterPositions:(CGRect)correctCharacterPositions {
    CGRect frame;
    frame.origin = wrongCharacterPositions;
    frame.size = correctCharacterPositions.size;
    DragableButton *shadow = [[DragableButton alloc] initWithFrame:[self scaledRectFromRect:frame]];
    shadow.correctRect = [self scaledRectFromRect:correctCharacterPositions];
    shadow.delegate = self;
    [shadow setImage:image forState:UIControlStateNormal];
    [self.shadowElements addObject:shadow];
    [self.viewForElements addSubview:shadow];
}

@end
