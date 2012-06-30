//
//  Wisecrack.h
//  Wisecrack
//
//  Created by Gareth Stokes on 30/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"

@interface Wisecrack : NSObject {
    NSMutableArray * words;
    NSString * key; 
    int points;
}

@property (nonatomic, retain) NSMutableArray * words;
@property (nonatomic, retain) NSString * key;
@property int points;

- (id) initWithWords:(NSString *)words, ...;
- (CCSprite *)image; 
- (BOOL) isFullMatch:(NSArray *)playerWords;

+ (Wisecrack *) find:(NSArray *)words;

@end
