//
//  TutorialLayer.m
//  Wisecrack
//
//  Created by Gareth Stokes on 22/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "TutorialLayer.h"
#import "GameScene.h"
#import "SettingsManager.h"
#import "CCVideoPlayer.h"

@implementation TutorialLayer

- (id) init
{
    if ([super init] != nil)
    {
        _step = 0;
        
        SpriteHelperLoader * backgroundLoader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"backgrounds"] autorelease];
        _buttons = [[SpriteHelperLoader alloc] initWithContentOfFile:@"tutorial"];
        
        // background
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [backgroundLoader spriteWithUniqueName:@"home_bg" 
                                                           atPosition:CGPointMake(size.width /2, size.height /2) 
                                                              inLayer:nil];
        [self addChild:background z:0];
        
        
        //[CCVideoPlayer playMovieWithFile:@"first_time_user_anim_1_mov.mov"];

        
        // header
        CCSprite * logo = [_buttons spriteWithUniqueName:@"title_intro" 
                                           atPosition:CGPointMake(size.width /2, 420) 
                                              inLayer:nil];
        
        [self addChild:logo z:11];    
    }
    
    return self;
}

- (void) onEnterTransitionDidFinish
{
    
    // tut_1
    CGSize size = [[CCDirector sharedDirector] winSize];
    SpriteHelperLoader * loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"tut_1a"] autorelease];
    _tut = [loader spriteWithUniqueName:@"first_time_user_anim_1_6" 
                             atPosition:CGPointMake(size.width /2, size.height /2) 
                                inLayer:nil];
    
    _currentAnimation = [loader runAnimationWithUniqueName:@"tut_1a" onSprite:_tut];
    
    [self addChild:_tut z:10];
    
    
    
    //[CCVideoPlayer playMovieWithFile:@"first_time_user_anim_1_mov.mov"];
    int soundEnabled = [[SettingsManager sharedSettingsManager] getInt:@"SoundEnabled" withDefault:1];
    if (soundEnabled)
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"wisecrack_bg_music_low.m4a" loop:YES];
    
    [self schedule:@selector(stepZero) interval:2.0f];
}

- (void) addMenu
{
    // button
    CCSprite * playOn = [_buttons spriteWithUniqueName:@"next_button_on" atPosition:ccp(0, 0) inLayer:nil];
    CCSprite * playOff = [_buttons spriteWithUniqueName:@"next_button_off" atPosition:ccp(0, 0) inLayer:nil];
    
    CCMenuItemImage * button = nil;
    
    if (_step == 0) 
    {
        button = [CCMenuItemImage 
                                itemFromNormalSprite: playOff
                                selectedSprite: playOn
                                target:self 
                                selector:@selector(stepTwo)];
    }
    
    if (_step == 3) 
    {
        button = [CCMenuItemImage 
                  itemFromNormalSprite: playOff
                  selectedSprite: playOn
                  target:self 
                  selector:@selector(stepFour)];
    }
    
    if (_step == 5) 
    {
        button = [CCMenuItemImage 
                  itemFromNormalSprite: playOff
                  selectedSprite: playOn
                  target:self 
                  selector:@selector(stepSix)];
    }
    
    if (_step == 7) 
    {
        button = [CCMenuItemImage 
                  itemFromNormalSprite: playOff
                  selectedSprite: playOn
                  target:self 
                  selector:@selector(playGameScene)];
    }
    
    if (button != nil)
    {
        _menu = [CCMenu menuWithItems: button, nil];
        [_menu setPosition:CGPointMake(160, 60)];
        [self addChild:_menu z:10];
    }
}

- (void) stepZero
{
    [self unschedule:@selector(stepZero)];
    
    [self removeChild:_tut cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    // tut_1
    CGSize size = [[CCDirector sharedDirector] winSize];
    SpriteHelperLoader * loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"tut_1b"] autorelease];
    _tut = [loader spriteWithUniqueName:@"first_time_user_anim_1_10" 
                             atPosition:CGPointMake(size.width /2, size.height /2) 
                                inLayer:nil];
    
    _currentAnimation = [loader runAnimationWithUniqueName:@"tut_1b" onSprite:_tut];
    
    [self addChild:_tut z:10];
    [self schedule:@selector(stepOne) interval:1.0f];
}

- (void) stepOne
{
    //[CCVideoPlayer playMovieWithFile:@"first_time_user_anim_1_mov.mov"];
    [self unschedule:@selector(stepOne)];
    
    [self removeChild:_tut cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    // tut_1
    CGSize size = [[CCDirector sharedDirector] winSize];
    SpriteHelperLoader * loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"tut_1a"] autorelease];
    _tut = [loader spriteWithUniqueName:@"first_time_user_anim_1_6" 
                             atPosition:CGPointMake(size.width /2, size.height /2) 
                                inLayer:nil];
    
    _currentAnimation = [loader runAnimationWithUniqueName:@"tut_1a" onSprite:_tut];
    
    [self addChild:_tut z:10];
    

    [self schedule:@selector(stepZero) interval:2.0f];
    
    if (_step == 0) 
    {
        [self addMenu];
        _step = 1;
    }
}

