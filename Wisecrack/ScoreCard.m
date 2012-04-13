//
//  ScoreCard.m
//  Wisecrack
//
//  Created by Gareth Stokes on 13/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "ScoreCard.h"
#import "HomeScene.h"
#import "SettingsManager.h"

@implementation ScoreCard

- (id) init
{
    if( (self=[super init]))
    {
        loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"scorecard"];
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [loader spriteWithUniqueName:@"end_of_game_bg" 
                                                 atPosition:CGPointMake(size.width /2, size.height /2) 
                                                    inLayer:nil];
        
        [self addChild:background z:0];
        
        // button
        CCSprite *playOn = [loader spriteWithUniqueName:@"play_on" atPosition:ccp(0, 0) inLayer:nil];
        CCSprite *playOff = [loader spriteWithUniqueName:@"play_off" atPosition:ccp(0, 0) inLayer:nil];
        
        CCMenuItemImage *button = [CCMenuItemImage 
                                   itemFromNormalSprite: playOff
                                   selectedSprite: playOn
                                   target:self 
                                   selector:@selector(finish:)];
        
        
        CCMenu *menu = [CCMenu menuWithItems: button, nil];
        [menu setPosition:CGPointMake(160, 50)];
        
        [self addChild:menu z:10];
        
        // score label
        scoreLabel = [[CCLabelAtlas labelWithString:@"8008" 
                                        charMapFile:@"big_score_numerals.png" 
                                          itemWidth:33
                                         itemHeight:82 
                                       startCharMap:'0'] retain];
        [scoreLabel setAnchorPoint: ccp(0.5, 0.5f)]; // align centre
        [scoreLabel setPosition:ccp(size.width /2, (size.height /2) + 125)];
        [self addChild:scoreLabel];
        
    }
    return self;
}

- (void) finish:(id) sender
{
    //[[CCDirector sharedDirector] replaceScene:[HomeScene create]];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFlipX transitionWithDuration:0.3 scene:[HomeScene create]]];
}

- (void) updateScore:(int)score
{
    int highScore = [[SettingsManager sharedSettingsManager] getInt:@"HighScore" withDefault:0];
    if (score > highScore)
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        [loader spriteWithUniqueName:@"highscore_badge" atPosition:ccp(size.width /2, size.height /2) inLayer:self];
        [[SettingsManager sharedSettingsManager] setValue:@"HighScore" newInt:score];
    }
    
    [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
}

// Set the opacity of all of our children that support it
-(void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol(CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}

- (void) dealloc
{
    CCLOG(@"Dealloc ScoreCard");
    [loader release];
    [scoreLabel release];
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
