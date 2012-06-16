//
//  SettingsManager.m
//  greedy
//
//  Based on http://getsetgames.com/2009/10/07/saving-and-loading-user-data-and-preferences/
//

#import "SettingsManager.h"


@implementation SettingsManager

static SettingsManager* _sharedSettingsManager = nil;

-(NSString *)getString:(NSString*)value
{	
	return [settings objectForKey:value];
}

-(NSString *)getString:(NSString*)value withDefault:(NSString*)withDefault
{	
  NSString *storedString = [settings objectForKey:value];
  if (storedString != nil)
    return storedString;
  else
    return withDefault;
}

-(int)getInt:(NSString*)value {
	return [[settings objectForKey:value] intValue];
}

-(int)getInt:(NSString*)value withDefault:(int)withDefault{
  NSString *storedString = [settings objectForKey:value];
  if (storedString != nil)
    return [storedString intValue];
  else
    return withDefault;
}

-(float)getFloat:(NSString*)value {
	return [[settings objectForKey:value] floatValue];
}

-(float)getFloat:(NSString*)value withDefault:(float)withDefault{
    NSString *storedString = [settings objectForKey:value];
    if (storedString != nil)
        return [storedString floatValue];
    else
        return withDefault;
}

-(void)setValue:(NSString*)value newString:(NSString *)aValue {	
	[settings setObject:aValue forKey:value];
}

-(void)setValue:(NSString*)value newInt:(int)aValue {
	[settings setObject:[NSString stringWithFormat:@"%i",aValue] forKey:value];
}

-(void)setValue:(NSString*)value newFloat:(float)aValue {
	[settings setObject:[NSString stringWithFormat:@"%f",aValue] forKey:value];
}

-(void)save
{
	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"Wisecrack"];
	[[NSUserDefaults standardUserDefaults] synchronize];	
}

-(void)load
{
	[settings addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"Wisecrack"]];
}

-(void)logSettings
{
	for(NSString* item in settings)
	{
		NSLog(@"[SettingsManager KEY:%@ - VALUE:%@]", item, [settings valueForKey:item]);
	}
}

+(SettingsManager*)sharedSettingsManager
{
	@synchronized([SettingsManager class])
	{
		if (!_sharedSettingsManager)
			[[[self alloc] init] autorelease];
        
        [_sharedSettingsManager load];
        //[_sharedSettingsManager logSettings];
		return _sharedSettingsManager;
	}
  
	return nil;
}

+(id)alloc
{
	@synchronized([SettingsManager class])
	{
		NSAssert(_sharedSettingsManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedSettingsManager = [super alloc];
		return _sharedSettingsManager;
	}
  
	return nil;
}

-(id)autorelease {
  return self;
}

-(id)init {	
	settings = [[NSMutableDictionary alloc] initWithCapacity:5];	
	return [super init];
}

- (void)dealloc{
  [settings dealloc];
  [super dealloc];
}

@end
