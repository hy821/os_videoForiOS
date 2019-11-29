//
//  ABSRequest.h
//  Osss
//
//  Created by Lff_OsDeveloper on 2017/3/29.
//  Copyright © 2017年    asdfghjkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define RequestStateCode ([response[@"code"] integerValue])
static NSInteger const completionCode = 10000;

@class ABSRequest;
@protocol ABSRequestDelegate <NSObject>

- (void)ABSRequest:(ABSRequest *)request finished:(NSDictionary *)response;
- (void)ABSRequest:(ABSRequest *)request Error:(NSString *)error;

@end

typedef NS_ENUM(NSUInteger, NetType) {
     GET = 0,//get
     POST = 1,//post
};

typedef NS_ENUM(NSUInteger, SSRefreshType) {
    NoneRefreshType = 0,
    SSHeaderRefreshType = 1,
    SSFooterRefreshType = 2,
    SSDoubleRefreshType = 3,
};

@class BaseModel;

@interface ABSRequest : NSObject
@property (nonatomic,weak) id<ABSRequestDelegate> delegate;
/**
 *[AFNetWorking]的operationManager对象
 */
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
/**
 *当前的请求operation队列
 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;
/**
 *功能: 创建ABSRequest的对象方法
 */
+ (instancetype)request;

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(ABSRequest *request, NSDictionary *response))success
    failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure;

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(ABSRequest *request, id response))success
     failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure;

- (void)cancelAllOperations;

-(NSDictionary * )getPublicDic:(NSDictionary*)apiDic;

- (void)getNetWorkAddWithUrl:(NSString*)requestUrl success:(void (^)(ABSRequest *request, id response))success failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure;

- (void)getAdvDataWithUrl:(NSString*)requestUrl positionID:(NSString*)positionID success:(void (^)(ABSRequest *request, id response))success
failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure;

//广告反馈用的GET请求
- (void)AdvReportGET:(NSString *)URLString success:(void (^)(ABSRequest *request, NSDictionary *response))success failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure;

@end


@interface BaseModel:NSObject
@property (nonatomic,assign) BOOL succeed;
@property (nonatomic,assign) NSInteger errCode;
@property (nonatomic,strong) id  data;
@property (nonatomic,copy) NSString * errMsg;
@end
