//
//  TrueFriendsGame.h
//  Wisecrack
//
//  Created by Gareth Stokes on 15/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseGame.h"

@interface TrueFriendsGame : BaseGame {
    NSMutableArray * sw;
    NSMutableArray * mw;
    NSMutableArray * lw;
}

- (void) balanceTo:(int)count;

@end
