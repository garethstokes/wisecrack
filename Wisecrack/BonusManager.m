//
//  BonusManager.m
//  Wisecrack
//
//  Created by Gareth Stokes on 25/05/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "BonusManager.h"
#import "GameObjectCache.h"

@implementation Bonus

- (id) init:(NSString *)n colour:(NSString *)c size:(CGSize)s
{
    if( (self=[super init]) )
    {
        [self setName:n];
        [self setColour:c];
        [self setSize:s];
        
        [self setKey_up: [NSString stringWithFormat:@"%@_bonus_%@_%d_up", 
                             colour, 
                             name,
                             (int)size.width] ];
        
        [self setKey_down: [NSString stringWithFormat:@"%@_bonus_%@_%d_down", 
                               colour, 
                               name,
                               (int)size.width] ];
        
        loader = [[GameObjectCache sharedGameObjectCache] bonusSprites];
        bonus = YES;
    }
    
    return self;
}

- (NSString *) key
{
    if ( [[self name] isEqualToString:@"shake"] )
        return @"top_bar_shake_icon_";
    
    //TODO: keep going with other types, this default will do
    //      for now. 
    return @"top_bar_shake_icon_";
}

- (void) activate
{
    BonusManager * bm = [[GameObjectCache sharedGameObjectCache] bonusManager]; 
    [bm addBonus:self];
    
    HudLayer * hud = [[GameObjectCache sharedGameObjectCache] hudLayer];
    [hud updateBonus];
    
    GameLayer * gl = [[GameObjectCache sharedGameObjectCache] gameLayer];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCSprite * popup = [loader spriteWithUniqueName:@"bonus_flag_shake" 
                                         atPosition:CGPointMake((s.width /2) + 5, s.height /2) 
                                            inLayer:nil];
    
    [gl addChild:popup z:100];
    [popup runAction:[CCFadeOut actionWithDuration:2.5]];
}

+ (Bonus *) shake:(NSString *)colour
{
    Bonus * b = [[[Bonus alloc] init:@"shake" 
                              colour:colour 
                                size:CGSizeMake(1, 1)] autorelease];
    return b;
}

+ (Bonus *) swipe:(NSString *)colour
{
    Bonus * b = [[[Bonus alloc] init] autorelease];
    [b setSize:CGSizeMake(1, 1)];
    [b setName:@"swipe"];
    [b setColour:colour];
    return b;
}

+ (Bonus *) multiplier:(NSString *)colour
{
    Bonus * b = [[[Bonus alloc] init] autorelease];
    [b setSize:CGSizeMake(1, 1)];
    [b setName:@"multiplier"];
    [b setColour:colour];
    return b;
}

+ (Bonus *) chain
{
    Bonus * b = [[[Bonus alloc] init] autorelease];
    [b setSize:CGSizeMake(1, 1)];
    [b setName:@"chain"];
    [b setColour:@"double rainbow"];
    return b;
}

@end

@implementation BonusManager

- (id) init
{
    if( (self=[super init]) )
    {
        bonusItems_ = [[NSMutableArray array] retain];
    }
    
    return self;
}

- (void) dealloc
{
    [bonusItems_ dealloc];
    [super dealloc];
}

- (NSUInteger) bonusCount
{
    return [bonusItems_ count];
}

- (void) addBonus:(Bonus *)bonus
{
    Bonus * copy = (Bonus *)[bonus duplicate];
    if ([self bonusCount] <= 4)
    {
        [bonusItems_ addObject:copy];
    }
}

- (NSArray *) activeBonusItems 
{ 
    return bonusItems_;
}

- (void) removeShakeIfAvailable
{
    Bonus * theChosenOne = nil;
    for ( Bonus * bonus in bonusItems_ )
    {
        if ( [[bonus name] isEqualToString:@"shake"] )
        {
            theChosenOne = bonus;
            break;
        }
    }
    
    if (theChosenOne == nil) return;
    [bonusItems_ removeObject:theChosenOne];
    
    HudLayer * hud = [[GameObjectCache sharedGameObjectCache] hudLayer];
    [hud updateBonus];
}

@end
