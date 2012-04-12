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

- (id)init
{
  CCLOG(@"GameObjectCache Init");
	if( (self=[super init]) ) {
        gameLayer_ = nil;
        hudLayer_ = nil;
    }
	
	return self;
}

- (void)dealloc {
  CCLOG(@"GameObjectCache Dealloc");
  [gameLayer_ release];
  [hudLayer_ release];
  
  [super dealloc];
}

@end
