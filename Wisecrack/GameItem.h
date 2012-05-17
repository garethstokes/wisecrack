//
//  GameItem.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface GameItem : NSObject {
    NSString *name; 
    NSString *colour;
    CGSize size;
    int offset;
    int row;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *colour;
@property (nonatomic) CGSize size;
@property (nonatomic) int offset;
@property (nonatomic) int row;

- (GameItem *) duplicate;
- (NSString *) hash;

+ (GameItem *) small;
+ (GameItem *) medium;
+ (GameItem *) large;

+ (GameItem *) wordWith:(NSString *)name andColour:(NSString *)colour andSize:(NSString *)size;

@end
