//
//  TrueFriendsGame.m
//  Wisecrack
//
//  Created by Gareth Stokes on 15/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "TrueFriendsGame.h"
#import "WisecrackConfig.h"

@implementation TrueFriendsGame

- (id) init
{
    if( (self=[super init]))
    {
        NSMutableArray * sw = [NSMutableArray arrayWithCapacity:16];
        NSMutableArray * mw = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray * lw = [NSMutableArray arrayWithCapacity:20];
        
        // small words
        [sw addObject:@"am:small"];
        [sw addObject:@"be:small"];
        [sw addObject:@"dog:small"];
        [sw addObject:@"i:small"];
        [sw addObject:@"in:small"];
        
        [sw addObject:@"is:small"];
        [sw addObject:@"it:small"];
        [sw addObject:@"my:small"];
        [sw addObject:@"of:small"];
        [sw addObject:@"tea:small"];
        
        [sw addObject:@"the:small"];
        [sw addObject:@"tip:small"];
        [sw addObject:@"to:small"];
        [sw addObject:@"you:small"];
        [sw addObject:@"let:small"];
        
        [sw addObject:@"eat:small"];
        
        // medium words
        [mw addObject:@"work:medium"];
        //[mw addObject:@"balls:medium"];
        [mw addObject:@"cave:medium"];
        [mw addObject:@"curse:medium"];
        [mw addObject:@"feel:medium"];
        
        [mw addObject:@"hate:medium"];
        [mw addObject:@"have:medium"];
        [mw addObject:@"love:medium"];
        [mw addObject:@"lick:medium"];
        [mw addObject:@"poet:medium"];
        
        [mw addObject:@"shaft:medium"];
        [mw addObject:@"stab:medium"];
        [mw addObject:@"saucy:medium"];
        [mw addObject:@"laugh:medium"];
        [mw addObject:@"hall:medium"];
        
        [mw addObject:@"touch:medium"];
        [mw addObject:@"work:medium"];
        [mw addObject:@"cake:medium"];
        [mw addObject:@"them:medium"];
        [mw addObject:@"fire:medium"];
        
        [mw addObject:@"ring:medium"];
        
        // large words
        [lw addObject:@"bespoke:large"];
        [lw addObject:@"bottom:large"];
        [lw addObject:@"classes:large"];
        [lw addObject:@"danger:large"];
        [lw addObject:@"declare:large"];
        
        [lw addObject:@"enemies:large"];
        [lw addObject:@"except:large"];
        [lw addObject:@"friends:large"];
        [lw addObject:@"drinking:large"];
        [lw addObject:@"unique:large"];
        
        [lw addObject:@"coffee:large"];
        [lw addObject:@"nothing:large"];
        [lw addObject:@"legend:large"];
        [lw addObject:@"genius:large"];
        //[lw addObject:@"front:large"];
        
        [lw addObject:@"reading:large"];
        [lw addObject:@"stroke:large"];
        [lw addObject:@"greedy:large"];
        [lw addObject:@"pretty:large"];
        [lw addObject:@"radical:large"];
        
        [lw addObject:@"burning:large"];

        [self shuffle:sw];
        [self shuffle:mw];
        [self shuffle:lw];
        
        wordsInPlay = [NSMutableArray array];
        
        int gameWords = [[WisecrackConfig config] gameWords];
        int count = 0;
        
        gameWords /= 3;
        
        NSIndexSet * indexSet;
        indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, gameWords)];
        [wordsInPlay addObjectsFromArray:[lw objectsAtIndexes:indexSet]];
        [lw removeObjectsAtIndexes:indexSet];
        count += gameWords;
        
        [wordsInPlay addObjectsFromArray:[mw objectsAtIndexes:indexSet]];
        [mw removeObjectsAtIndexes:indexSet];
        count += gameWords;
        
        [wordsInPlay addObjectsFromArray:[sw objectsAtIndexes:indexSet]];
        [sw removeObjectsAtIndexes:indexSet];
        count += gameWords;
        if (count < [[WisecrackConfig config] gameWords])
        {
            gameWords = [[WisecrackConfig config] gameWords] - count;
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, gameWords)];
            [wordsInPlay addObjectsFromArray:[sw objectsAtIndexes:indexSet]];
            [sw removeObjectsAtIndexes:indexSet];
        }    
    }
    
    return self;
}

@end
