//
//  CarTableViewCell.h
//  ParkingCar
//
//  Created by xieweijie on 16/3/27.
//  Copyright © 2016年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* owner;
@property(nonatomic, strong)IBOutlet UILabel* address;
- (void)loadData:(NSDictionary*)dic;
@end
