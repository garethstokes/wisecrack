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
#import "WisecrackConfig.h"
#import "SimpleAudioEngine.h"
#import "TutorialScene.h"

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
        
        GameKitHelper * gk = [GameKitHelper sharedGameKitHelper];
        gk.delegate = self;
        [gk authenticateLocalPlayer];
        
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
        
        // CONFIG VERSION
        _version = [[CCLabelAtlas labelWithString:@"" 
                                      charMapFile:@"orange_numbers.png" 
                                        itemWidth:10 
                                       itemHeight:16 
                                     startCharMap:'.'] retain];
        [_version setPosition:ccp(200, 20)];
        [self addChild:_version z:20];
        
        [self schedule:@selector(updateVersion) interval:0.5];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"logo_effects.m4a" pitch:1 pan:1 gain:0.2];
        
        startTime = 0;
        [self scheduleUpdate];
    }
    
    return self;
}

- (void) update:(ccTime)delta
{
    startTime += delta;
}

- (void) updateVersion
{
    int version = [[WisecrackConfigSet configSet] version];
    [_version setString:[NSString stringWithFormat:@"version: %d", version]];
}

- (void) play:(id) sender
{
    NSString * playedTutorial = [[SettingsManager sharedSettingsManager] getString:@"HasPlayedTutorial" withDefault:@"YES"];
    
    NSLog(@"start time: %f", startTime);
    
    if (startTime > 1.2 && startTime < 1.4)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"wisecrack_play_2.m4a" pitch:1 pan:1 gain:0.05];
    }
    else 
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"wisecrack_play_1.m4a" pitch:1 pan:1 gain:0.05];
    }
    
    if ([playedTutorial isEqualToString:@"YES"])
    {
        //[[CCDirector sharedDirector] replaceScene: [CCTransitionFlipX transitionWithDuration:0.3 scene:[GameScene create]]];
        [[CCDirector sharedDirector] replaceScene: [GameScene create]];
        return;
    }
    
    [[CCDirector sharedDirector] replaceScene: [TutorialScene create]];
}

-(void) onLocalPlayerAuthenticationChanged
{
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
    
    if (localPlayer.authenticated)
    {
        //GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
        //[gkHelper getLocalPlayerFriends];
        //[gkHelper resetAchievements];

        [[SettingsManager sharedSettingsManager] setValue:@"GameCenter" newString:@"YES"];
    }   
}

-(void) onFriendListReceived:(NSArray*)friends
{
    CCLOG(@"onFriendListReceived: %@", [friends description]);
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper getPlayerInfo:friends];
}
-(void) onPlayerInfoReceived:(NSArray*)players
{
    CCLOG(@"onPlayerInfoReceived: %@", [players description]);
    
    
}
-(void) onScoresSubmitted:(bool)success
{
    CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}
-(void) onScoresReceived:(NSArray*)scores
{
    CCLOG(@"onScoresReceived: %@", [scores description]);
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper showAchievements];
}
-(void) onAchievementReported:(GKAchievement*)achievement
{
    CCLOG(@"onAchievementReported: %@", achievement);
}
-(void) onAchievementsLoaded:(NSDictionary*)achievements
{
    CCLOG(@"onLocalPlayerAchievementsLoaded: %@", [achievements description]);
}
-(void) onResetAchievements:(bool)success
{
    CCLOG(@"onResetAchievements: %@", success ? @"YES" : @"NO");
}
-(void) onLeaderboardViewDismissed
{
    CCLOG(@"onLeaderboardViewDismissed");
    
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper retrieveTopTenAllTimeGlobalScores];
}
-(void) onAchievementsViewDismissed
{
    CCLOG(@"onAchievementsViewDismissed");
}
-(void) onReceivedMatchmakingActivity:(NSInteger)activity
{
    CCLOG(@"receivedMatchmakingActivity: %i", activity);
}
-(void) onMatchFound:(GKMatch*)match
{
    CCLOG(@"onMatchFound: %@", match);
}
-(void) onPlayersAddedToMatch:(bool)success
{
    CCLOG(@"onPlayersAddedToMatch: %@", success ? @"YES" : @"NO");
}
-(void) onMatchmakingViewDismissed
{
    CCLOG(@"onMatchmakingViewDismissed");
}
-(void) onMatchmakingViewError
{
    CCLOG(@"onMatchmakingViewError");
}
-(void) onPlayerConnected:(NSString*)playerID
{
    CCLOG(@"onPlayerConnected: %@", playerID);
}
-(void) onPlayerDisconnected:(NSString*)playerID
{
    CCLOG(@"onPlayerDisconnected: %@", playerID);
}
-(void) onStartMatch
{
    CCLOG(@"onStartMatch");
}
-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID
{
    CCLOG(@"onReceivedData: %@ fromPlayer: %@", data, playerID);
}

- (void) dealloc
{
    //if (_version) [_version dealloc];

    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [[CCDirector sharedDirector] purgeCachedData];
    
    [super dealloc];
}

@end
