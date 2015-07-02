//
//  SelectorCell.h
//  Yelp
//
//  Created by Issen Su on 6/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectorCell;

@protocol SelectorTableViewCellDelegate <NSObject>

- (void)selectorChanged:(SelectorCell *)cell selectedIndex:(int)index;

@end

@interface SelectorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectorSegmentControl;

@property (nonatomic, weak) id<SelectorTableViewCellDelegate> delegate;
@end
