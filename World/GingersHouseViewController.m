//
//  GingersHouseViewController.m
//  World
//
//  Created by Andrei Vidrasco on 7/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "GingersHouseViewController.h"
#import "InventaryContentHandler.h"

@interface GingersHouseViewController ()

@property (weak, nonatomic) IBOutlet UIButton *extinguisher;
@property (assign, nonatomic, getter = isExtinguisherOpen) BOOL extinguisherOpen;

@end

@implementation GingersHouseViewController

- (void)updateExtinguisherState {
    self.extinguisher.hidden = self.isExtinguisherOpen;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateExtinguisherState];
}


- (IBAction)extinguisherPress {
    self.extinguisherOpen = YES;
    [self updateExtinguisherState];
}


- (BOOL)isExtinguisherOpen {
    InventaryContentHandler *handler = [InventaryContentHandler sharedHandler];
    InventaryIconShowing iconShowing = [handler formatForItemType:InventaryBarIconTypeExtinguisher];
    
    return iconShowing != InventaryIconShowingEmpty;
}


- (void)setExtinguisherOpen:(BOOL)extinguisherOpen {
    if (extinguisherOpen) {
        InventaryContentHandler *handler = [InventaryContentHandler sharedHandler];
        [handler markItemWithType:InventaryBarIconTypeExtinguisher withFormat:InventaryIconShowingFull];
    }
}

@end
