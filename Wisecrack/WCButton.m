//
//  WCButton.m
//  Wisecrack
//
//  Created by Gareth Stokes on 30/03/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "WCButton.h"

@implementation WCButton
@synthesize selectedImage;

+ (WCButton *) button:(CCSprite *)image
{
    WCButton * b = [[[WCButton alloc] init] autorelease];
    [b addChild:image];
    [b setSelectedImage:image];
    
    return b;
}

-(id) initWithTarget:(id) rec selector:(SEL) cb
{
	if((self=[super init]) ) {
        
		anchorPoint_ = ccp(0.5f, 0.5f);
		NSMethodSignature * sig = nil;
		
		if( rec && cb ) {
			sig = [rec methodSignatureForSelector:cb];
			
			invocation_ = nil;
			invocation_ = [NSInvocation invocationWithMethodSignature:sig];
			[invocation_ setTarget:rec];
			[invocation_ setSelector:cb];
#if NS_BLOCKS_AVAILABLE
			if ([sig numberOfArguments] == 3) 
#endif
                [invocation_ setArgument:&self atIndex:2];
			
			[invocation_ retain];
		}
    }
	
	return self;
}


- (void) disappear
{
    [selectedImage runAction:[CCFadeOut actionWithDuration:0.5]];
}

- (void) appear
{
    [selectedImage runAction:[CCFadeIn actionWithDuration:0.5]];
}

@end
