//
//  ViewController.m
//  NSURLCache_learn
//
//  Created by Refraining on 2017/7/7.
//  Copyright © 2017年 Refraining. All rights reserved.
//

#import "ViewController.h"
static const NSString *sourceStr = @"http://v.juhe.cn/WNXG/city";
static const NSString *firstSourceurl = @"http://v.juhe.cn/WNXG/selectRepair";

static const NSString *key = @"3bc1d831c6d7f383c0fcc3b24bd8290b";

@interface ViewController ()

@end

@implementation ViewController {
    NSURLRequest *_request;
    NSURLRequest *_firstRequest;
    NSURLCache *_cache;
    NSCachedURLResponse *_cacheResponse;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *firstURLStr = [firstSourceurl stringByAppendingString:[NSString stringWithFormat:@"?cityCode=%@&repairCode=%@&repairName=&key=%@", @"suzhou", @"1", key]];

    _firstRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:firstURLStr] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    NSString *urlStr = [sourceStr stringByAppendingString:[NSString stringWithFormat:@"?=%@&key=%@", @"123", key]];
    _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];

    _cache = [NSURLCache sharedURLCache];
}

#pragma mark ---  first request
// 1. start request
- (IBAction)startingFirstRequest:(id)sender {
    [self p_requestData:_firstRequest];
}

// 2. store cache
- (IBAction)storingCacheResponse:(id)sender {
//    NSCachedURLResponse *response =  [NSCachedURLResponse alloc] initWithResponse:<#(nonnull NSURLResponse *)#> data:<#(nonnull NSData *)#>;
    [_cache storeCachedResponse:_cacheResponse forRequest:_firstRequest];
    [self p_showCurrentUsage];
}
// 3. get cache
- (IBAction)getFirstCache:(id)sender {
    [self p_gettingCacheData:_firstRequest];
}

// 4. remove this specialed cache
// wa~ 
- (IBAction)removeSpecialedCache:(id)sender {
    [_cache removeCachedResponseForRequest:_firstRequest];
    [self p_showCurrentUsage];
}


#pragma mark ---  second request
- (IBAction)startingRequest:(id)sender {
    [self p_requestData:_request];
}

- (IBAction)gettingCache:(id)sender {
    [self p_gettingCacheData:_request];
}
// remove all cache
- (IBAction)removeCache:(id)sender {
    [_cache removeAllCachedResponses];
    [self p_showCurrentUsage];
}

#pragma mark -- private

- (void)p_requestData:(NSURLRequest *)request {
//    __weak typeof <#expression#>
    __weak typeof(self)weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"dic: %@", dataDic);
        }
        
        // store
        if (request == _firstRequest) {
            _cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
        }
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf p_showCurrentUsage];
    }];
    [task resume];
}

- (void)p_gettingCacheData:(NSURLRequest *)request {
    //    [cache getCachedResponseForDataTask:task completionHandler:^(NSCachedURLResponse * _Nullable cachedResponse) {
    //
    //    }];
    NSCachedURLResponse *response = [_cache cachedResponseForRequest:request];
    NSData *resData = response.data;
    if (resData) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:resData options:0 error:nil];
        NSLog(@"response dataDic:%@", dataDic);
    } else {
        NSLog(@"There is no response cache");
    }
    [self p_showCurrentUsage];
}

- (void)p_showCurrentUsage {
    NSLog(@"currentDiskUsage:%lu, diskCapacity:%lu", (unsigned long)_cache.currentDiskUsage, (unsigned long)_cache.diskCapacity);
}

@end
