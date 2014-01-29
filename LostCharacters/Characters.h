//
//  Characters.h
//  LostCharacters
//
//  Created by Matthew Graham on 1/28/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Characters : NSManagedObject

@property (nonatomic, retain) NSString * actor;
@property (nonatomic, retain) NSString * passenger;
@property (nonatomic, retain) NSString * numEpisodes;
@property (nonatomic, retain) NSString * startYear;
@property (nonatomic, retain) NSString * endYear;

@end
