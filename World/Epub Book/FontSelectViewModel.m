//
//  FontSelectViewModel.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "FontSelectViewModel.h"

@interface FontSelectViewModel ()

@property (strong, nonatomic) NSArray *fonts;
@property (weak, nonatomic) id<CustomizationDelegate> delegate;

@end

@implementation FontSelectViewModel

- (instancetype)initWithDelegate:(id<CustomizationDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}


- (NSArray *)fonts {
    if (_fonts) {
        return _fonts;
    }
    
    NSMutableArray *fontNames = [[NSMutableArray alloc] init];
    NSArray *fontFamilyNames = [UIFont familyNames];
    for (NSString *familyName in fontFamilyNames) {
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        [fontNames addObjectsFromArray:names];
    }
    
    _fonts = [NSArray arrayWithArray:fontNames];
    
    return _fonts;
}


- (NSInteger)numberOfRows {
    return [self.fonts count];
}


- (NSString *)titleForRowAtIndext:(NSInteger)index {
    NSString *fontName = [self.fonts[index] stringByReplacingOccurrencesOfString:@"-" withString:@" "];

    return fontName;
}


- (void)didSelectRowAtIndex:(NSInteger)index {
    [self.delegate didChangeFontToFontWithName:self.fonts[index]];
}


- (UIFont *)fontForIndex:(NSInteger)index {
    UIFont *font = [UIFont fontWithName:self.fonts[index] size:16];
                    
    return font;
}

@end
