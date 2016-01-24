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
#import "InventaryContentHandler.h"
#import "MyScene.h"
#import "NNKMinerNode.h"
#import "NNKJayNode.h"
#import "NNKWandaNode.h"
#import "NNKHaroldNode.h"
#import "NNKFurcoatNode.h"
#import "NNKPhoebeNode.h"
#import "NNKJustacreepNode.h"
#import "NNKMystieNode.h"
#import "TextBarViewController.h"
#import "AVAudioPlayer+Creation.h"
#import "SoundPlayer.h"
#import "AlertViewController.h"

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
@property (weak, nonatomic) IBOutlet UIView *prizeView;
@property (weak, nonatomic) IBOutlet UIView *textBarSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *takeMeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBarBottomConstraint;

@property (assign, nonatomic) ShadowCharacter loadedCharacter;
@property (strong, nonatomic) NSMutableArray *shadowElements;
@property (strong, nonatomic) NSMutableSet *arrayOfSegues;
@property (strong, nonatomic) MyScene *scene;
@property (strong, nonatomic) SKView *skView;

@property (strong, nonatomic) TextBarViewController *textBar;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation ShadowPlayViewController

- (MyScene *)sceneWithFrame:(CGRect)frame node:(NNKSpriteNode *)node {
    MyScene *scene = [MyScene sceneWithSize:frame.size];
    scene.node = node;
    scene.backgroundColor = [UIColor clearColor];
    
    return scene;
}


- (SKView *)skViewWithSize:(CGRect)frame node:(NNKSpriteNode *)node {
    SKView *skView = [[SKView alloc] initWithFrame:frame];
    skView.allowsTransparency = YES;
    self.scene = [self sceneWithFrame:frame node:node];
    [skView presentScene:self.scene];
    
    return skView;
}


- (void)prepareSkView {
    CGRect frame = self.viewForResults.bounds;
    self.skView = [self skViewWithSize:frame node:nil];
    
    [self.viewForResults addSubview:self.skView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.shadowElements = [[NSMutableArray alloc] init];
    self.descriptionLabel.font = [UIFont baseFontOfSize:[UIDevice isIpad] ? 30 : 18];
    self.bannerImage.image = [UIImage imageLocalizableNamed:NSPImageNameTitle];
    self.takeMeImage.image = [UIImage imageLocalizableNamed:@"take_me_black"];
    self.loadedCharacter = ShadowCharacterJay;
    self.prizeView.hidden = YES;
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self didPressCharacter:self.loadedCharacter];
    [self.player stop];
    self.viewForElements.hidden = YES;
}


