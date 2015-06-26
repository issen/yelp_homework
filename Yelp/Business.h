//
//  Business.h
//  Yelp
//
//  Created by Issen Su on 6/26/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger numReviewes;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) NSString *price;

-(id)initWithDictionary:(NSDictionary *) dictionary;

+(NSArray *) businessWithDictionaries:(NSArray *)dictionaries;


@end
