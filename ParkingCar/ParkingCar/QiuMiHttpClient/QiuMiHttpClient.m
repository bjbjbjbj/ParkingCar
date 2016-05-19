//
//  QiuMiHttpClient.m
//  Qiumi
//
//  Created by xieweijie on 15/4/13.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiHttpClient.h"
@interface QiuMiHttpClient()
@property(nonatomic, strong)AFHTTPRequestOperationManager* manger;
@end
@implementation QiuMiHttpClient
+ (QiuMiHttpClient*)instance
{
    static QiuMiHttpClient* _current;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _current = [[QiuMiHttpClient alloc] init];
        _current.manger = [AFHTTPRequestOperationManager manager];
//        _current.manger.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [_current.manger.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
//        AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
//        [_current.manger setRequestSerializer:jsonRequestSerializer];
        /*
        _current.manger.responseSerializer = [AFJSONResponseSerializer new];
        _current.manger.requestSerializer = [AFJSONRequestSerializer new];
        _current.manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        [_current.manger.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
         */
        
        [_current.manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _current.manger.responseSerializer.acceptableContentTypes = [_current.manger.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    });
    return _current;
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
    success:(void (^)(AFHTTPRequestOperation *, id))success
    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self GET:URLString parameters:parameters cachePolicy:cachePolicy prompt:nil success:success failure:failure];
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
     prompt:(NSString *)prompt
    success:(void (^)(AFHTTPRequestOperation *, id))success
    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if (nil == prompt || 0 == prompt.length) {
        prompt = @"操作成功";
    }
    
    if (0 == [[parameters allKeys] count]) {
        parameters = nil;
    }
    NSMutableURLRequest *request = [self.manger.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.manger.baseURL] absoluteString] parameters:parameters error:nil];
    
    //先加缓存
    [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    NSCachedURLResponse* cache = [[NSURLCache sharedURLCache]cachedResponseForRequest:request];
    id respon = [self.manger.responseSerializer responseObjectForResponse:cache.response data:cache.data error:nil];
    
    [self.manger.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    //请求超时
    self.manger.requestSerializer.timeoutInterval = 30;
    switch (cachePolicy) {
        case QiuMiHttpClientCachePolicyNoCache:
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            break;
        case QiuMiHttpClientCachePolicyHttpFirst:
            break;
        case QiuMiHttpClientCachePolicyCacheFirst:
        {
            //先加缓存
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
            AFHTTPRequestOperation *operation = [self.manger HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([[operation response] statusCode] == 200 && [responseObject objectForKey:@"code"] && [responseObject integerForKey:@"code"] == 0) {
                    success(operation, responseObject);
                }
                else
                {
                    NSString *domain = @"com.QiuMi.ErrorDomain";
                    NSString *desc = NSLocalizedString(@"api 404 or not statuscode == 0", @"");
                    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
                    NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
                    failure(operation, error);
                    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
                }} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            [self.manger.operationQueue addOperation:operation];
        }
            break;
        case QiuMiHttpClientCachePolicyHttpCache:
        default:
        {
            if (respon) {
                success(nil, respon);
            }
        }
            break;
    }
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    AFHTTPRequestOperation *operation = [self.manger HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
//        if ([[operation response] statusCode] == 200 && [responseObject objectForKey:@"code"]) {
//            success(operation, responseObject);
//        }
//        else
//        {
//            NSString *domain = @"com.QiuMi.ErrorDomain";
//            NSString *desc = NSLocalizedString(@"api 404 or not statuscode == 0", @"");
//            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
//            NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
//            failure(operation, error);
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (nil != operation && nil != operation.response && [operation.response statusCode] == 304 && respon) {
                success(operation, respon);
            }
            else
            {
//#warning 如果failure为空会出现问题
                //这种情况会导致动画停在原处
                if (failure) {
                     failure(operation, error);
                }
            }
        }];
    
//    operation.securityPolicy.allowInvalidCertificates = YES;
    
    [self.manger.operationQueue addOperation:operation];
}

- (void)GET:(NSString *)URLString
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
{
    [self GET:URLString parameters:nil cachePolicy:cachePolicy success:success failure:nil];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters prompt:(NSString *)prompt success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if (nil == prompt || 0 == prompt.length) {
        prompt = @"操作成功";
    }
    AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
//    operation.securityPolicy.allowInvalidCertificates = YES;
    [operation POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self POST:URLString parameters:parameters prompt:nil success:success failure:failure];
}

- (void)cleanCache:(NSString *)url
{
    NSMutableURLRequest *request = [self.manger.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:url relativeToURL:self.manger.baseURL] absoluteString] parameters:nil error:nil];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
}
@end
