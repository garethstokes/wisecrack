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
        NSMutableArray * sw = [NSMutableArray arrayWithCapacity:14];
        NSMutableArray * mw = [NSMutableArray arrayWithCapacity:17];
        NSMutableArray * lw = [NSMutableArray arrayWithCapacity:17];
        
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
        
        // medium words
        [mw addObject:@"work:medium"];
        [mw addObject:@"balls:medium"];
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
        [lw addObject:@"front:large"];
        
        [lw addObject:@"reading:large"];
        [lw addObject:@"stroke:large"];

        [self shuffle:sw];
        [self shuffle:mw];
        [self shuffle:lw];
        
        wordsInPlay = [NSMutableArray array];
        
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
        [wordsInPlay addObjectsFromArray:[sw objectsAtIndexes:indexSet]];
        [wordsInPlay addObjectsFromArray:[mw objectsAtIndexes:indexSet]];
        [wordsInPlay addObjectsFromArray:[lw objectsAtIndexes:indexSet]];

        [sw removeObjectsAtIndexes:indexSet];
        [mw removeObjectsAtIndexes:indexSet];
        [lw removeObjectsAtIndexes:indexSet];
    }
    
    return self;
}

@end
