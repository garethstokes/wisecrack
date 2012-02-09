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

- (id) initWithBoard:(GameBoard *)b
{
    if( (self=[super init]))
    {
        [self setBoard:b];
        loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"hall_of_legends"];
        
        /*
        [loader spriteWithUniqueName:@"green_words_1_unit_test" atPosition:CGPointMake(100, 100) inLayer:self];
        CCSprite *medium = [loader spriteWithUniqueName:@"green_words_2_unit_test" atPosition:CGPointMake(100, 130) inLayer:self];
        [medium setAnchorPoint:CGPointMake(0.27, 0.5)];
        CCSprite *large = [loader spriteWithUniqueName:@"green_words_3_unit_test" atPosition:CGPointMake(100, 160) inLayer:self];
        [large setAnchorPoint:CGPointMake(0.19, 0.5)];
        */
         
        int count = 1;
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
                NSLog(@"x => %d, width => %d", word.offset, (int)word.size.width);
                CGPoint position;
                
                position.y = count * 30;
                position.x = word.offset * 30;
                
                //NSLog(@"position( x=>%d, y=>%d )", (int)position.x, (int)position.y);
                CCSprite *sprite = [loader spriteWithUniqueName:key atPosition:position inLayer:self];
                
                if (word.size.width == 3)
                {
                    [sprite setAnchorPoint:CGPointMake(0.19, 0.5)];
                }
                
                if (word.size.width == 2)
                {
                    [sprite setAnchorPoint:CGPointMake(0.27, 0.5)];
                }
            }
            
            count++;
        }
    }
    
    return self;
}

@end
