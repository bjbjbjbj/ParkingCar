//
//  ViewController.m
//  ParkingCar
//
//  Created by xieweijie on 16/3/25.
//  Copyright © 2016年 xieweijie. All rights reserved.
//

#import "ViewController.h"
#import "ParkingUserCreateViewController.h"
@interface ViewController ()
@property(nonatomic, strong)IBOutlet UITextField* username;
@property(nonatomic, strong)IBOutlet UITextField* password;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - click
- (IBAction)login:(id)sender
{
    NSString* password = [ParkingUserCreateViewController md5:_password.text];
    NSDictionary* param = @{
                            @"username":_username.text,
                            @"password":password,
                            };
    [[QiuMiHttpClient instance]POST:API_LOGIN parameters:param prompt:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* controllercontroller = [sb instantiateViewControllerWithIdentifier:@"ParkingCarListViewController"];
        [self.navigationController pushViewController:controllercontroller animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
