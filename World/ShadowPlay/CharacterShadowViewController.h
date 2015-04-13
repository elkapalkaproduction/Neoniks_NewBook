//
//  CharacterShadowViewController.h
//  World
//
//  Created by Andrei Vidrasco on 2/2/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM (NSInteger, ShadowCharacter) {
    ShadowCharacterUnselected,
    ShadowCharacterJay,
    ShadowCharacterWanda,
    ShadowCharacterMystie,
    ShadowCharacterJustacreep,
    ShadowCharacterFurcoat,
    ShadowCharacterPhoebe,
    ShadowCharacterMiner,
    ShadowCharacterHarold,
};

typedef NS_ENUM (NSInteger, CharactersInteraction) {
    CharactersInteractionUndefinied,
    CharactersInteractionClosed,
    CharactersInteractionOpened,
    CharactersInteractionSelected,
};

@protocol CharacterShadowDelegate <NSObject>

- (void)didPressCharacter:(ShadowCharacter)character;

@end

@interface CharacterShadowViewController : BaseViewController

- (void)updateInterfaceWithCharacter:(ShadowCharacter)character
                characterInteraction:(CharactersInteraction)characterInteraction;

@property (weak, nonatomic) id <CharacterShadowDelegate> delegate;
@property (assign, nonatomic, readonly) ShadowCharacter loadedCharacter;

@end
