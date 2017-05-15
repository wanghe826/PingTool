//
//  WHPingTester.h
//  BigVPN
//
//  Created by wanghe on 2017/5/11.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

@protocol WHPingDelegate <NSObject>
@optional
- (void) didPingSucccessWithTime:(float)time withError:(NSError*) error;
@end


@interface WHPingTester : NSObject<SimplePingDelegate>
@property (nonatomic, weak, readwrite) id<WHPingDelegate> delegate;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithHostName:(NSString*)hostName NS_DESIGNATED_INITIALIZER;

- (void) startPing;
- (void) stopPing;
@end

typedef NS_ENUM(NSUInteger, WHPingStatus){
    WHPingStatusSending = 0 << 0,
    WHPingStatusTimeout = 1 << 1,
    WHPingStatusSended = 2 << 2,
};

@interface WHPingItem : NSObject
//@property(nonatomic, assign) WHPingStatus status;
@property(nonatomic, assign) uint16_t sequence;

@end



