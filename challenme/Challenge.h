//
//  Challenge.h
//  challenme
//
//  Created by Fangyi Chen on 4/26/15.
//  Copyright (c) 2015 Fangyi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChallengeBook;

@interface Challenge : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * reword;
@property (nonatomic, retain) NSDate * creationTime;
@property (nonatomic, retain) ChallengeBook *challengebook;

@end
