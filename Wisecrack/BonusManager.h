//
//  BonusManager.h
//  Wisecrack
//
//  Created by Gareth Stokes on 25/05/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpriteHelperLoader.h"

@protocol BonusProtocol

- (void) activate;

@end

@interface Bonus : GameItem <BonusProtocol>

- (id) init:(NSString *)name colour:(NSString *)colour size:(CGSize)size;

- (NSString *) key;

+ (Bonus *) shake:(NSString *)colour;
+ (Bonus *) swipe:(NSString *)colour;
+ (Bonus *) multiplier:(NSString *)colour;
+ (Bonus *) chain;

@end

@interface BonusManager : NSObject {
    NSMutableArray * bonusItems_;
}

- (NSUInteger) bonusCount;
- (void) addBonus:(Bonus *)bonus;
- (NSArray *) activeBonusItems;
- (void) removeShakeIfAvailable;

@end
