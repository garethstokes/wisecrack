//
//  BonusManager.m
//  Wisecrack
//
//  Created by Gareth Stokes on 25/05/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "BonusManager.h"
#import "GameObjectCache.h"
#import "WisecrackConfig.h"

@implementation Bonus

@synthesize durability;
@synthesize runningOut;
@synthesize activatedTime;

- (id) init:(NSString *)n colour:(NSString *)c size:(CGSize)s
{
    if( (self=[super init]) )
    {
        [self setName:n];
        [self setColour:c];
        [self setSize:s];
        
        [self setRunningOut:NO];
        
        durability = 0;
        
        if ( [name isEqualToString:@"shake"] )
        {
            [self setKey_up: [NSString stringWithFormat:@"%@_bonus_%@_%d_up", 
                                 colour, 
                                 name,
                                 (int)size.width] ];
            
            [self setKey_down: [NSString stringWithFormat:@"%@_bonus_%@_%d_down", 
                                   colour, 
                                   name,
                                   (int)size.width] ];
            
            loader = [[GameObjectCache sharedGameObjectCache] bonusSprites];
        }
        else if ( [name isEqualToString:@"brick"] )
        {
            [self setKey_up: [NSString stringWithFormat: @"bricks_%d_units_a", (int)size.width] ];
            [self setKey_down: [NSString stringWithFormat: @"bricks_%d_units_a", (int)size.width] ];
            
            loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"bonus_brick"];
            
            durability = 2;
        }
        else if ( [name isEqualToString:@"multiplier"] )
        {
            [self setKey_up: [NSString stringWithFormat: @"%@_bonus_x2_1_up", colour] ];
            [self setKey_down: [NSString stringWithFormat: @"%@_bonus_x2_1_down", colour] ];
            
            loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"bonus_multiply"];
        }
        else if ( [name isEqualToString:@"chain"] )
        {
            [self setKey_up: [NSString stringWithFormat: @"%@_bonus_chaining_1_up", colour] ];
            [self setKey_down: [NSString stringWithFormat: @"%@_bonus_chaining_1_down", colour] ];
            
            loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"bonus_chaining"];
        }
        
        bonus = YES;
    }
    
    return self;
}

- (void) decreaseDurability
{
    if ( [name isEqualToString:@"brick"] )
    {
        if ( durability == 2 )
        {
            [self setKey_up: [NSString stringWithFormat: @"bricks_%d_units_b", (int)size.width] ];
            [self setKey_down: [NSString stringWithFormat: @"bricks_%d_units_b", (int)size.width] ];
        }
        else if ( durability == 1 )
        {
            [self setKey_up: [NSString stringWithFormat: @"bricks_%d_units_c", (int)size.width] ];
            [self setKey_down: [NSString stringWithFormat: @"bricks_%d_units_c", (int)size.width] ];
        }
    }
    
    durability--;
}

- (NSString *) key
{
    if ( [[self name] isEqualToString:@"shake"] )
        return @"top_bar_shake_icon_";
    
    if ( [[self name] isEqualToString:@"brick"] )
    {
        return key_up;
    }
    
    if ( [[self name] isEqualToString:@"multiplier"] )
        return [NSString stringWithFormat:@"top_bar_x2_%@_icon", colour];
    
    if ( [[self name] isEqualToString:@"chain"] )
        return @"top_bar_chain_icon_";
    
    //TODO: keep going with other types, this default will do
    //      for now. 
    return @"top_bar_shake_icon_";
}

