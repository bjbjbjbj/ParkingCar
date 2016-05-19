//
//  CarTableViewCell.m
//  ParkingCar
//
//  Created by xieweijie on 16/3/27.
//  Copyright © 2016年 xieweijie. All rights reserved.
//

#import "CarTableViewCell.h"

@implementation CarTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(NSDictionary *)dic
{
    [_owner setText:[dic objectForKey:@"owner"]];
    [_address setText:[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"city"], [dic objectForKey:@"street"]]];
}
@end
