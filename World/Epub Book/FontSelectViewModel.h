//
//  FontSelectViewModel.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookOptionsProtocol.h"

@protocol CustomizationDelegate <NSObject>

- (void)didChangeFontToFontWithName:(NSString *)fontName;

@end

@interface FontSelectViewModel : NSObject <BookOptionsProtocol>

- (instancetype)initWithDelegate:(id<CustomizationDelegate>)delegate;

@end
