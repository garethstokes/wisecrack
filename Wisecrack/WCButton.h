//
//  WCButton.h
//  Wisecrack
//
//  Created by Gareth Stokes on 30/03/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"

@interface WCButton : CCLayer {
    NSInvocation *invocation_;
}

@property (nonatomic, retain) CCSprite* selectedImage;

+ (WCButton *) button:(CCSprite *)image;

- (id) initWithTarget:(id) rec selector:(SEL) cb;
- (void) disappear;
- (void) appear;

@end