- (void) stepTwo
{
    NSLog(@"step two");
    [self unschedule:@selector(stepZero)];
    [self unschedule:@selector(stepOne)];
    _step = 2;
    
    [_tut stopAllActions];
    
    [self removeChild:_tut cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    SpriteHelperLoader * loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"tut_2a"] autorelease];
    CGSize size = [[CCDirector sharedDirector] winSize];
    _tut = [loader spriteWithUniqueName:@"first_time_user_anim_2_1" 
                             atPosition:CGPointMake(size.width /2, size.height /2) 
                                inLayer:nil];
    
    [loader runAnimationWithUniqueName:@"tut_2a" onSprite:_tut];
    [self addChild:_tut z:10];
    
    
    [self removeChild:_menu cleanup:YES];
    [self schedule:@selector(stepTwoAndAHalf) interval:2.4f];
}

- (void) stepTwoAndAHalf
{
    [self unschedule:@selector(stepTwoAndAHalf)];
    
    [self removeChild:_tut cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    // tut_1
    CGSize size = [[CCDirector sharedDirector] winSize];
    SpriteHelperLoader * loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"tut_2b"] autorelease];
    _tut = [loader spriteWithUniqueName:@"first_time_user_anim_2_10" 
                             atPosition:CGPointMake(size.width /2, size.height /2) 
                                inLayer:nil];
    
    [loader runAnimationWithUniqueName:@"tut_2b" onSprite:_tut];
    
    [self addChild:_tut z:10];
    [self schedule:@selector(stepThree) interval:1.0f];
}

- (void) stepThree
{
    NSLog(@"step three");
    //[_tut stopAllActions];
    [self unschedule:@selector(stepThree)];
    
    
    if (_step == 2) 
    {
        _step = 3;
        [self addMenu];
    }
    
    [self removeChild:_tut cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    SpriteHelperLoader * loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"tut_2a"] autorelease];
    CGSize size = [[CCDirector sharedDirector] winSize];
    _tut = [loader spriteWithUniqueName:@"first_time_user_anim_2_1" 
                             atPosition:CGPointMake(size.width /2, size.height /2) 
                                inLayer:nil];
    
    [loader runAnimationWithUniqueName:@"tut_2a" onSprite:_tut];
    [self addChild:_tut z:10];
    
    [self schedule:@selector(stepTwoAndAHalf) interval:2.4f];
}

- (void) stepFour
{
    NSLog(@"step four");
    _step = 4;
    
    [self unschedule:@selector(stepThree)];
    [self unschedule:@selector(stepTwoAndAHalf)];
    
    SpriteHelperLoader * loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"tut_3"] autorelease];
    [_tut stopAllActions];
    [self removeChild:_tut cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    _tut = [loader spriteWithUniqueName:@"first_time_user_anim_3_1" 
                             atPosition:CGPointMake(size.width /2, size.height /2) 
                                inLayer:nil];
    
    [loader runAnimationWithUniqueName:@"tut_3" onSprite:_tut];
    [self addChild:_tut z:10];
    
    [self removeChild:_menu cleanup:YES];
    [self schedule:@selector(stepFive) interval:14.0f];
}

- (void) stepFive
{
    NSLog(@"step five");
    _step = 5;
    [self unschedule:@selector(stepFive)];
    [self addMenu];
}

- (void) stepSix
{
    NSLog(@"step six");
    _step = 6;
    [_tut stopAllActions];
    [self removeChild:_tut cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    SpriteHelperLoader * loader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"tut_4"] autorelease];
    _tut = [loader spriteWithUniqueName:@"first_time_user_anim_4_1" 
                             atPosition:CGPointMake(size.width /2, size.height /2) 
                                inLayer:nil];
    
    [loader runAnimationWithUniqueName:@"tut_4" onSprite:_tut];
    [self addChild:_tut z:10];
    
    [self removeChild:_menu cleanup:YES];
    [self schedule:@selector(stepSeven) interval:6.0f];
}

- (void) stepSeven
{
    NSLog(@"step seven");
    _step = 7;
    [self addMenu];
}

- (void) playGameScene
{
    NSLog(@"play game scene");
    [_tut stopAllActions];
    [self removeChild:_tut cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [[SettingsManager sharedSettingsManager] setValue:@"HasPlayedTutorial" newString:@"YES"];
    //[[CCDirector sharedDirector] replaceScene: [CCTransitionFlipX transitionWithDuration:0.3 scene:[GameScene create]]];
    [[CCDirector sharedDirector] replaceScene:[GameScene create]];
}

- (void) dealloc
{
    [_buttons release];
    //[_tut release];
    [self removeAllChildrenWithCleanup: YES];
    [super dealloc];
}

@end
