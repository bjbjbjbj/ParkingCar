//
//  ParkingUserCreateViewController.m
//  ParkingCar
//
//  Created by xieweijie on 16/3/28.
//  Copyright © 2016年 xieweijie. All rights reserved.
//

#import "ParkingUserCreateViewController.h"
#import <CommonCrypto/CommonDigest.h>
/*
 Username
 Required. 30 characters or fewer. Letters, digits and @/./+/-/_ only.
 Password
 First name
 Last name
 Email address
 
 User profile
 Evaluation
 EvalNum
 */
@interface ParkingUserCreateViewController ()
@property(nonatomic, strong)IBOutlet UITextField* username;
@property(nonatomic, strong)IBOutlet UITextField* password;
@property(nonatomic, strong)IBOutlet UITextField* firstName;
@property(nonatomic, strong)IBOutlet UITextField* lastName;
@property(nonatomic, strong)IBOutlet UITextField* email;
@property(nonatomic, strong)IBOutlet UITextField* userProfile;
@property(nonatomic, strong)IBOutlet UITextField* evaluation;
@property(nonatomic, strong)IBOutlet UITextField* evalNum;
@end

@implementation ParkingUserCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - click
- (IBAction)clickRegister:(id)sender
{
    NSDictionary* dic = @{
                          
                          };
    
    NSString* password = _password.text;//[ParkingUserCreateViewController md5:_password.text];
    NSDictionary* param = @{
                            @"username":_username.text,
                            @"password":password,
                            @"user_profile.evaluation":@"0",
                            @"user_profile.evalNum":@"0",
                            @"user_profile.user":_username.text
                            };
    [[QiuMiHttpClient instance]POST:API_USER_CREATE parameters:param prompt:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = responseObject;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"信息" message:[NSString stringWithFormat:@"%@",dic] delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles: nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"死了" message:@"看标题" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles: nil];
        [alert show];
    }];
}

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
