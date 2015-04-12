//
//  ChaptersViewControllerTests.m
//  World
//
//  Created by Andrei Vidrasco on 4/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ChaptersViewController.h"

@interface ChaptersViewControllerTests : XCTestCase

@end

@implementation ChaptersViewControllerTests

- (void)testExample {
    ChaptersViewController *chapters = [ChaptersViewController instantiateWithChapterList:nil delegate:nil];
    // This is an example of a functional test case.
    XCTAssert([chapters isKindOfClass:[ChaptersViewController class]], @"Pass");
}

@end
