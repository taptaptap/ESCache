# ESCache

ESCache is a simple NSCache/NSMutableDictionary (in secure version) wrapper which is backed by on-disk persistence. It has two useful classes: ESCache and ESSecureCache.

[ESCache](http://github.com/0xc010d/ESCache/ESCache/ESCache.h) class might be used when you need to persist NSCache'd data to share it between launch sessions.
[ESSecureCache](http://github.com/0xc010d/ESCache/ESCache/ESSecureCache.h) might be used to share data between sessions and it also encrypts persistent storage.

## Example usage

### ESCache

It's as simple as NSDictionary: you set and get objects. The only requirement is that these objects should conform to NSCoding protocol.

##### Cache the data

```objective-c
ESCache *cache = [[ESCache sharedCache] setObject:@"string to share" forKey:@"key"];
```

##### Retrieve the data

```objective-c
NSString *object = [[ESCache sharedCache] objectForKey:@"key"];
```

### ESSecureCache

It has two possible ways to persist cached data: file-backed persistence and NSUserDefaults. File-backed persistence is used as 'default' in `+sharedCache` so use `-initWithName:type:error:` initializer to implicitly specify persistence type.

##### Create an ESSecureCache instance backed by NSUserDefaults persistence

```objective-c
// cache's name is used as a key for NSUserDefaults' -setObject:forKey:
// it would be used as a file name in case of file-backed persistence
_cache = [[ESSecureCache alloc] initWithName:@"ESSecureCache" type:ESSecureCacheTypeUserDefaults error:NULL]; 
```

##### Cache an object (it doesn't differ from ESCache's method)

```objective-c
[_cache setObject:@"string object" forKey:@"key"];
```

##### Retrieve the data

```objective-c
NSString *object = [_cache objectForKey:@"key"];
```

## Requirements

ESCache requires iOS 4.3 and above or OS X 10.7 and above.

### ARC

ESCache supports both ARC and non-ARC environment.

## Contact

Drop [me](https://twitter.com/0xc010d) a line if you have questions regarding to that library.

## License

ESCache is available under the MIT license. See the LICENSE file for more info.
