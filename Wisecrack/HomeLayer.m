//
//  HomeLayer.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/03/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "HomeLayer.h"
#import "SpriteHelperLoader.h"
#import "GameScene.h"
#import "HomeScene.h"

@implementation HomeLayer

- (id) init
{
    if( (self=[super init]))
    {
        loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"home"];
        backgroundLoader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"backgrounds"];
        
        // background
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [backgroundLoader spriteWithUniqueName:@"home_bg" 
                                                           atPosition:CGPointMake(size.width /2, size.height /2) 
                                                              inLayer:nil];
        [self addChild:background z:0];
        
        // logo
        CCSprite *logo = [loader spriteWithUniqueName:@"home_anim0000" atPosition:CGPointMake(160, 300) inLayer:nil];
        [loader runAnimationWithUniqueName:@"logo" onSprite:logo];
        [self addChild:logo z:10];
        
        // button
        CCSprite *playOn = [loader spriteWithUniqueName:@"play_on" atPosition:ccp(0, 0) inLayer:nil];
        CCSprite *playOff = [loader spriteWithUniqueName:@"play_off" atPosition:ccp(0, 0) inLayer:nil];
        
        CCMenuItemImage *button = [CCMenuItemImage 
                                   itemFromNormalSprite: playOff
                                   selectedSprite: playOn
                                   target:self 
                                   selector:@selector(play:)];
        
        
        CCMenu *menu = [CCMenu menuWithItems: button, nil];
        [menu setPosition:CGPointMake(160, 80)];
        
        [self addChild:menu z:10];
    }
    
    return self;
}

- (void) play:(id) sender
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFlipX transitionWithDuration:0.3 scene:[GameScene create]]];
}

- (void) dealloc
{
    //[loader release];
    [super dealloc];
}

@end
