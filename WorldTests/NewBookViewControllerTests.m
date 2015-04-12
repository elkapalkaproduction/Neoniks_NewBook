//
//  NewBookViewControllerTests.m
//  World
//
//  Created by Andrei Vidrasco on 4/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NewBookViewController.h"

@interface NewBookViewControllerTests : XCTestCase

@end

@implementation NewBookViewControllerTests

- (void)testExample {
    NewBookViewController *newBook = [NewBookViewController instantiate];
    // This is an example of a functional test case.
    XCTAssert([newBook isKindOfClass:[NewBookViewController class]], @"Pass");
}

@end
