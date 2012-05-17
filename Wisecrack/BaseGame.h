//
//  BaseGame.h
//  Wisecrack
//
//  Created by Gareth Stokes on 15/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"
#import "GameItem.h"

@interface BaseGame : NSObject {
    NSMutableArray *wordsInPlay;
    int numberOfWords;
    int wisecrackLength;
}

@property (nonatomic, retain) NSMutableArray* wordsInPlay;

- (void) shuffle;
- (void) shuffle:(NSMutableArray *)w;

- (GameItem *)pickWordAtRandom;

@end
