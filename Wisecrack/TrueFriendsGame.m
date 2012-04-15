//
//  TrueFriendsGame.m
//  Wisecrack
//
//  Created by Gareth Stokes on 15/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "TrueFriendsGame.h"

@implementation TrueFriendsGame

- (id) init
{
    if( (self=[super init]))
    {
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
            [w addObject:[GameItem wordWith:@"true" andColour:colour andSize:@"medium"]];
            
            // friends
            [w addObject:[GameItem wordWith:@"friends" andColour:colour andSize:@"large"]];
            
            // stab
            [w addObject:[GameItem wordWith:@"stab" andColour:colour andSize:@"medium"]];            
            
            // you
            [w addObject:[GameItem wordWith:@"you" andColour:colour andSize:@"small"]];            
            
            // in
            [w addObject:[GameItem wordWith:@"in" andColour:colour andSize:@"small"]];
            
            // the
            [w addObject:[GameItem wordWith:@"the" andColour:colour andSize:@"small"]];
            
            // front
            [w addObject:[GameItem wordWith:@"front" andColour:colour andSize:@"large"]];
            
            numberOfWords += 7;
        }
        
        words = w;
    }
    
    return self;
}

@end
