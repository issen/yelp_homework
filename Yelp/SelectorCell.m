//
//  SelectorCell.m
//  Yelp
//
//  Created by Issen Su on 6/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SelectorCell.h"

@interface SelectorCell ()
- (IBAction)selectorValueChanged:(UISegmentedControl *)sender;

@end

@implementation SelectorCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)selectorValueChanged:(UISegmentedControl *)sender {
    [self.delegate selectorChanged:self selectedIndex:sender.selectedSegmentIndex];
}

@end
