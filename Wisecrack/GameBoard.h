//
//  GameBoard.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"

@interface GameBoard : NSObject {
    CGSize size;
    NSString* name;
    
    NSMutableArray* rows; 
    NSMutableArray* columns; 
}

@property (nonatomic) CGSize size;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSMutableArray* rows;
@property (nonatomic, retain) NSMutableArray* columns;

@end
