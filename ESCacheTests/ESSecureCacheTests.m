#import <SenTestingKit/SenTestingKit.h>
#import "ESSecureCache.h"

@interface ESSecureCacheTests : SenTestCase
@end

@implementation ESSecureCacheTests {
    ESSecureCache *_cache;
}

- (void)setUp {
    [super setUp];

    _cache = [[ESSecureCache alloc] initWithName:@"name" type:ESSecureCacheTypeFile error:NULL];
    [_cache setEncryptionKey:[@"password" dataUsingEncoding:NSASCIIStringEncoding]];
}

- (void)tearDown {
    [_cache removeAllObjects];
    _cache = nil;

    [super tearDown];
}

- (void)testObjectAdding {
    NSString *object = @"test string object";
    [_cache setObject:object forKey:@"key"];
    BOOL objectExists = [_cache objectExistsForKey:@"key"];
    STAssertTrue(objectExists, @"An object should exist");

    object = [_cache objectForKey:@"key"];
    STAssertEqualObjects(object, @"test string object", @"Retrieved object should be the same as one we've just saved");
}

- (void)testObjectLoadingFromStorage {
    [_cache setObject:@"test string object" forKey:@"key"];
    [_cache clearMemory];

    NSString *object = [_cache objectForKey:@"key"];
    STAssertEqualObjects(object, @"test string object", @"Retrieved object should be the same as one we've just saved");
}

- (void)testWrongPassword {
    [_cache setObject:@"test string object" forKey:@"key"];
    [_cache clearMemory];
    [_cache setEncryptionKey:[@"test" dataUsingEncoding:NSASCIIStringEncoding]];

    NSString *object = nil;
    STAssertNoThrow(object = [_cache objectForKey:@"key"], @"Exception should not be thrown");
    STAssertNil(object, @"We shall not get an object if the password is wrong");
}

- (void)testSubscripting {
    _cache[@"key"] = @"test string object";
    [_cache clearMemory];
    NSString *object = _cache[@"key"];

    STAssertEqualObjects(object, @"test string object", @"Retrieved object should be the same as one we've just saved");
}

@end
