//
//  GameLayer.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "GameBoard.h"
#import "SpriteHelperLoader.h"
#import "GameItem.h"
#import "ScoreCalculator.h"

@interface GameLayer : CCLayer {
    GameBoard * board;
    NSMutableArray * buttons;
    CCMenu * menu;
    int score;
    int ink;
    BOOL ready;
}

@property (nonatomic, retain) GameBoard* board;
@property (nonatomic, retain) NSMutableArray* buttons;
@property (nonatomic) int score;

- (id) initWithBoard:(GameBoard *)board;
- (void) wordClick:(id) sender;
- (void) drawButtons;
- (void) clearButtons;
- (void) step:(ccTime) delta;
- (void) updateBoard:(ccTime) delta;
- (void) updateMultiplier:(ccTime) delta;
- (void) removeButton:(CCMenuItemImage *) button withDelay:(ccTime)delay;
- (void) endRemoveButton:(id) sender;
- (void) unsuccessfulClick;

@end
