//
//  TutorialScene.m
//  Wisecrack
//
//  Created by Gareth Stokes on 23/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "TutorialScene.h"
#import "TutorialLayer.h"

@implementation TutorialScene

+ (CCScene *) create
{
    TutorialScene * scene = [[[TutorialScene alloc] init] autorelease];
    TutorialLayer * ui = [[[TutorialLayer alloc] init] autorelease];
    [scene addChild:ui];
    
    return scene;
}

@end