- (void)backButton:(id)sender {
    if ([self shouldShowPrize]) {
        [self showMagicWand];
    } else {
        self.arrayOfSegues = nil;
        [super backButton:sender];
        [self.textBar stopStound];
        [self.player stop];
        self.scene = nil;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareSkView];
    [self didPressCharacter:self.loadedCharacter];
    if ([self shouldShowWelcomeAlert]) {
        [self.player stop];
        [self openTextBarWithIcon:[UIImage imageNamed:@"text_panel_ginger"]
                             text:@"text_panel_shadow_initial"
                         isObject:NO];
        [self performSelector:@selector(closeTextBarWithCompletionBlock:) withObject:nil afterDelay:5.f];
    } else {
    }
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
    if (!self.prizeView.hidden) return;
    self.loadedCharacter = character;
    NSString *audioName = [NSString stringWithFormat:@"shadow_sound_%ld", self.loadedCharacter];
    self.player = [AVAudioPlayer audioPlayerWithSoundName:NSLocalizedString(audioName, nil)];
    if ([[ShadowPlayOpenedHandler sharedHandler] isOpenedCharacter:character]) {
        [self loadUnlockedCharacter:character];
        [self.textBar stopStound];
        self.player.volume = SoundStatus.volume;
        [self.player play];
    } else {
        [self loadLockedCharacter:character];
        [self.player stop];
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
    NSString *key = [NSString stringWithFormat:@"character%ld", (long)character];
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


- (BOOL)shouldShowPrize {
    InventaryIconShowing format = [[InventaryContentHandler sharedHandler] formatForItemType:InventaryBarIconTypeMagicWand];
    
    return [[[ShadowPlayOpenedHandler sharedHandler] allOpenedCharacter] count] == 8 && format == InventaryIconShowingEmpty;
}


- (void)hideShadowsAndMarksAsSolved {
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:self.loadedCharacter];
    
    [self updateCharactersMenuInformation];
    [self.shadowElements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.3 animations:^{
            [obj setAlpha:0.f];
        } completion:^(BOOL finished) {
            [obj removeFromSuperview];
            self.player.volume = SoundStatus.volume;
            [self.player play];
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
    [self removeAllShadowsFromTheScreen];
    [self.scene.node removeAllActions];
    self.viewForElements.hidden = YES;
    self.descriptionLabel.hidden = NO;
    self.prizeView.hidden = YES;
    NSString *string = [NSString stringWithFormat:NSPTextPatternDescription, (long)character];
    self.descriptionLabel.text = NSLocalizedString(string, nil);
    
    self.fullPortret.image = nil;
    self.scene.node = [self nodeForCharacter:character];
    
}


- (NNKSpriteNode *)nodeForCharacter:(ShadowCharacter)character {
    CGSize size = self.viewForResults.bounds.size;
    switch (character) {
        case ShadowCharacterJay:
            return [[NNKJayNode alloc] initWithSize:size];
        case ShadowCharacterWanda:
            return [[NNKWandaNode alloc] initWithSize:size];
        case ShadowCharacterFurcoat:
            return [[NNKFurcoatNode alloc] initWithSize:size];
        case ShadowCharacterMiner:
            return [[NNKMinerNode alloc] initWithSize:size];
        case ShadowCharacterHarold:
            return [[NNKHaroldNode alloc] initWithSize:size];
        case ShadowCharacterPhoebe:
            return [[NNKPhoebeNode alloc] initWithSize:size];
        case ShadowCharacterJustacreep:
            return [[NNKJustacreepNode alloc] initWithSize:size];
        case ShadowCharacterMystie:
            return [[NNKMystieNode alloc] initWithSize:size];
        default: {
            return nil;
        }
    }
    
}


- (void)loadLockedCharacter:(ShadowCharacter)character {
    self.scene.node = nil;
    self.descriptionLabel.hidden = YES;
    self.fullPortret.image = [UIImage imageNamed:[NSString stringWithFormat:NSPImagePatternPortraitShadow, (long)character]];
    self.viewForElements.hidden = NO;
    self.prizeView.hidden = YES;
    [self loadShadowsForCharacter:character];
}


- (void)createShadowElement:(UIImage *)image
    wrongCharacterPositions:(CGPoint)wrongCharacterPositions
  correctCharacterPositions:(CGRect)correctCharacterPositions {
    CGRect frame;
    frame.size = correctCharacterPositions.size;
    
    CGFloat viewWidth = self.viewForElements.frame.size.width;
    CGFloat viewHeigth = self.viewForElements.frame.size.height;
    
    const CGFloat X = arc4random() % (int)viewWidth;
    const CGFloat Y = arc4random() % (int)viewHeigth;
    
    frame = [self scaledRectFromRect:frame];
    frame.origin.x = X;
    frame.origin.y = Y;
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    }
    if (frame.origin.x + frame.size.width > viewWidth) {
        frame.origin.x = viewWidth - frame.size.width;
    }
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    }
    if (frame.origin.y + frame.size.height > viewHeigth) {
        frame.origin.y = viewHeigth - frame.size.height;
    }
    DragableButton *shadow = [[DragableButton alloc] initWithFrame:frame];
    shadow.correctRect = [self scaledRectFromRect:correctCharacterPositions];
    shadow.delegate = self;
    [shadow setImage:image forState:UIControlStateNormal];
    [self.shadowElements addObject:shadow];
    [self.viewForElements addSubview:shadow];
}


- (IBAction)getPrize:(id)sender {
    [[SoundPlayer sharedPlayer] playCorrectAnswer];
    [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeMagicWand withFormat:InventaryIconShowingFull];
    [self closeTextBarWithCompletionBlock:^{
        [self.textBar stopStound];
        [self backButton:nil];
    }];
}


- (void)showMagicWand {
    self.fullPortret.hidden = YES;
    self.descriptionLabel.hidden = YES;
    self.viewForElements.hidden = YES;
    self.prizeView.hidden = NO;
    self.scene.node = nil;
    [self.player stop];
    [self prizeDidAppear];
}


- (void)viewDidLayoutSubviews {
    self.textBar.frame = self.textBarSuperView.bounds;
    [super viewDidLayoutSubviews];
}


- (TextBarViewController *)textBar {
    if (!_textBar) {
        _textBar = [TextBarViewController instantiate];
        [self.textBarSuperView addSubview:_textBar];
    }
    
    return _textBar;
}


- (void)openTextBarWithIcon:(UIImage *)image
                       text:(NSString *)text
                   isObject:(BOOL)isObject {
    [self closeTextBarWithCompletionBlock:^{
        self.textBar.image = image;
        self.textBar.text = text;
        self.textBar.object = isObject;
        self.textBarBottomConstraint.constant = [self textBarOpenPosition];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}


- (void)closeTextBarWithCompletionBlock:(void (^)(void))completion {
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}


- (void)prizeDidAppear {
    [self openTextBarWithIcon:[UIImage imageNamed:@"text_panel_ginger"]
                         text:@"text_panel_shadow_final"
                     isObject:NO];
    [self performSelector:@selector(closeTextBarWithCompletionBlock:) withObject:nil afterDelay:5.f];
}


- (BOOL)shouldShowWelcomeAlert {
    return [[[ShadowPlayOpenedHandler sharedHandler] allOpenedCharacter] count] != 8;
}


- (CGFloat)textBarHiddenPosition {
    return -self.textBarSuperView.frame.size.height - 10;
}


- (CGFloat)textBarOpenPosition {
    return 5;
}


- (IBAction)reset:(id)sender {
    AlertViewController *alert = [AlertViewController initWithTitle:@"alert_start_over"
                                                   firstButtonTitle:@"alert_yes"
                                                  firstButtonAction:^{
                                                      [[ShadowPlayOpenedHandler sharedHandler] resetOpenedCharacter];
                                                      [self didPressCharacter:self.loadedCharacter];
                                                  }
                                                  secondButtonTitle:@"alert_no"
                                                 secondButtonAction:nil];
    [alert showInViewController:self];
}

@end
