//
//  FilterViewController.h
//  Yelp
//
//  Created by Issen Su on 6/26/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol  FilterViewControllerDelegate <NSObject>

- (void) filterViewController:(FilterViewController *) filterViewController didChangeFilters:(NSDictionary *) filters;

@end

@interface FilterViewController : UIViewController


@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@end
