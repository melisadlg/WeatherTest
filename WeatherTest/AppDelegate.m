//
//  AppDelegate.m
//  WeatherTest
//
//  Created by melisadlg on 6/3/16.
//  Copyright © 2016 MelisaDlg. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MMDrawerController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize drawerController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Setting up views for MMDrawerController library
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
    
    UIViewController *centerViewController = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    MenuViewController *menuViewController = (MenuViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    
    UINavigationController *leftSideNav = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    
    drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:centerNav
                                             leftDrawerViewController:leftSideNav];
                                             
    drawerController.maximumLeftDrawerWidth = 190.0; //This can be changed to any width desired
    
    //Setting to open the "drawer" with panning gesture anywhere on the screen
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView];
    
    [self.window setRootViewController:drawerController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
