//
//  WHPingTester.m
//  BigVPN
//
//  Created by wanghe on 2017/5/11.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import "WHPingTester.h"

@interface WHPingTester()<SimplePingDelegate>
{
    NSTimer* _timer;
    NSDate* _beginDate;
}
@property(nonatomic, strong) SimplePing* simplePing;

@property(nonatomic, strong) NSMutableArray<WHPingItem*>* pingItems;
@end

@implementation WHPingTester

- (instancetype) initWithHostName:(NSString*)hostName
{
    if(self = [super init])
    {
        self.simplePing = [[SimplePing alloc] initWithHostName:hostName];
        self.simplePing.delegate = self;
        self.simplePing.addressStyle = SimplePingAddressStyleAny;

        self.pingItems = [NSMutableArray new];
    }
    return self;
}

- (void) startPing
{
    [self.simplePing start];
}

- (void) stopPing
{
    [_timer invalidate];
    _timer = nil;
    [self.simplePing stop];
}


- (void) actionTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendPingData) userInfo:nil repeats:YES];
}

- (void) sendPingData
{
    
    [self.simplePing sendPingWithData:nil];
    
}


#pragma mark Ping Delegate
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    [self actionTimer];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    NSLog(@"ping失败--->%@", error);
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    WHPingItem* item = [WHPingItem new];
    item.sequence = sequenceNumber;
    [self.pingItems addObject:item];
    
    _beginDate = [NSDate date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([self.pingItems containsObject:item])
        {
            NSLog(@"超时---->");
            [self.pingItems removeObject:item];
            if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didPingSucccessWithTime:withError:)])
            {
                [self.delegate didPingSucccessWithTime:0 withError:[NSError errorWithDomain:NSURLErrorDomain code:111 userInfo:nil]];
            }
        }
    });
}
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    NSLog(@"发包失败--->%@", error);
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didPingSucccessWithTime:withError:)])
    {
        [self.delegate didPingSucccessWithTime:0 withError:error];
    }
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    float delayTime = [[NSDate date] timeIntervalSinceDate:_beginDate] * 1000;
    [self.pingItems enumerateObjectsUsingBlock:^(WHPingItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.sequence == sequenceNumber)
        {
            [self.pingItems removeObject:obj];
        }
    }];
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didPingSucccessWithTime:withError:)])
    {
        [self.delegate didPingSucccessWithTime:delayTime withError:nil];
    }
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
}

@end

@implementation WHPingItem

@end
