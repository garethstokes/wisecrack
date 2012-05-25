//
//  BonusManager.m
//  Wisecrack
//
//  Created by Gareth Stokes on 25/05/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "BonusManager.h"

@implementation Bonus

+ (Bonus *) shake:(NSString *)colour
{
    Bonus * b = [[[Bonus alloc] init] autorelease];
    [b setName:@"shake"];
    [b setColour:colour];
    return b;
}

+ (Bonus *) swipe:(NSString *)colour
{
    Bonus * b = [[[Bonus alloc] init] autorelease];
    [b setName:@"swipe"];
    [b setColour:colour];
    return b;
}

+ (Bonus *) multiplier:(NSString *)colour
{
    Bonus * b = [[[Bonus alloc] init] autorelease];
    [b setName:@"multiplier"];
    [b setColour:colour];
    return b;
}

+ (Bonus *) chain
{
    Bonus * b = [[[Bonus alloc] init] autorelease];
    [b setName:@"chain"];
    [b setColour:@"double rainbow"];
    return b;
}

@end

@implementation BonusManager

@end
