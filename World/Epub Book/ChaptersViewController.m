//
//  ChaptersViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 1/11/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "ChaptersViewController.h"

@interface ChaptersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *chaptersList;
@property (weak, nonatomic) id<ChaptersListDelegate> delegate;

@end

@implementation ChaptersViewController

+ (instancetype)instantiateWithChapterList:(NSArray *)chaptersList delegate:(id<ChaptersListDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Book" bundle:nil];
    ChaptersViewController *chapter = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    chapter.chaptersList = chaptersList;
    chapter.delegate = delegate;
    
    return chapter;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chaptersList count];
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
    cell.textLabel.text = [self.chaptersList[indexPath.row] title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didSelectChapter:self.chaptersList[indexPath.row]];
}



@end
