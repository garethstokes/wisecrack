//
//  PrototypeGame.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//

#import "PrototypeGame.h"
#import "GameConfig.h"

@implementation PrototypeGame
@synthesize words;

- (id) init
{
    if( (self=[super init]))
    {
        NSMutableArray* w = [[NSMutableArray alloc] init];
        numberOfWords = 0;
    
        for (int i = 0; i < 3; i++)
        {
            NSString* colour; 
            if (i == 0) colour = @"green";
            if (i == 1) colour = @"red";
            if (i == 2) colour = @"blue";
            
            // small;
            GameItem* small = [GameItem small];
            [small setColour:colour];
            [w addObject:small];
            
            // medium;
            GameItem *medium = [GameItem medium];
            [medium setColour:colour];
            [w addObject:medium];
            
            // large;
            GameItem *large = [GameItem large];
            [large setColour:colour];
            [w addObject:large];
            
            numberOfWords += 3;
        }
        
        words = w;
    }
    
    return self;
}

- (GameItem *) randomWord
{
    int index = arc4random() % numberOfWords;
    //NSLog(@"random index: %d", index);
    GameItem *word = [words objectAtIndex:index];
    return [word copy];
}

- (void) fill:(GameBoard *)board
{
    //[board setRows:[[NSMutableArray alloc] init]];
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:kBoardRows];

    int x = 1;
    for (int i = 0; i < kBoardRows; i++) {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        int len = kBoardColumns;
        while (len > 0)
        {
            GameItem *word = [self randomWord];
            if (word.size.width <= len)
            {
                word.offset = x;
                x += word.size.width;
                len -= word.size.width;
                [row addObject:word];
                NSLog(@"x => %d, width => %d", word.offset, (int)word.size.width);
            }
        }
        x = 1;
        [rows addObject:row];
        [row release];
    }
    
    [board setRows:rows];
    [rows release];
}

@end
