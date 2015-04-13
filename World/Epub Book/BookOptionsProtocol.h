//
//  BookOptionsProtocol.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BookOptionsProtocol <NSObject>

- (NSInteger)numberOfRows;
- (NSString *)titleForRowAtIndext:(NSInteger)index;
- (void)didSelectRowAtIndex:(NSInteger)index;

@optional
- (UIFont *)fontForIndex:(NSInteger)index;

@end