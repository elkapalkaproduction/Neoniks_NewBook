//
//  CustomizationViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 1/11/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "CustomizationViewController.h"

typedef NS_ENUM(NSInteger, SegmentColor) {
    SegmentColorWhite,
    SegmentColorSepia,
    SegmentColorBlack,
};

@interface CustomizationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *fontList;
@property (weak, nonatomic) id<CustomizationDelegate> delegate;

@end

@implementation CustomizationViewController

+ (instancetype)instantiateWithDelegate:(id<CustomizationDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Book" bundle:nil];
    
    CustomizationViewController *customization = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    customization.delegate = delegate;
    
    return customization;
}


- (NSArray *)fontList {
    if (_fontList) {
        return _fontList;
    }
    
    NSMutableArray *fontNames = [[NSMutableArray alloc] init];
    NSArray *fontFamilyNames = [UIFont familyNames];
    for (NSString *familyName in fontFamilyNames) {
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        [fontNames addObjectsFromArray:names];
    }

    _fontList = [NSArray arrayWithArray:fontNames];
    return _fontList;
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationPopover;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fontList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    NSString *fontName = self.fontList[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:fontName size:16];
    fontName = [fontName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    cell.textLabel.text = fontName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didChangeFontToFontWithName:self.fontList[indexPath.row]];
}


- (IBAction)segmentControllerValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == SegmentColorWhite) {
        [self.delegate didChangeBackgroundColorToColor:@"white"];
    } else if (sender.selectedSegmentIndex == SegmentColorSepia) {
        [self.delegate didChangeBackgroundColorToColor:@"#F6EEDC"];
    } else if (sender.selectedSegmentIndex == SegmentColorBlack) {
        [self.delegate didChangeBackgroundColorToColor:@"black"];
    }
}

@end
