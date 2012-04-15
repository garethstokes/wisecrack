//
//  HudLayer.h
//  Wisecrack
//
//  Created by Gareth Stokes on 4/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"

@interface HudLayer : CCLayer {
    CCLabelAtlas * _score;
    CCLabelAtlas * _multiplier;
    SpriteHelperLoader *loader;
    int score;
}

- (void) openOptions:(id)sender;
- (void) updateScoreLabel:(int)number withAnim:(BOOL)anim;
- (void) updateMultiplier:(int)muliplier;

@end
