//
//  MetricMonster.m
//  Wisecrack
//
//  Created by Gareth Stokes on 7/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "MetricMonster.h"
#import "MessagePack.h"

@implementation MetricMonster

@synthesize keys, monsterFilePath;

- (id) init
{
    if ( [super init] != nil )
    {
        [self setKeys:[NSMutableArray array]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        [self setMonsterFilePath:[libraryDirectory stringByAppendingPathComponent:@"MonsterInfo.plist"]];
    }
    
    return self;
}

- (void) queue:(NSString *)key
{
    @synchronized(self)
    {
        double ms = [[NSDate date] timeIntervalSince1970] * 1000.0;
        NSArray * item = [NSArray arrayWithObjects:key, [NSNumber numberWithDouble:ms], nil];
        [self.keys addObject:item];
    }
}

- (void) send
{
    NSLog(@"SENDING ANALYTICS");
    
    @synchronized(self)
    {
        if ([keys count] == 0) return;
        
        NSURL * url = [NSURL URLWithString:@"http://t.fallingshards.com:8008/wisecrack"];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[keys messagePack]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection autorelease];
        
        [keys removeAllObjects];
    }
}

- (void) startTimer
{
    if(_timer != nil){
        [_timer release];
        _timer = nil;
    }

    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] 
                                      interval:60 
                                        target:self 
                                      selector:@selector(send) 
                                      userInfo:nil 
                                       repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void) registerForNotifications
{
    // setup a bunch of details on load
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self monsterFilePath]];
    if(dict == nil){
        dict = [NSMutableDictionary dictionary];
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self 
               selector:@selector(applicationEnteredBackground:) 
                   name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [center addObserver:self 
               selector:@selector(applicationWillEnterForeground:) 
                   name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [center addObserver:self 
               selector:@selector(applicationWillTerminate:) 
                   name:UIApplicationWillTerminateNotification object:nil];
}

- (void) applicationEnteredBackground:(NSNotification*)notification
{
    [self queue:@"EnteringBackground"];
    [self send];
}

- (void) applicationWillEnterForeground:(NSNotification*)notification
{
    
}

- (void) applicationWillTerminate:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (MetricMonster *) monster {
    static dispatch_once_t pred;
    static MetricMonster * shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[MetricMonster alloc] init];
        [shared registerForNotifications];
        [shared startTimer];
    });
    return shared;
}

@end
