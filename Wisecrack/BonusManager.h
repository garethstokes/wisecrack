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

@interface Bonus : GameItem 

+ (Bonus *) shake:(NSString *)colour;
+ (Bonus *) swipe:(NSString *)colour;
+ (Bonus *) multiplier:(NSString *)colour;
+ (Bonus *) chain;

@end

@interface BonusManager : NSObject {

}

@end
