//
//  MetricMonster.h
//  Wisecrack
//
//  Created by Gareth Stokes on 7/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetricMonster : NSObject {
    NSTimer * _timer;
}

@property (atomic, retain) NSMutableArray * keys;
@property (nonatomic, copy) NSString *monsterFilePath;

- (void) queue:(NSString *)key;
- (void) send;
+ (MetricMonster *) monster;


@end
