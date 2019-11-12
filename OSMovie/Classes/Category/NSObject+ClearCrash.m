//
//  NSObject+ClearCrash.m
//

#import "NSObject+ClearCrash.h"

@implementation NSObject (ClearCrash)
- (void)getFileCacheSizeWithPath:(NSString *)path completion:(void (^)(NSInteger total))completion
{
    [NSObject getFileCacheSizeWithPath:path completion:completion];
}
// 异步方法,不需要返回值
// 异步方法使用回调,block
+ (void)getFileCacheSizeWithPath:(NSString *)path completion:(void(^)(NSInteger total))completion
{
    // 开启异步线程 2秒
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1.创建文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // 1.1.判断下是否存在,而且是否是文件夹
        BOOL isDirectory;
        BOOL isFileExist = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
        
        // 判断下当前是否是文件
        if (isFileExist){
            // 判断下是否是文件夹
            NSInteger total = 0;
            if (isDirectory) {
                // 2.遍历文件夹下所有文件,全部加上,就是文件夹大小
                NSArray *subPaths = [mgr subpathsAtPath:path];
                for (NSString *subPath in subPaths) {
                    // 3.拼接文件全路径
                    NSString *filePath = [path stringByAppendingPathComponent:subPath];
                    BOOL isDirectory;
                    // 4.判断下当前是否是文件
                    BOOL isFileExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
                    // 5.获取文件大小
                    if (isFileExist && !isDirectory && ![filePath containsString:@"DS"]) {
                        
                        NSDictionary *fileAttr = [mgr attributesOfItemAtPath:filePath error:nil];
                        NSInteger fileSize = [fileAttr[NSFileSize] integerValue];
                        total += fileSize;
                    }
                }
                
            }else{
                // 当前传入是文件
                NSDictionary *fileAttr = [mgr attributesOfItemAtPath:path error:nil];
                total = [fileAttr[NSFileSize] integerValue];
            }
            
            // 计算完毕 -> 把计算的值传递出去
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (completion) {
                    completion(total);
                }
            });
        }
    });
    
}
/** 清除指定路径的缓存  */
+ (void)removeCacheWithPath:(NSString*)path AndCompletion:(void (^)())completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 创建文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        BOOL isDirectory;
        BOOL isFileExist = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
        if (!isFileExist) return;
        if (isDirectory) {
            NSArray *subPaths = [mgr subpathsAtPath:path];
            for (NSString *subPath in subPaths) {
                NSString *filePath = [path stringByAppendingPathComponent:subPath];
                [mgr removeItemAtPath:filePath error:nil];
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });

}
+(void)removeCacheWithCompletion:(void (^)())completion withFileType:(NSString *)type
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
            SSLog(@"%@",filename);
            if ([[filename pathExtension] isEqualToString:@"PNG"]) {
                SSLog(@"删除%@",filename);
                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
                continue;
            }
            if ([[[filename pathExtension] lowercaseString] isEqualToString:@"mp4"]||
                [[[filename pathExtension] lowercaseString] isEqualToString:@"mov"]||
                [[[filename pathExtension] lowercaseString] isEqualToString:@"png"]) {
                SSLog(@"删除%@",filename);
                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}
//2.清除缓存
+ (void)removeCacheWithCompletion:(void (^)())completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 创建文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        // 删除文件
        NSString *path = self.cachePath;
        
//        if(path == nil)
//        {
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString * documentDirectory = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
        path = documentDirectory;
//        }
        
        BOOL isDirectory;
        BOOL isFileExist = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
        if (!isFileExist) return;
        if (isDirectory) {
            NSArray *subPaths = [mgr subpathsAtPath:path];
            for (NSString *subPath in subPaths) {
                NSString *filePath = [path stringByAppendingPathComponent:subPath];
                [mgr removeItemAtPath:filePath error:nil];
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
    
}

- (void)removeCacheWithCompletion:(void (^)())completion
{
    [NSObject removeCacheWithCompletion:completion];
    
}

// 3.缓存路径
- (NSString *)cachePath
{
    return [NSObject cachePath];
}

+ (NSString *)cachePath
{
    // 获取cachePath文件路径
    return  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}
@end
