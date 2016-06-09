//
//  ViewController.h
//  WeatherTest
//
//  Created by melisadlg on 6/3/16.
//  Copyright © 2016 MelisaDlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NextDay.h"
#import "MMDrawerController.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, UIScrollViewDelegate>

- (void) loadWeather:(NSString *)city lblcountry:(NSString *)country;

@end

