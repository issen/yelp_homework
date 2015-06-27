//
//  BusinessCell.h
//  Yelp
//
//  Created by Issen Su on 6/26/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) Business *business;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
