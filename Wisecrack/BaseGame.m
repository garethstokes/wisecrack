//
//  BaseGame.m
//  Wisecrack
//
//  Created by Gareth Stokes on 15/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "BaseGame.h"
#import "BonusManager.h"

@implementation BaseGame
@synthesize wordsInPlay;

- (id) init
{
    if( (self=[super init]) )
    {

    }
    
    return self;
}
- (void)shuffle
{
    [self shuffle:wordsInPlay];
}

- (void)shuffle:(NSMutableArray *)w
{
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [w count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [w exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (GameItem *)pickWordAtRandom:(BOOL)withBonus
{
    [self shuffle];
    
    NSString * key = [wordsInPlay objectAtIndex:0];
    
    NSRange range = [key rangeOfString:@":"];
    NSString * name = [key substringToIndex:range.location];
    NSString * size = [key substringFromIndex:range.location +1];
    
    int i = random() % kNumberOfColours;
    NSString* colour; 
    if (i == 0) colour = @"green";
    if (i == 1) colour = @"red";
    if (i == 2) colour = @"blue";
    if (i == 3) colour = @"yellow";
    if (i == 4) colour = @"grey";
    
    int powerup = random() % 100;
    if (withBonus && powerup < kPowerUpChance)
    {
        NSLog(@"BONUS!!");
        return [Bonus random:colour];
    }
    
    return [Word wordWith:name andColour:colour andSize:size];
}

@end
