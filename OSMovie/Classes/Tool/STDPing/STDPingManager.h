//
//  STDPingManager.h
//  Lock
//
//  Created by Jerry on 2019/1/7.
//  Copyright © 2019 周玉举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDPingServices.h"

typedef void(^FastIPBlock)(NSString * ipAddress);

@interface STDPingManager : NSObject

@property (nonatomic,strong)NSMutableDictionary * dic;

@property (nonatomic,copy)FastIPBlock fastIP;

@property (nonatomic,assign)int count;

@property (nonatomic,strong)NSArray * IPList;


+ (void)getFastIPwith:(NSArray *)IPList andWithCount:(int)count withFastIP:(FastIPBlock)fastcallback;

@end

