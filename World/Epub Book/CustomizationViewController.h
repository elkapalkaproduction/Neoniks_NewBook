//
//  CustomizationViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 1/11/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomizationDelegate <NSObject>

- (void)didChangeFontToFontWithName:(NSString *)fontName;
- (void)didChangeBackgroundColorToColor:(NSString *)color;

@end

@interface CustomizationViewController : UIViewController

+ (instancetype)instantiateWithDelegate:(id<CustomizationDelegate>)delegate;

@end
