//
//  OptionsLayer.m
//  Wisecrack
//
//  Created by Gareth Stokes on 12/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "OptionsLayer.h"
#import "GameScene.h"

@implementation OptionsLayer

- (id) init
{
    if( (self=[super init]))
    {
        SpriteHelperLoader *loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"options"] autorelease];
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        
        CCSprite *background = [loader spriteWithUniqueName:@"options_bg" 
                                                 atPosition:CGPointMake(0, 0) 
                                                    inLayer:nil];
        
        [self addChild:background z:0];
        
        CCSprite *info = [loader spriteWithUniqueName:@"options_help_panel" 
                                                 atPosition:CGPointMake(0, 0) 
                                                    inLayer:nil];
        
        [self addChild:info z:1];
        
        CCSprite *continueOn = [loader spriteWithUniqueName:@"btn_continue_on" atPosition:ccp(0, 0) inLayer:nil];
        CCSprite *continueOff = [loader spriteWithUniqueName:@"btn_continue_off" atPosition:ccp(0, 0) inLayer:nil];
        
        CCSprite *replayOn = [loader spriteWithUniqueName:@"btn_replay_on" atPosition:ccp(0, 0) inLayer:nil];
        CCSprite *replayOff = [loader spriteWithUniqueName:@"btn_replay_off" atPosition:ccp(0, 0) inLayer:nil];
        
        CCMenu *menu = [CCMenu menuWithItems: nil];
        CCMenuItemImage *cont = [CCMenuItemImage 
                                   itemFromNormalSprite: continueOff
                                   selectedSprite: continueOn
                                   target:self 
                                   selector:@selector(cont:)];
        [menu addChild:cont];
        
        CCMenuItemImage *replay = [CCMenuItemImage 
                                   itemFromNormalSprite: replayOff
                                   selectedSprite: replayOn
                                   target:self 
                                   selector:@selector(replay:)];
        [menu addChild:replay];
        
        //[menu setContentSize:CGSizeMake(size.width, 100)];
        [menu setPosition:CGPointMake(0, -160)];
        [menu alignItemsHorizontallyWithPadding:16];
        
        [self addChild:menu z:10];
    }
    return self;
}

- (void) cont:(id) sender
{
    [self removeFromParentAndCleanup:YES];
}

- (void) replay:(id) sender
{
    [[CCDirector sharedDirector] replaceScene: [GameScene create]];
}

@end
