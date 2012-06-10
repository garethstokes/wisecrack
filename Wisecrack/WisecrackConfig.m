//
//  WisecrackConfig.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "WisecrackConfig.h"
#import "MessagePack.h"
#import "SettingsManager.h"

@implementation WisecrackConfig

@synthesize version;
@synthesize gameWords, gameColours;
@synthesize chanceBonus, chanceBrick;
@synthesize buttonLoadDelay, buttonLoadDuration;
@synthesize buttonRemoveDelay, buttonRemoveDuration;

- (id) init
{
    if ( [super init] != nil )
    {
        SettingsManager * sm = [SettingsManager sharedSettingsManager];
        
        [self setVersion:[sm getInt:@"config.version" withDefault:1]];
        
        [self setGameWords:[sm getInt:@"config.gameWords" withDefault:6]];
        [self setGameColours:[sm getInt:@"config.gameColours" withDefault:4]];
        
        [self setChanceBonus:[sm getInt:@"config.chanceBonus" withDefault:20]];
        [self setChanceBrick:[sm getInt:@"config.chanceBrick" withDefault:50]];
        
        [self setButtonLoadDelay:[sm getFloat:@"config.buttonLoadDelay" withDefault:2.0f]];
        [self setButtonLoadDuration:[sm getFloat:@"config.buttonLoadDuration" withDefault:0.5f]];
        
        [self setButtonRemoveDelay:[sm getFloat:@"config.buttonRemoveDelay" withDefault:2.0f]];
        [self setButtonRemoveDuration:[sm getFloat:@"config.buttonRemoveDuration" withDefault:0.5f]];
    }
    
    return self;
}

- (void) persist
{
    SettingsManager * sm = [SettingsManager sharedSettingsManager];
    
    [sm setValue:@"config.version" 
          newInt:version];
    
    [sm setValue:@"config.gameWords" 
          newInt:gameWords];
    
    [sm setValue:@"config.gameColours" 
          newInt:gameColours];

    [sm setValue:@"config.chanceBonus" 
          newInt:chanceBonus];
    
    [sm setValue:@"config.chanceBrick" 
          newInt:chanceBrick];
    
    [sm setValue:@"config.gameWords" 
          newInt:gameWords];
    
    [sm setValue:@"config.gameColours" 
          newInt:gameColours];
    
    [sm setValue:@"config.buttonLoadDelay" 
        newFloat:buttonLoadDelay];
    
    [sm setValue:@"config.buttonLoadDuration" 
        newFloat:buttonLoadDuration];
    
    [sm setValue:@"config.buttonRemoveDelay" 
        newFloat:buttonRemoveDelay];
    
    [sm setValue:@"config.buttonRemoveDuration" 
        newFloat:buttonRemoveDuration];
    
    [sm save];
}

- (void) update
{
    NSLog(@"UPDATING CONFIG");
    
    @synchronized(self)
    {
        NSURL * url = [NSURL URLWithString:@"http:/t.fallingshards.com:8008/wisecrack/config"];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection autorelease];
        
    }
}

- (void) parse:(NSData *)data
{
    NSDictionary * parsed = [data messagePackParse];
    NSLog(@"%@", [parsed description]);
    
    int v = [[parsed valueForKey:@"version"] intValue];
    if (v <= [self version]) return;
    
    self.version = v;
    self.gameWords = [[parsed valueForKey:@"gameWords"] intValue];
    self.gameColours = [[parsed valueForKey:@"gameColours"] intValue];
    
    self.chanceBonus = [[parsed valueForKey:@"chanceBonus"] intValue];
    self.chanceBrick = [[parsed valueForKey:@"chanceBrick"] intValue];
    
    self.buttonLoadDelay = [[parsed valueForKey:@"buttonLoadDelay"] floatValue];
    self.buttonLoadDuration = [[parsed valueForKey:@"buttonLoadDuration"] floatValue];
    
    self.buttonRemoveDelay = [[parsed valueForKey:@"buttonRemoveDelay"] floatValue];
    self.buttonRemoveDuration = [[parsed valueForKey:@"buttonRemoveDuration"] floatValue];
    
    // better save this shit so we wont need to load it from a network resource 
    // next time, yo.
    [self persist];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
    [self parse:data];
}

+ (WisecrackConfig *) config {
    static dispatch_once_t pred;
    static WisecrackConfig * shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WisecrackConfig alloc] init];
        [shared update];
    });
    return shared;
}

@end
