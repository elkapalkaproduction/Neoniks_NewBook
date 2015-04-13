//
//  ChaptersViewControllerTests.m
//  World
//
//  Created by Andrei Vidrasco on 4/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BookOptionsViewController.h"

@interface ChaptersViewControllerTests : XCTestCase

@end

@implementation ChaptersViewControllerTests

- (void)testExample {
    BookOptionsViewController *chapters = [BookOptionsViewController instantiateWithChapterList:nil delegate:nil];
    // This is an example of a functional test case.
    XCTAssert([chapters isKindOfClass:[BookOptionsViewController class]], @"Pass");
}

@end
