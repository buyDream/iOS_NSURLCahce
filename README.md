嗯，iOS端使用缓存的过程我就不必再阐述了。

这个demo是用来学习NSURLCache的，我们需要提前知道的是，NSURLCache只能缓存get请求的response，另一个是当系统内存空间不足时会自动清理磁盘上的缓存，线程安全（与NSCache很相似）。

### NSURLCache

​	为应用提供内存和磁盘上的缓存。通过URL请求映射NSURLRequest对象和NSCachedURLResponse对象，你可以手动设置在内存和磁盘的缓存大小（容量），也可以设置其存储路径。

* 线程安全

* 使用db存储

  key = url + 参数

#### 使用

​	在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 方法里进行设置：

~~~objective-c
NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];// 使用默认路径
    [NSURLCache setSharedURLCache:URLCache];
~~~

有意思的是系统会__默认__缓存容量，就是说即使你不设置它也会有缓存。

在ViewController.m文件中，使用了两个不同的request，展示了缓存是使用。

__值得一提的是__- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request方法，其中涉及到了NSRURLRequest中的NSURLRequestCachePolicy（指定缓存策略），因为我们普通的request会设置默认值（即根据网络传输层协议定，这又可以开一个内容）。

当然我们也可是不使用缓存即NSURLRequestReloadIgnoringLocalCacheData和NSURLRequestReloadIgnoringCacheData（两者一样，一模一样），此时我们使用storeCachedResponse:才会有效果。

__另一个问题__：removeCachedResponseForRequest:移除指定request缓存，没有效果。

​	其实是它真的没有效果，参考[http://blog.airsource.co.uk/2014/10/13/nsurlcache-ios8-broken-2/](http://blog.airsource.co.uk/2014/10/13/nsurlcache-ios8-broken-2/)。



__最后一个真的是问题，为什么- cachedResponseForRequest:会使**currentDiskUsage**增加?__

​	不过好在只增加一次。如果知道了这个，那么通过storeCachedResponse:缓存的为什么cachedResponseForRequest会增加多次也好理解了。

以上。