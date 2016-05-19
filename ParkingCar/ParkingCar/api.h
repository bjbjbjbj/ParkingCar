//
//  Header.h
//  ParkingCar
//
//  Created by xieweijie on 16/3/27.
//  Copyright © 2016年 xieweijie. All rights reserved.
//

#ifndef Header_h
#define Header_h
#define PREFIX @"http://localhost:8000"
/*
 127.0.0.1:8000/parking/
 127.0.0.1:8000/carinfo/
 127.0.0.1:8000/users/create/
 127.0.0.1:8000/parking/search/?search_area=40.0&lon=20.0&lat=12.0
 127.0.0.1:8000/api-auth/login/
 127.0.0.1:8000/api-auth/logout/*/
#define API_PARKING [PREFIX stringByAppendingString:@"/parking/"]
#define API_CAREINFO [PREFIX stringByAppendingString:@"/carinfo/"]
#define API_USER_CREATE [PREFIX stringByAppendingString:@"/users/create/"]
#define API_PARKING_SEARCH [PREFIX stringByAppendingString:@"/parking/search/"]
#define API_LOGIN [PREFIX stringByAppendingString:@"/api-auth/login/"]
#define API_LOGOUT [PREFIX stringByAppendingString:@"/api-auth/logout/"]

#endif /* Header_h */
