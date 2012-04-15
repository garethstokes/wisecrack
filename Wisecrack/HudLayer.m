//
//  HudLayer.m
//  Wisecrack
//
//  Created by Gareth Stokes on 4/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "HudLayer.h"
#import "OptionsLayer.h"
#import "GameObjectCache.h"

@implementation HudLayer

- (id) init
{
    if( (self=[super init]))
    {
        // POSITION
        CGSize size = [[CCDirector sharedDirector] winSize];
        [self setPosition:ccp(0, size.height - 46)];
        [self setContentSize:CGSizeMake(size.width, 50)];

        // SCORE
        _score = [[CCLabelAtlas labelWithString:@"0" 
                                    charMapFile:@"score_numerals.png" 
                                      itemWidth:11
                                     itemHeight:25 
                                   startCharMap:'0'] retain];
        [_score setAnchorPoint: ccp(1, 0.5f)]; // align right
        [_score setPosition:ccp(314, 25)];
        [self addChild:_score];
        
        // SCORE
        _multiplier = [[CCLabelAtlas labelWithString:@"0" 
                                         charMapFile:@"score_numerals.png" 
                                           itemWidth:11
                                          itemHeight:25 
                                        startCharMap:'0'] retain];
        [_multiplier setAnchorPoint: ccp(0.5f, 0.5f)]; // align center
        [_multiplier setPosition:ccp(160, 25)];
        [self addChild:_multiplier];
        
        // OPTIONS BUTTON
        loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"hud"];

        CCSprite *pauseOn = [loader spriteWithUniqueName:@"pause_btn_on" atPosition:ccp(0, 0) inLayer:nil];
        CCSprite *pauseOff = [loader spriteWithUniqueName:@"pause_btn_off" atPosition:ccp(0, 0) inLayer:nil];
        
        CCMenuItemImage *button = [CCMenuItemImage 
                                   itemFromNormalSprite: pauseOff
                                   selectedSprite: pauseOn
                                   target:self 
                                   selector:@selector(openOptions:)];
        
        
        CCMenu *menu = [CCMenu menuWithItems: button, nil];
        [menu setPosition:CGPointMake(32, 25)];
        
        [self addChild:menu z:10];
        score = 0;
    }
    
    return self;
}

- (void) openOptions:(id)sender
{
    // open options screen here.
    OptionsLayer *options = [[[OptionsLayer alloc] init] autorelease];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    [options setPosition:ccp(size.width /2, size.height /2)];
    [[[GameObjectCache sharedGameObjectCache] gameScene] addChild:options z:200];
    [options runAction:[CCFadeIn actionWithDuration:0.3]];
}

- (void) updateScoreLabel:(int)number withAnim:(BOOL)anim
{
    if (anim)
    {
        if (score >= number) return;
        score = score + 1;
    }
    else
    {
        score = number;
    }
    
    [_score setString:[NSString stringWithFormat:@"%d", score]];
}

- (void) updateMultiplier:(int)muliplier
{
    [_multiplier setString:[NSString stringWithFormat:@"%d", muliplier]];
}

- (void) dealloc
{
    CCLOG(@"Dealloc HUD");
    [_score release];
    [_multiplier release];
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
