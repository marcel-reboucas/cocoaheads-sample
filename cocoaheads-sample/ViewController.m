//
//  ViewController.m
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/23/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"

@interface ViewController ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *emailLabel;

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
}

@end
