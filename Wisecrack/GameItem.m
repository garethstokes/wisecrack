//
//  GameItem.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//

#import "GameItem.h"

@implementation GameItem
@synthesize name;
@synthesize colour;
@synthesize size;
@synthesize offset;

- (GameItem *) copy
{
    GameItem *copy = [[[GameItem alloc] init] autorelease];
    [copy setName:name];
    [copy setColour:colour];
    [copy setSize:size];
    [copy setOffset:offset];
    return copy;
}

+ (GameItem *) small
{
    GameItem* item = [[[GameItem alloc] init] autorelease];
    [item setSize:CGSizeMake(1, 1)];
    [item setName:@"small"];
    [item setColour:@"green"];
    return item;
}

+ (GameItem *) medium
{
    GameItem* item = [[[GameItem alloc] init] autorelease];
    [item setSize:CGSizeMake(2, 1)];
    [item setName:@"medium"];
    [item setColour:@"green"];
    return item;    
}

+ (GameItem *) large
{
    GameItem* item = [[[GameItem alloc] init] autorelease];
    [item setSize:CGSizeMake(3, 1)];
    [item setName:@"large"];
    [item setColour:@"green"];
    return item;
}

@end

