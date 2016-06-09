//
//  AppDelegate.h
//  WeatherTest
//
//  Created by melisadlg on 6/3/16.
//  Copyright © 2016 MelisaDlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    MMDrawerController *drawerController;
}

@property (nonatomic, retain) MMDrawerController *drawerController;
@property (strong, nonatomic) UIWindow *window;


@end

