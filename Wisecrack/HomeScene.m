//
//  HomeScene.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/03/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "HomeScene.h"
#import "HomeLayer.h"

#import "ScoreCard.h"

@implementation HomeScene

+ (CCScene *) create
{
    HomeScene* scene = [[[HomeScene alloc] init] autorelease];
    HomeLayer* ui = [[[HomeLayer alloc] init] autorelease];
    
//    ScoreCard * ui = [[[ScoreCard alloc] init] autorelease];
    
    [scene addChild:ui];
    
    return scene;
}

@end
