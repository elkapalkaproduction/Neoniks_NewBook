//
//  CharacterShadowViewController.m
//  World
//
//  Created by Andrei Vidrasco on 2/2/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "CharacterShadowViewController.h"

NSString *const NSPImagePatternPortrait = @"Shadow_portret_%ld";
NSString *const NSPImagePatternBorder = @"Shadow_portret_border_%ld";
NSString *const NSPImagePatterName = @"shadow_name_%ld";

@interface CharacterShadowViewController ()

@property (assign, nonatomic) ShadowCharacter loadedCharacter;
@property (assign, nonatomic) CharactersInteraction characterInteraction;
@property (weak, nonatomic) IBOutlet UIImageView *characterImage;
@property (weak, nonatomic) IBOutlet UIImageView *characterName;
@property (weak, nonatomic) IBOutlet UIImageView *nameBackground;

@end

@implementation CharacterShadowViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInterface];
}


- (void)updateInterfaceWithCharacter:(ShadowCharacter)character
                characterInteraction:(CharactersInteraction)characterInteraction {
    self.loadedCharacter = character;
    self.characterInteraction = characterInteraction;
    [self updateInterface];
}


- (IBAction)sendDelegateMessageWithCharacterSelected {
    if ([self.delegate respondsToSelector:@selector(didPressCharacter:)]) {
        [self.delegate didPressCharacter:self.loadedCharacter];
    }
}


- (void)changeToCharacterClosedState {
    self.characterImage.image = [UIImage imageNamed:[NSString stringWithFormat:NSPImagePatternBorder, (long)self.loadedCharacter]];
    self.characterName.hidden = YES;
    self.nameBackground.hidden = YES;
}


- (void)changeToCharacterOpenState {
    self.characterImage.image = [UIImage imageNamed:[NSString stringWithFormat:NSPImagePatternPortrait, (long)self.loadedCharacter]];
    self.characterName.hidden = NO;
    self.nameBackground.hidden = NO;
}


- (void)changeToCharacterSelectedState {
    self.characterImage.image = [UIImage imageNamed:[NSString stringWithFormat:NSPImagePatternBorder, (long)self.loadedCharacter]];
    self.characterName.hidden = NO;
    self.nameBackground.hidden = NO;
}


- (void)updateInterface {
    NSString *key = [NSString stringWithFormat:NSPImagePatterName, (long)self.loadedCharacter];
    self.characterName.image = [UIImage imageNamed:NSLocalizedString(key, nil)];
    switch (self.characterInteraction) {
        case CharactersInteractionClosed: {
            [self changeToCharacterClosedState];
            break;
        }

        case CharactersInteractionOpened: {
            [self changeToCharacterOpenState];
            break;
        }

        case CharactersInteractionSelected: {
            [self changeToCharacterSelectedState];
            break;
        }
        default: {
            break;
        }
    }
}

@end
