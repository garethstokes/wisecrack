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
        
        self.rows = [NSMutableArray array];
        for (int i = 0; i < kBoardRows; i++) 
        {
            NSMutableArray *row = [[NSMutableArray alloc] init];
            [rows addObject:row];
            [row release];
        }
    }
    
    return self;
}

- (GameItem *) wordAtPosition:(CGPoint)p
{
    p.x++;
    NSArray *row = [rows objectAtIndex:(p.y -1)];
    for (GameItem *word in row) {
        int from = word.offset;
        int to = (word.offset + (word.size.width -1));
        //NSLog(@"[ from => %d, to => %d ]", from, to);
        //NSLog(@"[ p.x => %f, p.y => %f ]", p.x, p.y);
        if ((p.x -1) >= from && (p.x -1) <= to)
        {
            //NSLog(@"found");
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
    if ((word.offset) + word.size.width < kBoardColumns)
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
    NSArray *neighbours = [self neighbours:item];
    
    for (GameItem *word in neighbours) 
    {
        if (word.colour == item.colour) 
        {
            if ([d objectForKey:[word hash]] == nil)
            {
                [d setValue:word forKey:[word hash]];
                [self matchingColours:word result:d];
            }
        }
    }
}

- (BOOL) fits:(GameItem* )word offset:(int)offset row:(int)row
{
    // make sure there isn't any other word already set. 
    for (int g = 0; g < word.size.width; g++) 
    {
        GameItem *foundItem;
        foundItem = [self wordAtPosition:CGPointMake(offset +g, row)];
        if (foundItem != nil)
        {
            NSLog(@"found word at pos: %@", [foundItem hash]);
            return NO;
        }
    }
    
    return YES;
}

- (void) fill
{
    int x = 1;
    PrototypeGame* game = [[PrototypeGame alloc] init];
    // loop through all the rows
    for (int i = 0; i < kBoardRows; i++) 
    {
        NSMutableArray* row = [rows objectAtIndex:i];
        int len = kBoardColumns;
        while (x <= len)
        {
            // pick a random word and see if it fits. 
            // and keep doing this until the row has 
            // been filled. 
            int index = arc4random() % [game numberOfWords];
            GameItem *word = [[[game words] objectAtIndex:index] duplicate];
            
            word.offset = x;
            word.row = i+1;
            
            NSLog(@"offset +g: %d, row: %d", x, i+1);
            
            if ([self fits:word offset:x row:i +1]) 
            {
                NSLog(@"fits: %@", [word hash]);
            }
            else 
            { 
                x++;
                //len--;
                continue; 
            }
            
            if (x + word.size.width > kBoardColumns +1) continue;
            
            if (word.size.width <= len)
            {
                x += word.size.width;
                //len -= word.size.width;
                [row addObject:word];
                //NSLog(@"[ x => %d, width => %d, row => %d ]", word.offset, (int)word.size.width, word.row);
                NSLog(@"adding: %@, x: %d", [word hash], x);
            }
        }
        x = 1;
        //[rows addObject:row];
        //[row release];
    }

    //[self setRows:rows];
    //[rows release];
    [game release];
}

@end