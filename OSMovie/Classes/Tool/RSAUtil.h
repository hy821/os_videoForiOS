//
//  RSAUtil.h
//  Encryption
//

#import "OOSBaseViewController.h"

@interface RSAUtil : OOSBaseViewController

//公钥加密时调用类方法：
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw datax
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
//私钥解密时调用类方法
// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;
@end
