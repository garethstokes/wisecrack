//
//  GameScene.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
@synthesize background;
@synthesize hud;
@synthesize game;

+ (GameScene *) create
{
    GameScene* scene = [[[GameScene alloc] init] autorelease];
    
    // GameLayer
    GameBoard * board = [[[GameBoard alloc] init] autorelease];
    [board fill];
    
    GameLayer* gameLayer = [[GameLayer alloc] initWithBoard:board];
    [scene setGame:gameLayer];
    [scene addChild:gameLayer z:10];
    [gameLayer release];
    return scene;
}

@end
