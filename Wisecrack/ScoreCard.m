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
#import "MetricMonster.h"
#import "AppDelegate.h"

@implementation ScoreCard

- (id) init
{
    if( (self=[super init]))
    {
        loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"scorecard"];
        highScoreLoader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"highscore"];
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [loader spriteWithUniqueName:@"end_of_game_bg" 
                                                 atPosition:CGPointMake(size.width /2, size.height /2) 
                                                    inLayer:nil];
        
        [self addChild:background z:0];
        
        // game center
        CCSprite * gcUp = [loader spriteWithUniqueName:@"social_gamec_up" atPosition:ccp(0,0) inLayer:nil];
        CCSprite * gcDown = [loader spriteWithUniqueName:@"social_gamec_down" atPosition:ccp(0,0) inLayer:nil];
        
        CCMenuItemImage * gcButton = [CCMenuItemImage 
                                      itemFromNormalSprite:gcUp 
                                      selectedSprite:gcDown
                                      target:self 
                                      selector:@selector(openGameCenter)];
        
        // facebook
        CCSprite * fbUp = [loader spriteWithUniqueName:@"social_fb_up" atPosition:ccp(0,0) inLayer:nil];
        CCSprite * fbDown = [loader spriteWithUniqueName:@"social_fb_down" atPosition:ccp(0,0) inLayer:nil];
        
        CCMenuItemImage * fbButton = [CCMenuItemImage 
                                      itemFromNormalSprite:fbUp 
                                      selectedSprite:fbDown 
                                      target:self 
                                      selector:@selector(openFacebook)];
        
        // twitter
        CCSprite * twUp = [loader spriteWithUniqueName:@"social_twitter_up" atPosition:ccp(0,0) inLayer:nil];
        CCSprite * twDown = [loader spriteWithUniqueName:@"social_twitter_down" atPosition:ccp(0,0) inLayer:nil];
        
        CCMenuItemImage * twButton = [CCMenuItemImage 
                                      itemFromNormalSprite:twUp 
                                      selectedSprite:twDown 
                                      target:self 
                                      selector:@selector(openTwitter)];
        
        //socialMenu = [CCMenu menuWithItems:gcButton, fbButton, twButton, nil];
        socialMenu = [CCMenu menuWithItems:nil];
        
        NSString * gc = [[SettingsManager sharedSettingsManager] getString:@"GameCenter" withDefault:@"NO"];
        if ([gc isEqualToString:@"YES"])
            [socialMenu addChild:gcButton];
        
        [socialMenu addChild:fbButton];
        
        if ([TWTweetComposeViewController canSendTweet]) {
            [socialMenu addChild:twButton];
        }
        
        [socialMenu setPosition:CGPointMake(160, 120)];
        [socialMenu alignItemsHorizontallyWithPadding:20];
        [self addChild:socialMenu z:9];
        
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
        
        [[MetricMonster monster] queue:@"ScoreCard"];
        
        _score = 0;
    }
    return self;
}

- (void) finish:(id) sender
{
    [[CCDirector sharedDirector] replaceScene:[HomeScene create]];
    //[[CCDirector sharedDirector] replaceScene: [CCTransitionFlipX transitionWithDuration:0.3 scene:[HomeScene create]]];
}

- (void) updateScore:(int)score
{
    int highScore = [[SettingsManager sharedSettingsManager] getInt:@"HighScore" withDefault:0];
    if (score > highScore)
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // run animation
        CCSprite * highscore = [highScoreLoader 
                                spriteWithUniqueName:@"highscore_badge_anim_01" 
                                atPosition:ccp(size.width /2, size.height /2) 
                                inLayer:self];
        [highScoreLoader runAnimationWithUniqueName:@"HighScoreAnim" onSprite:highscore];
        
        // save score in db.
        [[SettingsManager sharedSettingsManager] setValue:@"HighScore" newInt:score];
        [[SettingsManager sharedSettingsManager] save];
        
        // contact game center and tell them what's up. 
        NSString * gc = [[SettingsManager sharedSettingsManager] getString:@"GameCenter" withDefault:@"NO"];
        if ([gc isEqualToString:@"YES"])
        {
            GameKitHelper * gk = [GameKitHelper sharedGameKitHelper];
            [gk submitScore:score category:@"com.fallingshards.most.wise.crackers"];
        }
    }
    
    [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
    _score = score;
}

- (void) openGameCenter
{
    NSString * gc = [[SettingsManager sharedSettingsManager] getString:@"GameCenter" withDefault:@"NO"];
    
    if ([gc isEqualToString:@"YES"] == NO)
    {
        GameKitHelper * gk = [GameKitHelper sharedGameKitHelper];
        gk.delegate = self;
        [gk authenticateLocalPlayer];

        return;
    }
    
    GameKitHelper * gk = [GameKitHelper sharedGameKitHelper];
    [gk showLeaderboard];
    
    [[MetricMonster monster] queue:@"OpenGameCenter"];
}

- (void) openFacebook
{
    [[MetricMonster monster] queue:@"OpenFacebook"];
    
    NSString * appId = @"406975956013328";
    Facebook * fb = [[[Facebook alloc] initWithAppId:appId andDelegate:self] autorelease];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    appId, @"app_id",
                                    @"http://www.facebook.com/wisecrackapp", @"link",
                                    @"http://screendirt.com/post_facebook_small.png", @"picture",
                                    [NSString stringWithFormat:@"I've just scored %d on Wisecrack.", _score], @"name",
                                    @"And I'm rather happy about it.", @"caption",
                                    @"Wisecrack - The word game for people who can't read good. Available now on iPhone.", @"description",
                                    nil];
    [fb dialog:@"feed" andParams:params andDelegate:self];
    
}

- (void) openTwitter
{
    [[MetricMonster monster] queue:@"OpenTwitter"];
    
    //Grab App Delegate so you can use rootviewcontroller
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //*** Prepare Your Tweet ***//
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:[NSString stringWithFormat:@"I've just scored %d on Wisecrack.", _score]];
    //[twitter addURL:[NSURL URLWithString:item.link]];
    
    //Using a picture from the web
    //[twitter addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.icon]]]];
    
    //Check to see if the phone can tweet (iOS 5)
    if ([TWTweetComposeViewController canSendTweet]) {
        //Use delegate viewController to present twitter controller
        [delegate.viewController presentModalViewController:twitter animated:YES];
    }else{
        //Do anything here that is pre iOS 5 like a webview for twitter
    }
    
    [twitter release];
}

-(void) onLocalPlayerAuthenticationChanged
{
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
    
    if (localPlayer.authenticated)
    {
        GameKitHelper * gk = [GameKitHelper sharedGameKitHelper];
        [gk showLeaderboard];
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

