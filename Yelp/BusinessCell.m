//
//  BusinessCell.m
//  Yelp
//
//  Created by Issen Su on 6/26/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.thumbImage.layer.cornerRadius = 3;
    self.thumbImage.clipsToBounds = YES;
    self.ratingImage.layer.cornerRadius = 3;
    self.ratingImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness:(Business *)business {
    _business = business;
    
    [self.thumbImage setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    [self.ratingImage setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
    self.nameLabel.text = self.business.name;
    self.reviewLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviewes];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f miles",self.business.distance];
    self.addressLabel.text = self.business.address;
    self.categoryLabel.text = self.business.category;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
