//
//  QiuMiHttpClient.h
//  Qiumi
//
//  Created by xieweijie on 15/4/13.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
//异步请求网络缓存协议
typedef NS_ENUM(NSInteger, QiuMiHttpClientCachePolicy)
{
    //所有请求都会保存缓存
    //不使用缓存，网络异常时，返回空值
    QiuMiHttpClientCachePolicyNoCache     = 0,
    
    //有网络时返回网络，网络异常返回缓存数据
    QiuMiHttpClientCachePolicyHttpFirst   = 1,
    
    //先返回一次缓存，然后请求网络，有数据时返回，无数据时返回为空,  同步请求，如果有缓存则不刷新数据
    QiuMiHttpClientCachePolicyHttpCache   = 2,
    
    //有缓存时直接使用缓存并且不刷新，无缓存时请求网络,  同步请求与PCHttpClientCachePolicyCacheFirst一致
    QiuMiHttpClientCachePolicyCacheFirst  = 3,
};

@interface QiuMiHttpClient : NSObject
/**
 * @brief 请求单例
 */
+ (QiuMiHttpClient*)instance;

/**
 * @brief get请求，含参数
 * @param URLString 请求链接
 * @param parameters 请求参数
 * @param cachePolicy 缓存协议
 * @param success 请求成功block
 * @param failure 请求失败block
 */
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * @brief get请求，含参数
 * @param URLString 请求链接
 * @param parameters 请求参数
 * @param prompt 请求成功默认提示
 * @param cachePolicy 缓存协议
 * @param success 请求成功block
 * @param failure 请求失败block
 */
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
     prompt:(NSString*) prompt
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * @brief get请求，不含参数
 * @param URLString 请求链接
 * @param cachePolicy 缓存协议
 * @param success 请求成功block
 * @param failure 请求失败block
 */
- (void)GET:(NSString *)URLString
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

/**
 * @brief post请求，含参数
 * @param URLString 请求链接
 * @param parameters 请求参数
 * @param success 请求成功block
 * @param failure 请求失败block
 */
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * @brief post请求，含参数
 * @param URLString 请求链接
 * @param parameters 请求参数
 * @param prompt 请求成功默认提示
 * @param success 请求成功block
 * @param failure 请求失败block
 */
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
      prompt:(NSString*) prompt
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)cleanCache:(NSString*)url;
@end
