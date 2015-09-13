//
//  NSBundle+Language.h
//  World
//
//  Created by Andrei Vidrasco on 2/6/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language;

+ (BOOL)isRussian;

@end
