//
//  AppDelegate.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright digital five 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController * viewController;

@end
