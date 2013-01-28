#import <SenTestingKit/SenTestingKit.h>
#import "ESCache.h"

@interface ESCacheTests : SenTestCase
@end

@implementation ESCacheTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [[ESCache sharedCache] removeAllObjects];

    [super tearDown];
}

- (void)testObjectAdding {
    NSString *object = @"test string object";
    [[ESCache sharedCache] setObject:object forKey:@"key"];
    BOOL objectExists = [[ESCache sharedCache] objectExistsForKey:@"key"];
    NSString *objectFilePath = [[ESCache sharedCache] pathForObjectForKey:@"key"];
    BOOL objectFileExitst = [[NSFileManager defaultManager] fileExistsAtPath:objectFilePath];

    STAssertTrue(objectExists, @"An object should exist");
    STAssertNotNil(objectFilePath, @"Object's file path should not be nil");
    STAssertTrue(objectFileExitst, @"Object file sould exist");
}

- (void)testNilSetting {
    NSString *object = @"test string object";
    [[ESCache sharedCache] setObject:object forKey:@"key"];
    [[ESCache sharedCache] setObject:nil forKey:@"key"];
    object = [[ESCache sharedCache] objectForKey:@"key"];
    STAssertNil(object, @"Setting nil should remove object with corresponding key from the cache");
}

- (void)testObjectRetrieving {
    NSString *originalObject = @"test string object";
    [[ESCache sharedCache] setObject:originalObject forKey:@"key"];
    id object = [[ESCache sharedCache] objectForKey:@"key"];
    STAssertEqualObjects(object, originalObject, @"NSCache'd object should be equal to one which was used before");

    [[ESCache sharedCache] clearMemory];
    object = [[ESCache sharedCache] objectForKey:@"key"];
    STAssertEqualObjects(object, originalObject, @"File cached object should be equal to one which was used before");
}

- (void)testObjectRemoving {
    NSString *object = @"test string object";
    [[ESCache sharedCache] setObject:object forKey:@"key"];
    [[ESCache sharedCache] removeObjectForKey:@"key"];
    STAssertNil([[ESCache sharedCache] objectForKey:@"key"], @"We shouldn't get just removed object");
}

- (void)testAllObjectsRemoving {
    NSString *firstObject = @"test string object";
    [[ESCache sharedCache] setObject:firstObject forKey:@"key1"];
    NSString *secondObject = @"test string object";
    [[ESCache sharedCache] setObject:secondObject forKey:@"key2"];
    [[ESCache sharedCache] removeAllObjects];
    STAssertFalse([[ESCache sharedCache] objectExistsForKey:@"key1"], @"First object should not be in cache");
    STAssertFalse([[ESCache sharedCache] objectExistsForKey:@"key2"], @"Second object should not be in cache");
}

- (void)testESNSCodingException {
    NSObject *object = [[NSObject alloc] init];
    STAssertNoThrow([[ESCache sharedCache] setObject:(id<NSCoding>)object forKey:@"key"], @"We shall not get an exception here");
}

- (void)testWierdKey {
    NSString *object = @"test string object";
    NSString *key = @"! @#$%^&*()_+=-§±`~/?.>,<";
    [[ESCache sharedCache] setObject:object forKey:key];
    object = [[ESCache sharedCache] objectForKey:key]; //this one is needed to wait for setObject:forKey: to be finished
    [[ESCache sharedCache] clearMemory];
    object = [[ESCache sharedCache] objectForKey:key];
    STAssertEqualObjects(object, @"test string object", @"We should get the object even for such a wierd key");
}

- (void)testWierdCacheName {
    NSString *name = @"! @#$%^&*()_+=-§±`~/?.>,<";
    NSString *object = @"test string object";
    NSError *error = nil;
    ESCache *cache = [[ESCache alloc] initWithName:name error:&error];
    STAssertNil(error, @"We shouldn't get an error for a such a cache name");

    [cache setObject:object forKey:@"key"];
    object = [cache objectForKey:@"key"];
    [cache clearMemory];
    object = [cache objectForKey:@"key"];
    STAssertEqualObjects(object, @"test string object", @"We should properly get an objecvt from the filesystem");
}

@end
