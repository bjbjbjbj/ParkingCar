//
//  ParkingCarListViewController.m
//  ParkingCar
//
//  Created by xieweijie on 16/3/27.
//  Copyright © 2016年 xieweijie. All rights reserved.
//

#import "ParkingCarListViewController.h"
#import "CarTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
@interface ParkingCarListViewController ()<UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@property(nonatomic, strong)IBOutlet UITableView* carTable;
@property(nonatomic, strong)IBOutlet UITextField* lat;
@property(nonatomic, strong)IBOutlet UITextField* lon;
@property(nonatomic, strong)NSArray* carList;
@end

@implementation ParkingCarListViewController

- (void)dealloc
{
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#warning test  127.0.0.1:8000/parking/search/?search_area=40.0&lon=20.0&lat=12.0
//    [self loadDataWithLoc:20.0 withLat:12.0 withArea:40.0];
    [self setupGPS];
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

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_carList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"CareCell";
    CarTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CarTableViewCell" owner:nil options:nil][0];
    }
    if ([_carList count] > indexPath.row) {
        [cell loadData:[_carList objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - load data
- (void)loadDataWithLoc:(float)loc withLat:(float)lat withArea:(float)area
{
    NSDictionary* param = @{
                            @"search_area":[NSNumber numberWithFloat:area],
                            @"lon":[NSNumber numberWithFloat:loc],
                            @"lat":[NSNumber numberWithFloat:lat]
                            };
    __block typeof(self) wself = self;
    [[QiuMiHttpClient instance] GET:API_PARKING_SEARCH parameters:param cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        wself.carList = responseObject;
        [wself.carTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"api fail");
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"你死了" message:@"看标题" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles: nil];
        [alert show];
    }];
}

#pragma mark - click
- (IBAction)clickSearch:(id)sender
{
    if (_lat.text && [_lat.text length] > 0 &&
        _lon.text && [_lon.text length] > 0) {
        [self loadDataWithLoc:_lon.text.floatValue withLat:_lat.text.floatValue withArea:40.0];
    }
}

#pragma mark - gps
- (void)setupGPS
{
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
     [_locationManager requestAlwaysAuthorization];
    // 开始定位
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations && [locations count] > 0) {
        CLLocation* local = [locations objectAtIndex:0];
        [self loadDataWithLoc:local.coordinate.longitude withLat:local.coordinate.latitude withArea:40.0];
        [_locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}
@end
