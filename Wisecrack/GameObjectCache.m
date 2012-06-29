//
//  GameObjectCache.m
//  greedy
//
//  Created by Richard Owen on 20/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameObjectCache.h"

@implementation GameObjectCache

static GameObjectCache *sharedGameObjectCache_=nil;

+ (GameObjectCache *) sharedGameObjectCache
{
  if(!sharedGameObjectCache_)
    sharedGameObjectCache_ = [[GameObjectCache alloc] init];
  
  return sharedGameObjectCache_;
}

+(void)purgeGameObjectCache
{
  CCLOG(@"Purging Game Object Cache");
  [sharedGameObjectCache_ release];
	sharedGameObjectCache_ = nil;
}

+(id)alloc
{
	NSAssert(sharedGameObjectCache_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

//Add objects

-(void) addGameLayer:(GameLayer*)newGameLayer
{
  CCLOG(@"GameObjectCache addGameLayer");
  // NSAssert(gameLayer_ == nil, @"gameLayer member has already been set in GameObjectCache object ");
  
  if(gameLayer_ != nil)
    [gameLayer_ release];
  
  gameLayer_ = newGameLayer;  
  [gameLayer_ retain];
}

-(void) addHudLayer:(HudLayer*)newHudLayer
{
    CCLOG(@"GameObjectCache addHudLayer");
    // NSAssert(hudLayer_ == nil, @"hudLayer member has already been set in GameObjectCache object ");
    
    if(hudLayer_ != nil)
        [hudLayer_ release];
    
    hudLayer_ = newHudLayer;  
    [hudLayer_ retain];
}

-(void) addGameScene:(GameScene*)newGameScene
{
    CCLOG(@"GameObjectCache addGameScene");
    
    if(gameScene_ != nil)
        [gameScene_ release];
    
    gameScene_ = newGameScene;  
    [gameScene_ retain];
}

//***********************
//Retrieve objects 

-(GameLayer*) gameLayer
{
  NSAssert(gameLayer_ != nil, @"gameLayer member has not been set in GameObjectCache object ");
  
  return gameLayer_;
}

-(HudLayer*) hudLayer
{
    NSAssert(hudLayer_ != nil, @"hudLayer member has not been set in GameObjectCache object ");
    
    return hudLayer_;
}

-(GameScene*) gameScene
{
    NSAssert(gameScene_ != nil, @"gameScene member has not been set in GameObjectCache object ");
    
    return gameScene_;
}

- (BonusManager *) bonusManager
{
    if (bonusManager_ == nil)
    {
        bonusManager_ = [[BonusManager alloc] init];
    }
    
    return bonusManager_;
}

- (SpriteHelperLoader *)smallSprites
{
    if (smallSprites_ == nil)
    {
        smallSprites_ =  [[SpriteHelperLoader alloc] initWithContentOfFile:@"1x1_words"];
    }
    
    return smallSprites_;
}

- (SpriteHelperLoader *)mediumSprites
{
    if (mediumSprites_ == nil)
    {
        mediumSprites_ =  [[SpriteHelperLoader alloc] initWithContentOfFile:@"2x1_words"];
    }
    
    return mediumSprites_;
}

- (SpriteHelperLoader *)largeSprites
{
    if (largeSprites_ == nil)
    {
        largeSprites_ =  [[SpriteHelperLoader alloc] initWithContentOfFile:@"1x3_words"];
    }
    
    return largeSprites_;
}

- (SpriteHelperLoader *)bonusSprites
{
    if (bonusSprites_ == nil)
    {
        bonusSprites_ =  [[SpriteHelperLoader alloc] initWithContentOfFile:@"bonus_shake"];
    }
    
    return bonusSprites_;
}

- (CCSprite *)upSprite:(NSString *)key loader:(SpriteHelperLoader *)loader;
{
    CCSprite * up = [spriteUpCache_ objectForKey:key];
    if (up == NULL) {
        up = [loader spriteWithUniqueName:key atPosition:CGPointMake(0,0) inLayer:nil];
        [spriteUpCache_ setObject:up forKey:key];
    }
    
    return up;
}

- (CCSprite *)downSprite:(NSString *)key loader:(SpriteHelperLoader *)loader;
{
    CCSprite * down = [spriteDownCache_ objectForKey:key];
    if (down == NULL) {
        down = [loader spriteWithUniqueName:key atPosition:CGPointMake(0,0) inLayer:nil];
        [spriteDownCache_ setObject:down forKey:key];
    }
    
    return down;
}

- (id)init
{
  CCLOG(@"GameObjectCache Init");
	if( (self=[super init]) ) {
        gameLayer_ = nil;
        hudLayer_ = nil;
        gameScene_ = nil;
        
        smallSprites_ = nil;
        mediumSprites_ = nil;
        largeSprites_ = nil;
    }
	
	return self;
}

- (void)dealloc {
  CCLOG(@"GameObjectCache Dealloc");
  [gameLayer_ release];
  [hudLayer_ release];
  [gameScene_ release];
    
    [bonusManager_ release];
    
    [smallSprites_ release];
    [mediumSprites_ release];
    [largeSprites_ release];
    
  [super dealloc];
}

@end
