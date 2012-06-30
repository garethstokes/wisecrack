//
//  Wisecrack.m
//  Wisecrack
//
//  Created by Gareth Stokes on 30/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "Wisecrack.h"
#import "SpriteHelperLoader.h"

@implementation Wisecrack
@synthesize words, key, points;

- (id) initWithWords:(NSString *)w, ...
{
    if ([self init] == nil) return self;
    
    [self setWords:[NSMutableArray array]];
    
    NSString * eachObject;
    va_list argumentList;
    if (w)                      // The first argument isn't part of the varargs list,
    {                                   // so we'll handle it separately.
        [words addObject: w];
        va_start(argumentList, w);          
        while ((eachObject = va_arg(argumentList, NSString *)))
        {
            [words addObject: eachObject];
        }
        va_end(argumentList);
    }
    
    return self;
}

- (CCSprite *)image
{
    SpriteHelperLoader * loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"Wisecracks"];
    return [loader spriteWithUniqueName:key atPosition:ccp(0,0) inLayer:nil];
}

- (BOOL) isFullMatch:(NSArray *)playerWords
{
    NSMutableDictionary * matches = [NSMutableDictionary dictionary];
    for (NSString * name in words) 
    {
        //BOOL shortcut = YES;
        for (GameItem * word in playerWords)
        {
            if ([word.name isEqualToString:name]) 
            { 
                [matches setValue:word forKey:name];
                continue;
            }
        }
        //if (!shortcut) return NO;
    }
    
    return ([matches count] == [words count]);
}

+ (Wisecrack *)find:(NSArray *)words
{
    Wisecrack * one = [[Wisecrack alloc] initWithWords:@"True", @"Friends", @"Stab", @"You", @"In", @"The", @"Back", nil];
    Wisecrack * two = [[Wisecrack alloc] initWithWords:@"Burning", @"Ring", @"Of", @"Fire", nil];
    Wisecrack * three = [[Wisecrack alloc] initWithWords:@"Let", @"Them", @"Eat", @"Cake", nil];
    Wisecrack * four = [[Wisecrack alloc] initWithWords:@"I", @"Have", @"Nothing", @"To", @"Declare", @"Except", @"My", @"Genius", nil];
    Wisecrack * five = [[Wisecrack alloc] initWithWords:@"Work", @"Is", @"The", @"Curse", @"Of", @"The", @"Drinking", @"Classes", nil];
    
    [one setKey:@"wisecrack_1-hd"];
    [two setKey:@"wisecrack_2-hd"];
    [three setKey:@"wisecrack_3-hd"];
    [four setKey:@"wisecrack_4-hd"];
    [five setKey:@"wisecrack_5-hd"];
    
    [one setPoints:5000];
    [two setPoints:2000];
    [three setPoints:2000];
    [four setPoints:10000];
    [five setPoints:6000];

    NSArray * cracks = [NSArray arrayWithObjects:one, two, three, four, five, nil];
    
    for(Wisecrack * crack in cracks)
    {
        if ([crack isFullMatch:words])
            return crack;
    }

    return nil;
}

@end
