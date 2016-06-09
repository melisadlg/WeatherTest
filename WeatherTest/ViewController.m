//
//  ViewController.m
//  WeatherTest
//
//  Created by melisadlg on 6/3/16.
//  Copyright © 2016 MelisaDlg. All rights reserved.
//

#import "ViewController.h"
#import "NextDay.h"
#import "AppDelegate.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "MenuViewController.h"
#import "MBProgressHUD.h"

@interface ViewController (){
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *currentCity;
    NSString *currentCountry;
    
    NSMutableArray *daysForecast;
}

@property (strong, nonatomic) IBOutlet UILabel *cityLbl;
@property (strong, nonatomic) IBOutlet UILabel *countryLbl;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *currentTempLbl;
@property (strong, nonatomic) IBOutlet UILabel *currentDescLbl;
@property (strong, nonatomic) IBOutlet UILabel *feelsLbl;
@property (strong, nonatomic) IBOutlet UILabel *humidityLbl;
@property (strong, nonatomic) IBOutlet UILabel *maxLbl;
@property (strong, nonatomic) IBOutlet UILabel *minLbl;
@property (strong, nonatomic) IBOutlet UIScrollView *nextDaysScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *nextDaysPage;

@end

@implementation ViewController

int selectedLocation = 0;
int selectedCity = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    //[locationManager startUpdatingLocation];
    [self setupLeftMenuButton];
    
    _nextDaysScroll.delegate = self;
    _nextDaysScroll.pagingEnabled = YES;
    
    currentCity = @"The Hague";
    [self loadWeather:currentCity lblcountry:@"The Netherlands"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLoc:(id)sender {
    
    [[_nextDaysScroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [locationManager startUpdatingLocation];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Calculate page size and updating _nextDaysPage according to current _nextDaysScroll page
    CGFloat nextDaysWidth = _nextDaysScroll.frame.size.width;
    int pageScroll = floor((_nextDaysScroll.contentOffset.x - nextDaysWidth / 2) / nextDaysWidth) + 1;
    
    _nextDaysPage.currentPage = pageScroll;
    
}

#pragma mark - MMDrawerController

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:@"Failed to Get Your Location"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        //longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    [locationManager stopUpdatingLocation];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            currentCity = placemark.locality;
            currentCountry = placemark.country;
            [self loadWeather:currentCity lblcountry:currentCountry];
            // NSLog(@"Current City: %@",currentCity);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    
}

#pragma mark - Updating Labels

-(void)updateLabel1 {
    self.cityLbl.text = @"The Hague";
    
    currentCity = _cityLbl.text;
    [self loadWeather:@"The_Hague" lblcountry:@"The Netherlands"];
    
    //Stop using NSNotificacionCenter to alert a change in the selected city value
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"lblUpdate1"
                                                  object:nil];
}

-(void)updateLabel {
    self.cityLbl.text = @"Utrecht";
    currentCity = _cityLbl.text;
    
    [self loadWeather:@"Utrecht" lblcountry:@"The Netherlands"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"lblUpdate"
                                                  object:nil];
}

-(void)updateLabel2 {
    self.cityLbl.text = @"Amsterdam";
    currentCity = _cityLbl.text;
    
    [self loadWeather:@"Amsterdam" lblcountry:@"The Netherlands"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"lblUpdate2"
                                                  object:nil];
}

-(void)updateLabel3 {
    self.cityLbl.text = @"Rotterdam";
    currentCity = _cityLbl.text;
    
    [self loadWeather:@"Rotterdam" lblcountry:@"The Netherlands"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"lblUpdate3"
                                                  object:nil];
}

-(void)updateLabel4 {
    self.cityLbl.text = @"Monterrey";
    currentCity = _cityLbl.text;
    
    [self loadWeather:@"Monterrey" lblcountry:@"Mexico"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"lblUpdate4"
                                                  object:nil];
}

#pragma mark - Weather Info

- (void)loadWeather:(NSString *)city lblcountry:(NSString *)country {
    
    [[_nextDaysScroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)]; //remove elements inside _nextDaysScroll to avoid overlap
    
    //Start using NSNotificacionCenter to alert a change in the selected city value
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel1) name:@"lblUpdate1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:@"lblUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel2) name:@"lblUpdate2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel3) name:@"lblUpdate3" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel4) name:@"lblUpdate4" object:nil];
    
    _cityLbl.text = currentCity;
    _countryLbl.text = [country uppercaseString];
    
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@""];//eliminating any spaces for a valid search
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES]; //MBProgressHUD library used for user feedback while loading data
      
        NSString *urlAsString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/premium/v1/weather.ashx?key=adf54a194e5243b08cd113146160306&q=%@&format=json&num_of_days=6&includelocation=yes",city];
        
        [[_nextDaysScroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSURL *url = [NSURL URLWithString:urlAsString];
       
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:url
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if ([data length]>0 && error == nil) {
                        
                        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                        
                        @try {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    int xPos = 0;
                                    
                                    int dayViewWidth = (_nextDaysScroll.frame.size.width / 3) - 2;
                                    int dayViewHeight = _nextDaysScroll.frame.size.height;
                                    double alphaValue = 0.60;
                                    
                                    int iconSize = (dayViewWidth - 34);
                                    int iconXpos = (dayViewWidth - iconSize) / 2;
                                    
                                    daysForecast = [[NSMutableArray alloc]init];
                                    
                                    //Getting current weather conditions
                                    for (NSMutableDictionary *key in dictionary[@"data"][@"current_condition"]) {
                                        //Printing current weather conditions
                                        NSLog(@"Current Temp: %@ ˚C\nCurrent Feels Like: %@ ˚C",[[key objectForKey:@"temp_C"] description],[[key objectForKey:@"FeelsLikeC"] description]);
                                        
                                        //Arranging current weather conditions to update label outlets
                                        NSArray *descValue = [key objectForKey:@"weatherDesc"];
                                        NSString *weatherDesc =[[[descValue objectAtIndex:0]objectForKey:@"value"]description];
                                        
                                        _currentTempLbl.text = [NSString stringWithFormat:@"%@˚C",[[key objectForKey:@"temp_C"] description]];
                                        _feelsLbl.text = [NSString stringWithFormat:@"Feels Like: %@˚C",[[key objectForKey:@"FeelsLikeC"] description]];
                                        _currentDescLbl.text = weatherDesc;
                                        _humidityLbl.text = [NSString stringWithFormat:@"Humidity: %@%%",[[key objectForKey:@"humidity"] description]];
                                        
                                        //Setting current weather icon image
                                        NSString *string = weatherDesc;
                                        NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                                                                   [NSCharacterSet whitespaceCharacterSet]];
                                        
                                        NSString *imageName = [NSString stringWithFormat:@"%@.png",trimmedString];
                                        NSString *filePath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName];
                                        UIImage *image=[UIImage imageWithContentsOfFile:filePath];
                                        _iconImg.image = image;
                                        
                                    }
                                    
                                    //Getting forecast weather conditions
                                    for (NSMutableDictionary *key in dictionary[@"data"][@"weather"]) {
                                        
                                        //Arranging forecast weather conditions to update label outlets
                                        NSString *dateString = [[key objectForKey:@"date"] description];
                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                        NSDate *dateFromString = [[NSDate alloc] init];
                                        dateFromString = [dateFormatter dateFromString:dateString];
                                        
                                        NSDateFormatter *day = [[NSDateFormatter alloc] init];
                                        [day setDateFormat: @"EEEE"];
                                        NSString *dayString = [day stringFromDate:dateFromString];
                                        
                                        NSCalendar *cal = [NSCalendar currentCalendar];
                                        NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                                        NSDate *today = [cal dateFromComponents:components];
                                        components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:dateFromString];
                                        NSDate *otherDate = [cal dateFromComponents:components];
                                        
                                        NSArray *hour = [key objectForKey:@"hourly"];
                                        NSUInteger lenghtArray = [hour count]/2;
                                        NSArray *weatherHour = [[hour objectAtIndex:lenghtArray]objectForKey:@"weatherDesc"];
                                        NSString *hourDesc = [[weatherHour objectAtIndex:0]objectForKey:@"value"];
                                        
                                        
                                        if([today isEqualToDate:otherDate]) { //if date is today
                                            //Printing forecast for today
                                            NSLog(@"\nToday: %@\nMax: %@˚C\nMin: %@˚C",[[key objectForKey:@"date"] description],[[key objectForKey:@"maxtempC"] description],[[key objectForKey:@"mintempC"] description]);
                                            //Updating label outlets for today
                                            _maxLbl.text = [NSString stringWithFormat:@"Max: %@˚C",[[key objectForKey:@"maxtempC"] description]];
                                            _minLbl.text = [NSString stringWithFormat:@"Min: %@˚C",[[key objectForKey:@"mintempC"] description]];
                                            
                                        }
                                        else{ //if date is next days
                                            //Printing forecast for next days
                                            NSLog(@"\nDate: %@\nMax: %@˚C\nMin: %@˚C\nDesc:%@",dayString,[[key objectForKey:@"maxtempC"] description],[[key objectForKey:@"mintempC"] description],hourDesc);
                                            
                                            //Arranging and Updating label outlets for next days
                                            NextDay *day = [[NextDay alloc]init];
                                            day.dayOfWeek = dayString;
                                            day.dayMaxTemp = [[key objectForKey:@"maxtempC"] description];
                                            day.dayMinTemp = [[key objectForKey:@"mintempC"] description];
                                            
                                            [daysForecast addObject:day];
                                            
                                            UIView *dayView = [[UIView alloc]init]; //each day has a view inside _nextDaysScroll
                                            [dayView setFrame:CGRectMake(xPos, 0, dayViewWidth, dayViewHeight)];
                                            [dayView setBackgroundColor:[UIColor colorWithRed:(128/255.0) green:(0/255.0) blue:(64/255.0) alpha:alphaValue]];
                                            
                                            UILabel *dayOfWeek = [[UILabel alloc]init];
                                            [dayOfWeek setFrame:CGRectMake(0, 10, dayViewWidth, 20)];
                                            [dayOfWeek setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0]];
                                            [dayOfWeek setTextColor:[UIColor whiteColor]];
                                            [dayOfWeek setTextAlignment:NSTextAlignmentCenter];
                                            [dayOfWeek setText:dayString];
                                            
                                            UILabel *dayMax = [[UILabel alloc]init];
                                            [dayMax setFrame:CGRectMake(0, dayViewHeight-52, dayViewWidth, 20)];
                                            [dayMax setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0]];
                                            [dayMax setTextColor:[UIColor whiteColor]];
                                            [dayMax setTextAlignment:NSTextAlignmentCenter];
                                            [dayMax setText:[NSString stringWithFormat:@"Max: %@˚C",day.dayMaxTemp]];
                                            
                                            UILabel *dayMin = [[UILabel alloc]init];
                                            [dayMin setFrame:CGRectMake(0, dayViewHeight-30, dayViewWidth, 20)];
                                            [dayMin setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0]];
                                            [dayMin setTextColor:[UIColor whiteColor]];
                                            [dayMin setTextAlignment:NSTextAlignmentCenter];
                                            [dayMin setText:[NSString stringWithFormat:@"Min: %@˚C",day.dayMinTemp]];
                                            
                                            NSString *string = hourDesc;
                                            NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                                                                       [NSCharacterSet whitespaceCharacterSet]];
                                            
                                            NSString *imageName = [NSString stringWithFormat:@"%@.png",trimmedString];
                                            NSString *filePath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName];
                                            UIImage *image=[UIImage imageWithContentsOfFile:filePath];
                                            
                                            UIImageView *dayIcon = [[UIImageView alloc]init];
                                            [dayIcon setFrame:CGRectMake(iconXpos, 35, iconSize, iconSize)];
                                            [dayIcon setImage:image];
                                            
                                            [dayView addSubview:dayOfWeek];
                                            [dayView addSubview:dayMax];
                                            [dayView addSubview:dayMin];
                                            [dayView addSubview:dayIcon];
                                            
                                            //Adding every day-view to _nextDaysScroll with a transition
                                            [UIView transitionWithView:_nextDaysScroll
                                                              duration:0.5
                                                               options:UIViewAnimationOptionTransitionFlipFromTop //any animation
                                                            animations:^ {
                                                                [_nextDaysScroll addSubview:dayView];
                                                            }
                                                            completion:^(BOOL finished){
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                            }];
                                            
                                            [_nextDaysScroll setContentSize:CGSizeMake(xPos + dayViewWidth, _nextDaysScroll.frame.size.height)];
                                            
                                            alphaValue = alphaValue - 0.10; //changing the background alpha value so each day appears in a different color
                                            xPos = xPos + dayViewWidth + 2; //changing the position-X for the next day-view
                                        }
                                    }
                                });
                            });
                            
                        }
                        @catch (NSException *exception) {
                            NSLog(@"Exception %@",exception.description);
                        }
                        @finally { }
                    }
                    
                }] resume];
    });
    
    
}

@end
