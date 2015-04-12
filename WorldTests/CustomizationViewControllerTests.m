//
//  CustomizationViewControllerTests.m
//  World
//
//  Created by Andrei Vidrasco on 4/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CustomizationViewController.h"

@interface CustomizationViewControllerTests : XCTestCase

@end

@implementation CustomizationViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    CustomizationViewController *customization = [CustomizationViewController instantiateWithDelegate:nil];
    XCTAssert([customization isKindOfClass:[CustomizationViewController class]], @"Pass");
}

@end
