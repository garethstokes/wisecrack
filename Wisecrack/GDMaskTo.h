//
//  GDMaskTo.h
//  Wisecrack
//
//  Created by Gareth Stokes on 24/05/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GDMaskTo : CCActionInterval <NSCopying>
{
	CGRect endRect;
	CGRect startRect;
	CGRect delta;
}

+(id) actionWithDuration:(ccTime)duration rect:(CGRect)rect;
-(id) initWithDuration:(ccTime)duration rect:(CGRect)rect;

@end