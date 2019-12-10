//
//  STDPingManager.m
//

#import "STDPingManager.h"

@implementation STDPingManager


- (instancetype)initWith:(NSArray *)IPList andWithCount:(int)count withFastIP:(FastIPBlock)fastcallback
{
    self = [super init];
    if (self) {
        self.IPList = [IPList copy];
        self.fastIP = fastcallback;
        self.count = count;
        self.dic = [NSMutableDictionary new];
    }
    return self;
}

+ (void)getFastIPwith:(NSArray *)IPList andWithCount:(int)count withFastIP:(FastIPBlock)fastcallback{
    STDPingManager * manager = [[STDPingManager alloc]initWith:IPList andWithCount:count withFastIP:fastcallback];
    [manager start];
}

- (void)start{
    dispatch_group_t group = dispatch_group_create();
    NSMutableDictionary * avgPing = [NSMutableDictionary new];
    NSMutableArray * failArray = [NSMutableArray new];
    NSMutableArray * unexpectedArray = [NSMutableArray new];
//    NSMutableArray * timeoutArray = [NSMutableArray new];
    NSMutableArray * errorArray = [NSMutableArray new];
    for (NSString * address in self.IPList) {
        dispatch_group_enter(group);
        __block double pingSum = 0;
        STDPingServices * service = [STDPingServices startPingAddress:address withCount:self.count callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
                switch (pingItem.status) {
                    case STDPingStatusDidStart:
                        //发送包
                        SSLog(@"---> Just 发送包%@",pingItem.IPAddress);
                        break;
                    case STDPingStatusDidFailToSendPacket:
                        //发送包失败
                        [failArray addObject:address];
                        break;
                    case STDPingStatusDidReceivePacket:
                        //正常接收
//                        NSLog(@"%@---%f",address,pingItem.timeMilliseconds);
//                        SSLog(@"---> AAAAAA正常%@",pingItem.IPAddress);
                        pingSum += pingItem.timeMilliseconds;
                        break;
                    case STDPingStatusDidReceiveUnexpectedPacket:
                        //收到不正常的包
                        [unexpectedArray addObject:address];
                        break;
                    case STDPingStatusDidTimeout:
                        //超时---> 超时就不用移除了吧
//                        [timeoutArray addObject:address];
                        break;
                    case STDPingStatusError:
                        //错误
                        [errorArray addObject:address];
                        break;
                    case STDPingStatusFinished:
                        //完成
                        SSLog(@"---> Just 结束%@",pingItem.IPAddress);
                        //Add 耗时为0的,说明有问题吧, 不添加进去
                        if(pingSum>0){
                            [avgPing setValue:[NSString stringWithFormat:@"%f",pingSum/self.count] forKey:address];
                        }
                        dispatch_group_leave(group);
                        break;
                    default:
                        break;
                }
            }];
        [self.dic setValue:service forKey:address];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSMutableArray * list  = [NSMutableArray arrayWithArray:[avgPing allKeys]];
        if (failArray.count > 0) {
            for (NSString * fail in failArray) {
                if ([list containsObject:fail]) {
                  [list removeObject:fail];
                }
            }
        }
        
        NSMutableString * fastIP;
           if (list.count == 0) {
               fastIP = [NSMutableString stringWithString:@""];
           }else if(list.count == 1){
               fastIP = [list firstObject];
           }else{
               fastIP = [list firstObject];
               for (int i = 0; i < list.count-1 ;i++) {
                   
                   double ping = [avgPing[list[i]] doubleValue];
                   double nextping = [avgPing[list[i+1]] doubleValue];
                   if (ping > nextping) {
                       fastIP = list[i+1];
                   }
               }
           }
           self.fastIP(fastIP);
           //所有正常的ip
           NSLog(@"所有正常的ip:%@",avgPing);
        
//Old_Version
//
//        NSMutableArray * list  = [NSMutableArray arrayWithArray:self.IPList];
//        if (failArray.count > 0) {
//            for (NSString * fail in failArray) {
//                if ([list containsObject:fail]) {
//                  [list removeObject:fail];
//                }
//            }
//        }
//
//        //这里有问题, 正常的ip也会有unexpected的时候, 不能根据这个来移除
//        /*
//         根据 耗时来移除吧 耗时为0的移除 ---> 上面处理 case STDPingStatusFinished:
//
//         log:
//         所有正常的ip:{
//             "120.77.243.186" = "13.441896";
//             "120.77.243.187" = "0.000000";
//             "120.77.243.188" = "65.959811";
//         }
//         */
//
//        if (unexpectedArray.count > 0) {
//            for (NSString * unexpect in unexpectedArray) {
//                if ([list containsObject:unexpect]) {
//                    [list removeObject:unexpect];
//                }
//            }
//        }
//
//        if (timeoutArray.count > 0) {
//            for (NSString * timeout in timeoutArray) {
//                if ([list containsObject:timeout]) {
//                    [list removeObject:timeout];
//                }
//            }
//        }
//
//        if (errorArray.count > 0) {
//            for (NSString * error in errorArray) {
//                if ([list containsObject:error]) {
//                    [list removeObject:error];
//                }
//            }
//        }
//
//        NSMutableString * fastIP;
//        if (list.count == 0) {
//            fastIP = [NSMutableString stringWithString:@""];
//        }else if(list.count == 1){
//            fastIP = [list firstObject];
//        }else{
//            fastIP = [list firstObject];
//            for (int i = 0; i < list.count-1 ;i++) {
//
//                double ping = [avgPing[list[i]] doubleValue];
//                double nextping = [avgPing[list[i+1]] doubleValue];
//                if (ping > nextping) {
//                    fastIP = list[i+1];
//                }
//            }
//        }
//        self.fastIP(fastIP);
//        //所有正常的ip
//        NSLog(@"所有正常的ip:%@",avgPing);
    });
}
@end
