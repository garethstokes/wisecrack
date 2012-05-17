//
//  GameObjectCache.h
//  greedy
//
//  Created by Richard Owen on 20/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayer.h"
#import "HudLayer.h"
#import "GameScene.h"

#define sharedGameLayer  [[GameObjectCache sharedGameObjectCache] gameLayer]
#define sharedHudLayer  [[GameObjectCache sharedGameObjectCache] hudLayer]
#define sharedGameScene  [[GameObjectCache sharedGameObjectCache] gameScene]

@interface GameObjectCache : NSObject {
    GameLayer* gameLayer_;
    HudLayer* hudLayer_;
    GameScene* gameScene_;
    
    SpriteHelperLoader * smallSprites_;
    SpriteHelperLoader * mediumSprites_;
    SpriteHelperLoader * largeSprites_;
}

/** Retruns ths shared instance of the Game Object cache */
+ (GameObjectCache *) sharedGameObjectCache;

/** Purges the cache. It releases the scene, Layer and Physics stuffs.
 */
+(void)purgeGameObjectCache;

-(void) addGameLayer:(GameLayer*)newGameLayer;
-(void) addHudLayer:(HudLayer*)newHudLayer;
-(void) addGameScene:(GameScene*)newGameScene;

-(GameLayer*) gameLayer;
-(HudLayer*) hudLayer;
-(GameScene*) gameScene;

- (SpriteHelperLoader *)smallSprites;
- (SpriteHelperLoader *)mediumSprites;
- (SpriteHelperLoader *)largeSprites;

@end
