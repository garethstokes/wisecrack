//
//  ScoreCalculator.m
//  Wisecrack
//
//  Created by Gareth Stokes on 12/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "ScoreCalculator.h"
#import "GameObjectCache.h"
#import "BonusManager.h"

@implementation ScoreCalculator

- (int) calculate:(NSArray *)words
{
    int score = 0;
    for (GameItem * word in words) {
        score += word.size.width * 10;
    }
    
    GameObjectCache * sharedCache = [GameObjectCache sharedGameObjectCache];
    BonusManager * bm = [sharedCache bonusManager];
    score *= [bm activeMultiplier];
    
    return score;
}

@end