- (void) activate
{
    if ( [name isEqualToString:@"brick"] )
    {
        return;
    }
    
    BonusManager * bm = [[GameObjectCache sharedGameObjectCache] bonusManager]; 
    [bm addBonus:self];
    
    HudLayer * hud = [[GameObjectCache sharedGameObjectCache] hudLayer];
    [hud updateBonus];
    
    if ( [name isEqualToString:@"shake"] )
    {
        GameLayer * gl = [[GameObjectCache sharedGameObjectCache] gameLayer];
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        CCSprite * popup = [loader spriteWithUniqueName:@"bonus_flag_shake" 
                                             atPosition:CGPointMake((s.width /2) + 5, s.height /2) 
                                                inLayer:nil];
        
        [gl addChild:popup z:100];
        [popup runAction:[CCFadeOut actionWithDuration:2.5]];
    }
    
    if ( [name isEqualToString:@"multipler"] )
    {
        GameLayer * gl = [[GameObjectCache sharedGameObjectCache] gameLayer];
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        CCSprite * popup = [loader spriteWithUniqueName:@"bonus_flag_x2" 
                                             atPosition:CGPointMake((s.width /2) + 5, s.height /2) 
                                                inLayer:nil];
        
        [gl addChild:popup z:100];
        [popup runAction:[CCFadeOut actionWithDuration:2.5]];
    }
}

+ (Bonus *) random:(NSString *)colour
{
    int value = random() % 100;
    if (value <= [[WisecrackConfig config] chanceBrick])
    {
        return [Bonus brick];
    }
    else 
    {
        int i = random() % 3;
        if (i == 0) return [Bonus shake:colour];
        if (i == 1) return [Bonus multiplier:colour];
        if (i == 2) return [Bonus chain:colour];
        
        //NSLog(@"random mod: %d", i);
        
        // default
        return [Bonus multiplier:colour];
    }
}

+ (Bonus *) shake:(NSString *)colour
{
    Bonus * b = [[[Bonus alloc] init:@"shake" 
                              colour:colour 
                                size:CGSizeMake(1, 1)] autorelease];
    return b;
}

+ (Bonus *) brick
{
    int width = random() % 3;
    width++;
    Bonus * b = [[[Bonus alloc] init:@"brick" 
                              colour:@"double rainbow"
                                size:CGSizeMake(width, 1)] autorelease];
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
    Bonus * b = [[[Bonus alloc] init:@"multiplier" 
                              colour:colour 
                                size:CGSizeMake(1, 1)] autorelease];
    return b;
}

+ (Bonus *) chain:(NSString *)colour
{
    Bonus * b = [[[Bonus alloc] init:@"chain" 
                              colour:colour 
                                size:CGSizeMake(1, 1)] autorelease];
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
    if ([self bonusCount] < 4)
    {
        [bonusItems_ addObject:copy];
        return;
    }
    
    [bonusItems_ removeObjectAtIndex:0];
    [bonusItems_ addObject:copy];
}

- (NSArray *) activeBonusItems 
{ 
    return bonusItems_;
}

- (BOOL) removeShakeIfAvailable
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
    
    if (theChosenOne == nil) return NO;
    [bonusItems_ removeObject:theChosenOne];
    
    HudLayer * hud = [[GameObjectCache sharedGameObjectCache] hudLayer];
    [hud updateBonus];
    return YES;
}

- (void) removeChain:(Bonus *)chain
{
    if ( [chain.name isEqualToString:@"chain"] == false )
    {
        return;
    }
    
    Bonus * theChosenOne = nil;
    for ( Bonus * bonus in bonusItems_ )
    {
        if ( [[bonus name] isEqualToString:@"chain"] && 
            [bonus activatedTime] == [chain activatedTime] )
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

- (void) removeMultipler:(Bonus *)multiplier
{
    if ( [multiplier.name isEqualToString:@"multiplier"] == false )
    {
        return;
    }
    
    Bonus * theChosenOne = nil;
    for ( Bonus * bonus in bonusItems_ )
    {
        if ( [[bonus name] isEqualToString:@"multiplier"] && 
             [bonus activatedTime] == [multiplier activatedTime] )
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

- (int) activeMultiplier
{
    int multipler = 1;
    for (Bonus * bonus in bonusItems_) 
    {
        if ([bonus.name isEqualToString:@"multiplier"])
        {
            multipler *= 2;
        }
    }
    
    //NSLog(@"multipler: %d", multipler);
    return multipler;
}

@end
