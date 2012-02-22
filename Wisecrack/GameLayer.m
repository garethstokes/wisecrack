//
//  GameLayer.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "GameLayer.h"

@implementation GameLayer
@synthesize board;
@synthesize buttons;

- (id) initWithBoard:(GameBoard *)b
{
    if( (self=[super init]))
    {
        [self setBoard:b];
        loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"hall_of_legends"];
        SpriteHelperLoader *bgloader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"backgrounds"];
        buttons = [[NSMutableArray array] retain];
        
        // background
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [bgloader spriteWithUniqueName:@"level_1_bg_grid-hd" atPosition:CGPointMake(size.width /2, size.height /2) inLayer:nil];
        
        [self addChild:background z:0];
        
        /*
        [loader spriteWithUniqueName:@"green_words_1_unit_test" atPosition:CGPointMake(100, 100) inLayer:self];
        CCSprite *medium = [loader spriteWithUniqueName:@"green_words_2_unit_test" atPosition:CGPointMake(100, 130) inLayer:self];
        [medium setAnchorPoint:CGPointMake(0.27, 0.5)];
        CCSprite *large = [loader spriteWithUniqueName:@"green_words_3_unit_test" atPosition:CGPointMake(100, 160) inLayer:self];
        [large setAnchorPoint:CGPointMake(0.19, 0.5)];
        */
        
        menu = [CCMenu menuWithItems: nil];
        [menu setPosition:CGPointMake(9, 5)];

        [self drawButtons];
        [self addChild:menu z:10];
    }
    
    return self;
}

- (void) clearButtons
{
    // copy each item to a seperate array
    // iterate through that removing from menu.
    NSMutableArray *itemsToDelete = [NSMutableArray array];
    for (CCMenuItemImage *button in [menu children]) 
    {
        [itemsToDelete addObject:button];
    }
    
    for (CCMenuItemImage *button in itemsToDelete) 
    {
        NSLog(@"clearButtons: %@", [button.word hash]);;
        [menu removeChild:button cleanup:YES];
    }
}

- (void) drawButtons
{
    int count = 1;
    
    [self clearButtons];
    
    NSLog(@"iterating through rows now: %d", [board.rows count]);
    for (NSArray *row in [board rows])
    {
        //NSLog(@"row number: %d", count);
        for (GameItem *word in row)
        {
            NSString *key = [NSString stringWithFormat:@"%@_words_%d_unit_test", 
                             [word colour], 
                             (int)word.size.width];
            
            //NSLog(@"%@", key);
            //NSLog(@"x => %d, width => %d", word.offset, (int)word.size.width);
            //NSLog(@"%@", [word hash]);
            CGPoint position;
            
            position.y = count * kUnit;
            position.x = word.offset * kUnit;
            
            //NSLog(@"position( x=>%d, y=>%d )", (int)position.x, (int)position.y);
            CCSprite *sprite = [loader spriteWithUniqueName:key atPosition:CGPointMake(0,0) inLayer:nil];
            CCSprite *sprite2 = [loader spriteWithUniqueName:key atPosition:CGPointMake(0,0) inLayer:nil];
            
            CCMenuItemImage *button = [CCMenuItemImage 
                                       itemFromNormalSprite:sprite
                                       selectedSprite:sprite2
                                       target:self 
                                       selector:@selector(wordClick:)];
            
            if (word.size.width == 3)
            {
                //[sprite setAnchorPoint:CGPointMake(0.19, 0.5)];
                [button setAnchorPoint:CGPointMake(0.19, 0.5)];
            }
            
            if (word.size.width == 2)
            {
                //[sprite setAnchorPoint:CGPointMake(0.27, 0.5)];
                [button setAnchorPoint:CGPointMake(0.27, 0.5)];
            }
            
            //[button setWord:[word duplicate]];
            [button setWord:word];
            NSLog(@"word being set: %@", [word hash]);
            [button setPosition:position];
            [button retain];
            [menu addChild:button];
            [buttons addObject:button];
        }
        
        count++;
    }
}

- (void) wordClick:(id) sender
{
    NSLog(@"click");
    NSMutableDictionary *matches = [NSMutableDictionary dictionary];

    // map buttons to words
    
    GameItem *word = ((CCMenuItemImage *)sender).word;
    NSLog(@"word: %@", [word hash]);
    
    // initial word
    [matches setValue:word forKey:[word hash]];
    
    // ask the board for all the matching colours 
    [board matchingColours:word result:matches];
    
    // profit???
    if ([matches.allKeys count] <= 2) return;
    
    for (GameItem *w in [matches allValues]) 
    {
        for (CCMenuItemImage *button in [menu children]) 
        {
            if ([[button.word hash] isEqualToString:[w hash]])
            {
                NSLog(@"hash: %@", [w hash]);
                //[button setVisible:NO];
                [buttons removeObject:button];
                [menu removeChild:button cleanup:YES];
                
                NSMutableArray *boardRow = [board.rows objectAtIndex:([button.word row] -1)];
                [boardRow removeObject:[button word]];
            }
        }
    }
    
    // refill the board;
    [board fill];
    [self clearButtons];
    [self drawButtons];
}

- (void) dealloc
{   
    [loader release];
    [super dealloc];
}

@end
