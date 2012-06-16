//
//  GameItem.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//


#import <Foundation/Foundation.h>
#include "cocos2d.h"
#include "SpriteHelperLoader.h"

@class CCMenuItemImage;
@class SpriteHelperLoader;

@interface GameItem : NSObject {
    NSString * name; 
    NSString * colour;
    CGSize size;
    int offset;
    int row;
    
    NSString * key_up;
    NSString * key_down;
    
    SpriteHelperLoader * loader;
    
    bool bonus;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * colour;
@property (nonatomic) CGSize size;
@property (nonatomic) int offset;
@property (nonatomic) int row;

@property (nonatomic, retain) NSString * key_up;
@property (nonatomic, retain) NSString * key_down;

@property (nonatomic, retain) SpriteHelperLoader * loader;

@property (nonatomic) bool bonus;

- (GameItem *) duplicate;
- (NSString *) hash;
- (NSString *) key_sound;
- (CCMenuItemImage *) buttonWithTarget:(id)target selector:(SEL)selector;

@end

@interface Word : GameItem

- (id) init:(NSString *)name colour:(NSString *)colour size:(CGSize)size;

+ (Word *) wordWith:(NSString *)name andColour:(NSString *)colour andSize:(NSString *)size;

@end
