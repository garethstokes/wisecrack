//
//  GameScene.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "GameBoard.h"
#import "GameLayer.h"
#import "HudLayer.h"

#import "PrototypeGame.h"

@interface GameScene : CCScene {
    CCLayer *background;
    CCLayer *hud;
    CCLayer *game;
}

@property (nonatomic, retain) CCLayer *background;
@property (nonatomic, retain) CCLayer *hud;
@property (nonatomic, retain) CCLayer *game;

+ (GameScene *) create;

@end
