//
//  MenuViewController.m
//  WeatherTest
//
//  Created by melisadlg on 6/7/16.
//  Copyright © 2016 MelisaDlg. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"
#import "UIViewController+MMDrawerController.h"


@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize city;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"Available Cities"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectCity:(UIButton *)sender {
    
    if (sender.tag == 1) {
        city = @"The Hague";
        
        //Start using NSNotificacionCenter to alert a change in the selected city value
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lblUpdate1" object:nil];
    }
    else if (sender.tag == 2) {
        city = @"Utrecht";
        
        //Start using NSNotificacionCenter to alert a change in the selected city value
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lblUpdate" object:nil];
    }
    else if (sender.tag == 3) {
        city = @"Amsterdam";
        
        //Start using NSNotificacionCenter to alert a change in the selected city value
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lblUpdate2" object:nil];
    }
    else if (sender.tag == 4) {
        city = @"Rotterdam";
        
        //Start using NSNotificacionCenter to alert a change in the selected city value
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lblUpdate3" object:nil];
    }
    else if (sender.tag == 5) {
        city = @"Monterrey";
        
        //Start using NSNotificacionCenter to alert a change in the selected city value
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lblUpdate4" object:nil];
    }
    
    //Close MMDrawer once a city has been selected
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
