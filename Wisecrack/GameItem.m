//
//  GameItem.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//

#import "GameItem.h"
#import "GameObjectCache.h"

@implementation GameItem
@synthesize name;
@synthesize colour;
@synthesize size;
@synthesize offset;
@synthesize row;
@synthesize key_up;
@synthesize key_down;
@synthesize loader;
@synthesize bonus;

- (id) init
{
    if( (self=[super init]) )
    {
        //[self doesNotRecognizeSelector:_cmd];
        //[self release];
        //return nil;
    }
    
    return self;
}

- (GameItem *) duplicate
{
    GameItem * copy;
    if (bonus)
    {
        Bonus * bc = [[Bonus alloc] init:name colour:colour size:size];
        Bonus * b = (Bonus *)self;
        
        [bc setRunningOut:[b runningOut]];
        [bc setDurability:[b durability]];
        [bc setActivatedTime:[b activatedTime]];
        
        copy = bc;        
    }
    else 
    {
        copy = [[Word alloc] init:name colour:colour size:size];
    }

    [copy autorelease];
    return copy;
}

- (NSString *) hash
{
    NSString *x = [NSString stringWithFormat:@"[ name => %@, offset => %d, row => %d, width => %f ]", name, offset, row, size.width];
    return x;
}

- (NSString *) key_sound
{
    //@"base_12_c.m4a
    NSString * note = @"a";
    if (offset < 9) note = @"c";
    if (offset < 3) note = @"b";
    note = @"c";
    
    return [NSString stringWithFormat:@"base_%d_%@.m4a", row, note];
}

- (CCMenuItemImage *) buttonWithTarget:(id)target selector:(SEL)selector
{
    CCSprite * upimage = [loader spriteWithUniqueName:key_up atPosition:CGPointMake(0,0) inLayer:nil];
    
    CCSprite * downimage = [loader spriteWithUniqueName:key_down atPosition:CGPointMake(0,0) inLayer:nil];
    
    CCMenuItemImage *button = [CCMenuItemImage 
                               itemFromNormalSprite:upimage
                               selectedSprite:downimage
                               target:target 
                               selector:selector];
    
    if (size.width == 3)
    {
        [button setAnchorPoint:CGPointMake(0.19, 0.5)];
    }
    
    if (size.width == 2)
    {
        [button setAnchorPoint:CGPointMake(0.27, 0.5)];
    }
    
    [button setWord:self];
    return button;
}

- (void) dealloc
{
    //if (upimage != nil)
        //[upimage dealloc];
    
    //if (downimage != nil)
        //[downimage dealloc];
        
    [super dealloc];
}

@end

@implementation Word

- (id) init:(NSString *)n colour:(NSString *)c size:(CGSize)s
{
    if( (self=[super init]) )
    {
        [self setName:n];
        [self setColour:c];
        [self setSize:s];
        
        [self setKey_up: [NSString stringWithFormat:@"%@_%@_%d_up", 
                             [self colour], 
                             [self name],
                             (int)size.width] ];
        
        [self setKey_down: [NSString stringWithFormat:@"%@_%@_%d_down", 
                               [self colour], 
                               [self name],
                               (int)size.width] ];
        
        if (size.width == 1) loader = [[GameObjectCache sharedGameObjectCache] smallSprites];
        if (size.width == 2) loader = [[GameObjectCache sharedGameObjectCache] mediumSprites];
        if (size.width == 3) loader = [[GameObjectCache sharedGameObjectCache] largeSprites];
        
        bonus = NO;
    }
    
    return self;
}

+ (Word *) wordWith:(NSString *)name andColour:(NSString *)colour andSize:(NSString *)size
{
    Word * word;
    if ([@"large" isEqualToString:size]) 
    {
        word = [[[Word alloc] init:name 
                            colour:colour 
                              size:CGSizeMake(3, 1)] autorelease];
    }
    else if ([@"medium" isEqualToString:size]) 
    {
        word = [[[Word alloc] init:name 
                            colour:colour 
                              size:CGSizeMake(2, 1)] autorelease];
    }
    else if ([@"small" isEqualToString:size]) 
    {
        word = [[[Word alloc] init:name 
                            colour:colour 
                              size:CGSizeMake(1, 1)] autorelease];
    } else 
        return NULL;
    
    [word setColour:colour];
    [word setName:name];
    return word;
}

@end