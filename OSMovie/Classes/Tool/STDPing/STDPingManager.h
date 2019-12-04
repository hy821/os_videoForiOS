//
//  STDPingManager.h
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

