//
//  InkWell.h
//  Wisecrack
//
//  Created by Gareth Stokes on 24/05/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"
#import "SimpleAudioEngine.h"

@interface InkWell : CCNode {
    CCSprite * base_bg;
    CCSprite * bottle_bg;
    CCSprite * timer_ink;
    CCSprite * bottle_details;
    SpriteHelperLoader * loader;
    
    bool danger;
    
    ALuint _sound;
}

- (id) init:(SpriteHelperLoader *)ldr;
- (void) fillPot:(int)level;

@end
