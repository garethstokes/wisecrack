//
//  GameBoard.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//

#import "GameBoard.h"
#import "TrueFriendsGame.h"
#import "SettingsManager.h"

@implementation GameBoard
@synthesize size;
@synthesize dirty;
@synthesize chain;
@synthesize name;
@synthesize withBonus;

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
        
        dirty = NO;
        chain = NO;
        withBonus = YES;
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
        if (left)
            [words setValue:left forKey:[left hash]];
    }
    
    // right
    if ((word.offset) + word.size.width <= kBoardColumns)
    {
        GameItem *right = [self wordAtPosition:CGPointMake(word.offset + word.size.width, word.row)];
        if (right)
            [words setValue:right forKey:[right hash]];
    }
    
    // top
    for (int i = 0; i < word.size.width; i++)
    {
        if (word.row == kBoardRows) break;
        
        CGPoint p = CGPointMake(word.offset +i, word.row +1);
        GameItem *w = [self wordAtPosition:p];
        if (w)
            [words setValue:w forKey:[w hash]];
    }
    
    // bottom
    for (int i = 0; i < word.size.width; i++)
    {
        if (word.row == 1) break;
        
        CGPoint p = CGPointMake(word.offset +i, word.row -1);
        GameItem *w = [self wordAtPosition:p];
        if (w)
            [words setValue:w forKey:[w hash]];
    }
    
    NSArray *result = [words allValues];
    return result;
}

- (BOOL) matches:(GameItem *)word resultSet:(NSMutableArray *)results matchSize:(int)matchSize
{
    //NSLog(@"matchSize: %d", matchSize);
    NSMutableDictionary * colourMatches = [NSMutableDictionary dictionary];
    [self matchingColours:word result:colourMatches];
    if ([[colourMatches allKeys] count] >= matchSize)
        [results addObject:colourMatches];
    
    // ask the board for all the matching words 
    NSMutableDictionary * wordMatches = [NSMutableDictionary dictionary];
    [self matchingWords:word result:wordMatches];
    if ([wordMatches.allKeys count] >= matchSize)
    {
        [results addObject:wordMatches];
    }
    
    if ([results count] == 0)
    {
        NSMutableDictionary * singleItem = [NSMutableDictionary dictionary];
        [singleItem setValue:word forKey:[word hash]];
    }
    
    NSString * chaining = [[SettingsManager sharedSettingsManager] getString:@"Chain" withDefault:@"NO"];
    if ([chaining isEqualToString:@"NO"])
    {
        return [results count] > 0;
    }
    
    for (GameItem * matchedWord in [[colourMatches copy] allValues])
    {
        wordMatches = [NSMutableDictionary dictionary];
        [self matchingWords:matchedWord result:wordMatches];
        if ([wordMatches.allKeys count] >= matchSize)
            [results addObject:wordMatches];
    }
    
    // we need more than N matches to continue. 
    return [results count] > 0; //([colourMatches.allKeys count] > matchSize && wordMatchesOnOriginalButtonClicked == NO);
}

- (void) matchingColours:(GameItem *)item result:(NSMutableDictionary *)d
{
    // don't keep going if we are brick
    if ([item.name isEqualToString:@"brick"])
    {
        return;
    }
    
    NSArray *neighbours = [self neighbours:item];
    
    for (GameItem *word in neighbours) 
    {
        //NSLog(@"%@", [word hash]);
        
        if (word.colour == item.colour || [word.name isEqualToString:@"brick"]) 
        {
            if ([d objectForKey:[word hash]] == nil)
            {
                [d setValue:word forKey:[word hash]];
                [self matchingColours:word result:d];
            }
        }
    }
}

- (void) matchingWords:(GameItem *)item result:(NSMutableDictionary *)d
{
    // don't keep going if we are brick
    if ([item.name isEqualToString:@"brick"])
    {
        return;
    }
    
    NSArray *neighbours = [self neighbours:item];
    
    for (GameItem *word in neighbours) 
    {
        if ([word.name isEqualToString:[item name]] || [word.name isEqualToString:@"brick"])
        {
            if ([d objectForKey:[word hash]] == nil)
            {
                [d setValue:word forKey:[word hash]];
                [self matchingWords:word result:d];
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
            //NSLog(@"found word at pos: %@", [foundItem hash]);
            return NO;
        }
    }
    
    return YES;
}

- (bool) hasUnactivatedBonus:(Bonus *)bonus
{
    int count = 0;
    for (int i = 0; i < kBoardRows; i++) 
    {
        NSMutableArray* row = [rows objectAtIndex:i];
        for (GameItem * word in row)
        {
            if ( [[word name] isEqualToString:[bonus name]] )
            {
                // yep, found one. 
                count++;
            }
        }
    }
    
    return count > 3;
}

- (void) enablePowerUps
{
    [self setWithBonus:YES];
}

- (void) disablePowerUps
{
    [self setWithBonus:NO];
}

- (void) fill
{
    int x = 1;
    BaseGame* game = [[TrueFriendsGame alloc] init];
    
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
            GameItem * word = [[game pickWordAtRandom:withBonus] duplicate];
            
            if ([word bonus] && false)
            {
                // check if we already have a bunch of bonuses
                // on the board already.
                if ([self hasUnactivatedBonus:(Bonus *)word])
                    continue;
            }
            
            word.offset = x;
            word.row = i+1;
            
            if ([self fits:word offset:x row:i +1]) 
            {
                //NSLog(@"fits: %@", [word hash]);
                if ([word bonus])
                    [self setWithBonus:NO];
            }
            else 
            { 
                // i want you to think about this code
                // because i was very drunk when i wrote it. 
                GameItem *w = [[[GameItem alloc] init] autorelease];
                [w setSize:CGSizeMake(1, 1)];
                if ([self fits:w offset:x row:i +1]) continue;
                
                x++;
                continue; 
            }
            
            if (x + word.size.width > kBoardColumns +1) continue;
            
            if (word.size.width <= len)
            {
                x += word.size.width;
                //len -= word.size.width;
                [row addObject:word];
                //NSLog(@"[ x => %d, width => %d, row => %d ]", word.offset, (int)word.size.width, word.row);
                //NSLog(@"adding: %@, x: %d", [word hash], x);
            }
        }
        x = 1;
    }

    [game release];
}

@end