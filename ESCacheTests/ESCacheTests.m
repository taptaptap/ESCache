#import <SenTestingKit/SenTestingKit.h>
#import "ESCache.h"

@interface ESCacheTests : SenTestCase
@end

@implementation ESCacheTests {
    ESCache *_cache;
}

- (void)setUp {
    [super setUp];
    _cache = [[ESCache alloc] initWithName:@"test name" error:NULL];
}

- (void)tearDown {
    [_cache removeAllObjects];

    [super tearDown];
}

- (void)testObjectAdding {
    NSString *object = @"test string object";
    [_cache setObject:object forKey:@"key"];
    BOOL objectExists = [_cache objectExistsForKey:@"key"];
    NSString *objectFilePath = [_cache pathForObjectForKey:@"key"];
    BOOL objectFileExitst = [[NSFileManager defaultManager] fileExistsAtPath:objectFilePath];

    STAssertTrue(objectExists, @"An object should exist");
    STAssertNotNil(objectFilePath, @"Object's file path should not be nil");
    STAssertTrue(objectFileExitst, @"Object file sould exist");
}

- (void)testNilSetting {
    NSString *object = @"test string object";
    [_cache setObject:object forKey:@"key"];
    [_cache setObject:nil forKey:@"key"];
    object = [_cache objectForKey:@"key"];
    STAssertNil(object, @"Setting nil should remove object with corresponding key from the cache");
}

- (void)testObjectRetrieving {
    NSString *originalObject = @"test string object";
    [_cache setObject:originalObject forKey:@"key"];
    id object = [_cache objectForKey:@"key"];
    STAssertEqualObjects(object, originalObject, @"NSCache'd object should be equal to one which was used before");

    [_cache clearMemory];
    object = [_cache objectForKey:@"key"];
    STAssertEqualObjects(object, originalObject, @"File cached object should be equal to one which was used before");
}

- (void)testObjectRemoving {
    NSString *object = @"test string object";
    [_cache setObject:object forKey:@"key"];
    [_cache removeObjectForKey:@"key"];
    STAssertNil([_cache objectForKey:@"key"], @"We shouldn't get just removed object");
}

- (void)testAllObjectsRemoving {
    NSString *firstObject = @"test string object";
    [_cache setObject:firstObject forKey:@"key1"];
    NSString *secondObject = @"test string object";
    [_cache setObject:secondObject forKey:@"key2"];
    [_cache removeAllObjects];
    STAssertFalse([_cache objectExistsForKey:@"key1"], @"First object should not be in cache");
    STAssertFalse([_cache objectExistsForKey:@"key2"], @"Second object should not be in cache");
}

- (void)testESNSCodingException {
    NSObject *object = [[NSObject alloc] init];
    STAssertNoThrow([_cache setObject:(id<NSCoding>)object forKey:@"key"], @"We shall not get an exception here");
}

- (void)testWierdKey {
    NSString *object = @"test string object";
    NSString *key = @"! @#$%^&*()_+=-§±`~/?.>,<";
    [_cache setObject:object forKey:key];
    object = [_cache objectForKey:key]; //this one is needed to wait for setObject:forKey: to be finished
    [_cache clearMemory];
    object = [_cache objectForKey:key];
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
