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

@synthesize version, order;
@synthesize gameWords, gameColours, waveLength;
@synthesize bonusRespawn, chanceBonus, chanceBrick;
@synthesize buttonLoadDelay, buttonLoadDuration;
@synthesize buttonRemoveDelay, buttonRemoveDuration;

- (id) init:(int)o
{
    if ( [super init] != nil )
    {
        [self setOrder:o];
        
        SettingsManager * sm = [SettingsManager sharedSettingsManager];
        
        NSString * key = [NSString stringWithFormat:@"config_%d.version", order];
        [self setVersion:[sm getInt:key withDefault:-1]];
        
        key = [NSString stringWithFormat:@"config_%d.waveLength", order];
        [self setWaveLength:[sm getInt:key withDefault:30]];
        
        key = [NSString stringWithFormat:@"config_%d.gameWords", order];
        [self setGameWords:[sm getInt:key withDefault:6]];
        
        key = [NSString stringWithFormat:@"config_%d.gameColours", order];
        [self setGameColours:[sm getInt:key withDefault:4]];
        
        key = [NSString stringWithFormat:@"config_%d.bonusRespawn", order];
        [self setBonusRespawn:[sm getInt:key withDefault:30]];
        
        key = [NSString stringWithFormat:@"config_%d.chaneBonus", order];
        [self setChanceBonus:[sm getInt:key withDefault:20]];
        
        key = [NSString stringWithFormat:@"config_%d.chanceBrick", order];
        [self setChanceBrick:[sm getInt:key withDefault:50]];
        
        key = [NSString stringWithFormat:@"config_%d.buttonLoadDelay", order];
        [self setButtonLoadDelay:[sm getFloat:key withDefault:2.0f]];
        
        key = [NSString stringWithFormat:@"config_%d.buttonLoadDuration", order];
        [self setButtonLoadDuration:[sm getFloat:key withDefault:0.5f]];
        
        key = [NSString stringWithFormat:@"config_%d.buttonRemoveDelay", order];
        [self setButtonRemoveDelay:[sm getFloat:key withDefault:2.0f]];
        
        key = [NSString stringWithFormat:@"config_%d.buttonRemoveDuration", order];
        [self setButtonRemoveDuration:[sm getFloat:key withDefault:0.5f]];
    }
    
    return self;
}

- (void) persist
{
    SettingsManager * sm = [SettingsManager sharedSettingsManager];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.version", order]
          newInt:version];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.waveLength", order] 
          newInt:waveLength];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.gameWords", order] 
          newInt:gameWords];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.gameColours", order] 
          newInt:gameColours];

    [sm setValue:[NSString stringWithFormat:@"config_%d.bonusRespawn", order] 
          newInt:bonusRespawn];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.chanceBonus", order] 
          newInt:chanceBonus];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.chanceBrick", order] 
          newInt:chanceBrick];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.gameWords", order] 
          newInt:gameWords];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.gameColours", order] 
          newInt:gameColours];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.buttonLoadDelay", order] 
        newFloat:buttonLoadDelay];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.buttonLoadDuration", order] 
        newFloat:buttonLoadDuration];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.buttonRemoveDelay", order] 
        newFloat:buttonRemoveDelay];
    
    [sm setValue:[NSString stringWithFormat:@"config_%d.buttonRemoveDuration" , order]
        newFloat:buttonRemoveDuration];
    
    [sm save];
}

- (void) parse:(NSDictionary *)parsed
{
    //NSLog(@"%@", [parsed description]);
    
    int v = [[parsed valueForKey:@"version"] intValue];
    if (v <= [self version]) return;
    
    self.version = v;
    self.waveLength = [[parsed valueForKey:@"waveLength"] intValue];
    self.gameWords = [[parsed valueForKey:@"gameWords"] intValue];
    self.gameColours = [[parsed valueForKey:@"gameColours"] intValue];
    
    self.bonusRespawn = [[parsed valueForKey:@"bonusRespawn"] intValue];
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

+ (WisecrackConfig *) config {
    return [[WisecrackConfigSet configSet] current];
}

@end

@implementation WisecrackConfigSet
@synthesize wave, version;
@synthesize one, two, three;

- (id) init
{
    if ( [super init] != nil )
    {
        [self setVersion:-1];
        [self setWave:1];
        
        [self setOne:[[[WisecrackConfig alloc] init:1] autorelease]];
        [self setTwo:[[[WisecrackConfig alloc] init:2] autorelease]];
        [self setThree:[[[WisecrackConfig alloc] init:3] autorelease]];
        
        version = [one version] + [two version] + [three version];
    }
    
    return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
    NSArray * parsedArray = [data messagePackParse];
    if ( [[[parsedArray objectAtIndex:0] valueForKey:@"version"] intValue] == -1) return;
    
    [one parse:[parsedArray objectAtIndex:0]];
    [two parse:[parsedArray objectAtIndex:1]];
    [three parse:[parsedArray objectAtIndex:2]];
    
    version = [one version] + [two version] + [three version];
}

- (void) updateFromServer
{
    NSLog(@"UPDATING CONFIG");
    
    @synchronized(self)
    {
        //NSURL * url = [NSURL URLWithString:@"http:/t.fallingshards.com:8008/wisecrack/config"];
        NSString * surl = [NSString stringWithFormat:@"http://t.fallingshards.com/config/%d", version];
        NSURL * url = [NSURL URLWithString:surl];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection autorelease];
    }
}

- (WisecrackConfig *) current
{
    if (wave == 1) return one;
    if (wave == 2) return two;
    return three;
}

- (void) incrementWave
{
    if (wave > 10) return;
    wave++;
}

- (void) resetWave
{
    wave = 1;
}

- (void) dealloc
{
    [one release];
    [two release];
    [three release];
    [super dealloc];
}

+ (WisecrackConfigSet *) configSet {
    static dispatch_once_t pred;
    static WisecrackConfigSet * shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WisecrackConfigSet alloc] init];
        [shared updateFromServer];
    });
    return shared;
}

@end
