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

@interface GameLayer : CCLayer {
    GameBoard* board;
    SpriteHelperLoader* loader;
    NSMutableArray *buttons;
    CCMenu* menu;
}

@property (nonatomic, retain) GameBoard* board;
@property (nonatomic, retain) NSMutableArray* buttons;

- (id) initWithBoard:(GameBoard *)board;
- (void) wordClick:(id) sender;
- (void) drawButtons;
- (void) clearButtons;

@end
