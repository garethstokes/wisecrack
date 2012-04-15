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
            
            // small;
            GameItem* small = [GameItem small];
            [small setColour:colour];
            [small setName:@"of"];
            [w addObject:small];
            
            // medium;
            GameItem *medium = [GameItem medium];
            [medium setColour:colour];
            [medium setName:@"hall"];
            [w addObject:medium];
            
            // large;
            GameItem *large = [GameItem large];
            [large setColour:colour];
            [large setName:@"legends"];
            [w addObject:large];
            
            numberOfWords += 3;
        }
        
        words = w;
    }
    
    return self;
}

@end
