//
//  ChaptersViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 1/11/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "BookOptionsViewController.h"
#import "BookOptionsProtocol.h"
#import "ChaptersViewModel.h"
#import "FontSelectViewModel.h"

@interface BookOptionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id<BookOptionsProtocol> viewModel;

@end

@implementation BookOptionsViewController

+ (instancetype)instantiateWithChapterList:(NSArray *)chaptersList delegate:(id<ChaptersListDelegate>)delegate {
    BookOptionsViewController *chapter = [self instantiate];
    chapter.viewModel = [[ChaptersViewModel alloc] initWithChapterList:chaptersList delegate:delegate];
    
    return chapter;
}


+ (instancetype)instantiateFontSelectWithDelegate:(id<CustomizationDelegate>)delegate {
    BookOptionsViewController *chapter = [self instantiate];
    chapter.viewModel = [[FontSelectViewModel alloc] initWithDelegate:delegate];
    
    return chapter;
}


+ (instancetype)instantiate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Book" bundle:nil];
    BookOptionsViewController *chapter = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];

    return chapter;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRows];
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
    cell.textLabel.text = [self.viewModel titleForRowAtIndext:indexPath.row];
    if ([self.viewModel respondsToSelector:@selector(fontForIndex:)]) {
        cell.textLabel.font = [self.viewModel fontForIndex:indexPath.row];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel didSelectRowAtIndex:indexPath.row];
}

@end
