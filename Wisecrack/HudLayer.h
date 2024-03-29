//
//  HudLayer.h
//  Wisecrack
//
//  Created by Gareth Stokes on 4/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"
#import "InkWell.h"

@interface HudLayer : CCLayer {
    CCLabelAtlas * _score;
    SpriteHelperLoader *loader;
    InkWell * inkwell;
    int score;
    
    CCSprite * bonus1;
    CCSprite * bonus2;
    CCSprite * bonus3;
    CCSprite * bonus4;
}

- (void) openOptions:(id)sender;
- (void) updateScoreLabel:(int)number withAnim:(BOOL)anim;

- (void) updateInk:(int)value;
- (void) updateBonus;
- (void) clearBonus;

@end
