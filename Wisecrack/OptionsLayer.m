//
//  OptionsLayer.m
//  Wisecrack
//
//  Created by Gareth Stokes on 12/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "OptionsLayer.h"
#import "GameScene.h"
#import "ScoreCard.h"
#import "GameObjectCache.h"
#import "GameLayer.h"
#import "MetricMonster.h"
#import "TutorialScene.h"
#import "HomeScene.h"
#import "SettingsManager.h"

@implementation OptionsLayer

- (id) init
{
    if( (self=[super init]))
    {
        SpriteHelperLoader *loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"options"] autorelease];
        
        
        CCSprite *background = [loader spriteWithUniqueName:@"options_bg-hd" 
                                                 atPosition:CGPointMake(0, 0) 
                                                    inLayer:nil];
        
        [self addChild:background z:0];
        
        CCSprite * tutorialOn = [loader spriteWithUniqueName:@"tutorial_btn_on" atPosition:ccp(0, 0) inLayer:nil];
        CCSprite * tutorialOff = [loader spriteWithUniqueName:@"tutorial_btn_off" atPosition:ccp(0, 0) inLayer:nil];
        CCMenu * tutMenu = [CCMenu menuWithItems: nil];
        CCMenuItemImage * tut = [CCMenuItemImage 
                                 itemFromNormalSprite: tutorialOff
                                 selectedSprite: tutorialOn
                                 target:self 
                                 selector:@selector(playTutorial)];
        [tutMenu addChild:tut];
        [tutMenu setPosition:CGPointMake(0, 80)];
        [self addChild:tutMenu z: 11];
        
        CCSprite * continueOn = [loader spriteWithUniqueName:@"play_btn_on" atPosition:ccp(0, 0) inLayer:nil];
        CCSprite * continueOff = [loader spriteWithUniqueName:@"play_btn_off" atPosition:ccp(0, 0) inLayer:nil];
        
        CCSprite * replayOn = [loader spriteWithUniqueName:@"restart_btn_on" atPosition:ccp(0, 0) inLayer:nil];
        CCSprite * replayOff = [loader spriteWithUniqueName:@"restart_btn_off" atPosition:ccp(0, 0) inLayer:nil];
        
        CCMenu * menu = [CCMenu menuWithItems: nil];
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
        [menu setPosition:CGPointMake(0, -130)];
        [menu alignItemsVerticallyWithPadding:16];
        //[menu alignItemsHorizontallyWithPadding:16];
        
        [self addChild:menu z:10];
        
        
        // slider
        [self addSoundSlider];
        
        [[MetricMonster monster] queue:@"OptionsLayer"];
    }
    return self;
}

- (void) addSoundSlider
{
    SpriteHelperLoader *loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"options"] autorelease];
    CCSprite * soundOn = [loader spriteWithUniqueName:@"sound_on" atPosition:ccp(0,0) inLayer:nil];
    CCSprite * soundOff = [loader spriteWithUniqueName:@"sound_off" atPosition:ccp(0,0) inLayer:nil];
    int soundEnabled = [[SettingsManager sharedSettingsManager] getInt:@"SoundEnabled" withDefault:1];
    CCMenuItemImage * soundButton = [CCMenuItemImage itemFromNormalSprite:(soundEnabled) ? soundOn : soundOff
                                                           selectedSprite:(soundEnabled) ? soundOff : soundOn
                                                                   target:self 
                                                                 selector:@selector(soundToggle)]; 
    soundMenu = [CCMenu menuWithItems:soundButton, nil];
    [soundMenu setPosition:CGPointMake(55, -31)];
    [self addChild:soundMenu z:70];
}

- (void) soundToggle
{
    int soundEnabled = [[SettingsManager sharedSettingsManager] getInt:@"SoundEnabled" withDefault:1];
    soundEnabled = (soundEnabled == 0) ? 1 : 0;
    
    if (soundEnabled) 
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"wisecrack_bg_music_low.m4a" loop:YES];
    }
    else {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
    
    [[SettingsManager sharedSettingsManager] setValue:@"SoundEnabled" newInt:soundEnabled];

    [self removeChild:soundMenu cleanup:YES];
    [self addSoundSlider];
}


- (void) playTutorial
{
    [[CCDirector sharedDirector] resume];
    
    /*
    EAGLView * v = [[CCDirector sharedDirector] openGLView];
    [v removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scene_ended" 
                                                        object:nil userInfo:nil];
    */
    
    //[[[CCDirector sharedDirector] runningScene] cleanup];
    [[CCDirector sharedDirector] replaceScene: [TutorialScene create]];
}

- (void) cont:(id) sender
{
    [self runAction:[CCFadeOut actionWithDuration:0.3]];
    [self removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector] resume];
}

- (void) replay:(id) sender
{
    [[CCDirector sharedDirector] resume];
    
    GameLayer *gameLayer = [[GameObjectCache sharedGameObjectCache] gameLayer];
    ScoreCard *card = [[[ScoreCard alloc] init] autorelease];
    [card updateScore:[gameLayer score]];
    [[[GameObjectCache sharedGameObjectCache] gameScene] addChild:card z:100];
    [card runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.3], nil]];
    
    /*
    [gameLayer runAction:[CCSequence actions: 
                          [CCFadeOutTRTiles actionWithSize:ccg(40, 40) duration:1.5],
                          //[[CCFadeOutTRTiles actionWithSize:ccg(40, 40) duration:1.5] reverse],
                          //[CCStopGrid action],
                          nil]];
    */
    [[[GameObjectCache sharedGameObjectCache] gameScene] removeChild:self cleanup:YES];
    [[MetricMonster monster] queue:@"Replay"];
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

@end
