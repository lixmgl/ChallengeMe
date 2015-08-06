//
//  ChallengeBook.h
//  challenme
//
//  Created by Fangyi Chen on 4/26/15.
//  Copyright (c) 2015 Fangyi Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Challenge;

@interface ChallengeBook : NSManagedObject

@property (nonatomic, retain) NSDate * creationTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *challenge;
@end

@interface ChallengeBook (CoreDataGeneratedAccessors)

- (void)addChallengeObject:(Challenge *)value;
- (void)removeChallengeObject:(Challenge *)value;
- (void)addChallenge:(NSSet *)values;
- (void)removeChallenge:(NSSet *)values;

@end
