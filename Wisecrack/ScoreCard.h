//
//  ScoreCard.h
//  Wisecrack
//
//  Created by Gareth Stokes on 13/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"

@interface ScoreCard : CCLayer {
    CCLabelAtlas * scoreLabel;
    SpriteHelperLoader *loader;
}

- (void) finish:(id) sender;
- (void) updateScore:(int)score;

@end
