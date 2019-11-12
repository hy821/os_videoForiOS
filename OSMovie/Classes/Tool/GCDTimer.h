//
//  GCDTimer.h
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^task)(void);
typedef NS_ENUM(NSUInteger,GCDTimerStatues) {
    GCDTimerNeedResume,   //创建好未启动需要启动 or 被挂起需要恢复
    GCDTimerWorking,
    GCDTimerSuspend,
};

@interface GCDTimer : NSObject

@property (nonatomic, assign)GCDTimerStatues statues;
/**
 init
 @param sec 延迟多少s执行
 @param padding_sec 间隔多少秒
 @param task 要执行的任务
 @return instancetype id
 */
- (instancetype)initWithStartAfter:(CGFloat)sec
                           padding:(CGFloat)padding_sec
                              task:(task)task;

/**
 启动或恢复启动
 */
- (void)resume;

/**
 挂起
 */
- (void)suspend;
- (void)cancle;

@end

NS_ASSUME_NONNULL_END
