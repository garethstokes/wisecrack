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
        wisecrackLength = 7;
        
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
            
            NSLog(@"fill count: %d", fillCount);
            numberOfWords += fillCount;
        }
        
        words = w;
    }
    
    return self;
}

@end
