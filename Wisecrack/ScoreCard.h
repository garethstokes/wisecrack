//
//  ScoreCard.h
//  Wisecrack
//
//  Created by Gareth Stokes on 13/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"
#import "GameKitHelper.h"
#import "Facebook.h"
#import <Twitter/Twitter.h>

@interface ScoreCard : CCLayer<GameKitHelperProtocol, FBSessionDelegate, FBDialogDelegate> {
    CCLabelAtlas * scoreLabel;
    SpriteHelperLoader * loader;
    SpriteHelperLoader * highScoreLoader;
    
    CCMenu * socialMenu;
    
    int _score;
}

- (void) finish:(id) sender;
- (void) updateScore:(int)score;

- (void) openGameCenter;
- (void) openFacebook;
- (void) openTwitter;

@end
