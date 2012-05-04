//
//  TrueFriendsGame.m
//  Wisecrack
//
//  Created by Gareth Stokes on 15/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "TrueFriendsGame.h"

@implementation TrueFriendsGame

- (id) initTo:(int)fillCount
{
    if( (self=[super init]))
    {
        wisecrackLength = 18;
        
        // otherwise it will fuck with our word count.
        if (fillCount > wisecrackLength) fillCount = wisecrackLength;
        
        NSMutableArray* w = [[NSMutableArray alloc] init];
        numberOfWords = 0;
        
        for (int i = 0; i < 5; i++)
        {
            NSString* colour; 
            if (i == 0) colour = @"green";
            if (i == 1) colour = @"red";
            if (i == 2) colour = @"blue";
            if (i == 3) colour = @"yellow";
            if (i == 4) colour = @"grey";
            
            // true
            if (fillCount >= 1)
                [w addObject:[GameItem wordWith:@"true" andColour:colour andSize:@"medium"]];
            
            // friends
            if (fillCount >= 2)
                [w addObject:[GameItem wordWith:@"friends" andColour:colour andSize:@"large"]];
            
            // you
            if (fillCount >= 3)
                [w addObject:[GameItem wordWith:@"you" andColour:colour andSize:@"small"]];             
            
            // stab
            if (fillCount >= 4)
                [w addObject:[GameItem wordWith:@"stab" andColour:colour andSize:@"medium"]];
            
            // in
            if (fillCount >= 5)
                [w addObject:[GameItem wordWith:@"in" andColour:colour andSize:@"small"]];
            
            // the
            if (fillCount >= 6)
                [w addObject:[GameItem wordWith:@"the" andColour:colour andSize:@"small"]];
            
            // front
            if (fillCount >= 7)
                [w addObject:[GameItem wordWith:@"front" andColour:colour andSize:@"medium"]];
            
            if (fillCount >= 8)
                [w addObject:[GameItem wordWith:@"legend" andColour:colour andSize:@"large"]];
    
            if (fillCount >= 9)
                [w addObject:[GameItem wordWith:@"you" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 10)
                [w addObject:[GameItem wordWith:@"it" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 11)
                [w addObject:[GameItem wordWith:@"is" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 12)
                [w addObject:[GameItem wordWith:@"of" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 13)
                [w addObject:[GameItem wordWith:@"dog" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 14)
                [w addObject:[GameItem wordWith:@"be" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 15)
                [w addObject:[GameItem wordWith:@"am" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 16)
                [w addObject:[GameItem wordWith:@"tip" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 17)
                [w addObject:[GameItem wordWith:@"tea" andColour:colour andSize:@"small"]];
            
            if (fillCount >= 18)
                [w addObject:[GameItem wordWith:@"hall" andColour:colour andSize:@"medium"]];
            
            NSLog(@"fill count: %d", fillCount);
            numberOfWords += fillCount;
        }
        
        words = w;
    }
    
    return self;
}

@end
