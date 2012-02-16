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

- (GameItem *) wordAtPosition:(CGPoint)p
{
    p.x++;
    NSArray *row = [rows objectAtIndex:p.y];
    for (GameItem *word in row) {
        int from = word.offset;
        int to = (word.offset + (word.size.width -1));
        if (p.x >= from && p.x <= to)
        {
            return word;
        }
    }
    return nil;
}

- (NSArray *) neighbours:(GameItem *)word
{
    NSMutableDictionary *words = [[[NSMutableDictionary alloc] init] autorelease];
    
    // left
    if (word.offset > 1)
    {
        GameItem *left = [self wordAtPosition:CGPointMake(word.offset -1, word.row)];
        [words setValue:left forKey:[left hash]];
    }
    
    // right
    if ((word.offset -1) + word.size.width < kBoardColumns)
    {
        GameItem *right = [self wordAtPosition:CGPointMake(word.offset + word.size.width, word.row)];
        [words setValue:right forKey:[right hash]];
    }
    
    // top
    for (int i = 0; i < word.size.width; i++)
    {
        if (word.row == kBoardRows) break;
        
        CGPoint p = CGPointMake(word.offset +i, word.row +1);
        GameItem *w = [self wordAtPosition:p];
        [words setValue:w forKey:[w hash]];
    }
    
    // bottom
    for (int i = 0; i < word.size.width; i++)
    {
        if (word.row == 1) break;
        
        CGPoint p = CGPointMake(word.offset +i, word.row -1);
        GameItem *w = [self wordAtPosition:p];
        [words setValue:w forKey:[w hash]];
    }
    
    NSArray *result = [words allValues];
    return result;
}

- (void) matchingColours:(GameItem *)item result:(NSMutableDictionary *)d
{
    NSLog(@"searching neighbours");
    NSArray *neighbours = [self neighbours:item];
    NSLog(@"neighbours found: %d", [neighbours count]);
    
    for (GameItem *word in neighbours) 
    {
        NSLog(@"searching for a match: %@", [word hash]);
        if (word.colour == item.colour) 
        {
            [d setValue:word forKey:[word hash]];
            NSLog(@"match found: %@", [word hash]);
        }
    }
}

@end
