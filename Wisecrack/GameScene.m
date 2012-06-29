//
//  GameScene.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "GameScene.h"
#import "GameObjectCache.h"
#import "MetricMonster.h"
#import "WisecrackConfig.h"

@implementation GameScene
@synthesize background;
@synthesize hud;
@synthesize game;

+ (GameScene *) create
{
    [GameObjectCache purgeGameObjectCache]; 
    
    GameScene* scene = [[[GameScene alloc] init] autorelease];
    [[GameObjectCache sharedGameObjectCache] addGameScene:scene];
    
    // HUD
    HudLayer * hud = [[HudLayer alloc] init];
    [scene setHud:hud];
    [scene addChild:hud z:20];
    [[GameObjectCache sharedGameObjectCache] addHudLayer:hud];
    [hud release];
    
    // GameLayer
    [[WisecrackConfigSet configSet] resetWave];
    GameBoard * board = [[[GameBoard alloc] init] autorelease];
    [board fill];
    
    GameLayer* gameLayer = [[GameLayer alloc] initWithBoard:board];
    [scene setGame:gameLayer];
    [scene addChild:gameLayer z:10];
    [[GameObjectCache sharedGameObjectCache] addGameLayer:gameLayer];
    [gameLayer release];
    
    [[MetricMonster monster] queue:@"GameScene"];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:scene 
                                             selector:@selector(mySceneEnd:) 
                                                 name:@"scene_ended" 
                                               object:nil];
    */
    return scene;
}

- (void) mySceneEnd:(NSNotification *)notif {   
    return;
    
    CCDirector * director = [CCDirector sharedDirector];
    
    if ([director runningScene])
        [director end];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void) dealloc
{   
    [super dealloc];
}

@end
