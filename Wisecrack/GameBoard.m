//
//  GameBoard.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//

#import "GameBoard.h"

@implementation GameBoard
@synthesize size;
@synthesize name;

@synthesize rows;
@synthesize columns;

- (id) init
{
    if( (self=[super init]))
    {
        [self setSize:CGSizeMake(kBoardColumns, kBoardRows)];
    }
    
    return self;
}

@end
