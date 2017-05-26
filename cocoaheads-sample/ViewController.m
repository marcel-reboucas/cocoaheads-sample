//
//  ViewController.m
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/23/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import "ViewController.h"
#import "ThreadWait.h"

@interface ViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *emailLabel;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) ThreadWait *waiter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
    self.emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, 20)];
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.emailLabel];
    
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    self.emailLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
    [self.manager requestAlwaysAuthorization];
    self.manager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        self.lastLocation = locations.firstObject;
    }
    if (self.waiter != nil){
        [self.waiter stopWait];
    }
}

- (void)requestLocationUpdateAsync:(LocationBlock)completionBlock
{
    // É feio e eu sei, mas é só um exemplo :P
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.waiter = [[ThreadWait alloc] init];
        [self.manager requestLocation];
        [self.waiter wait];
        self.waiter = nil;
        completionBlock(self.lastLocation);
    });
}

- (CLLocation *)requestLocationUpdateSync
{
    self.waiter = [[ThreadWait alloc] init];
    [self.manager requestLocation];
    [self.waiter wait];
    self.waiter = nil;
    return self.lastLocation;
}


@end
