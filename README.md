# PingTool

使用方法:
1. 将pingTool拷入到xcode工程
2. 引入头文件
``` objective-c
#import "WHPingTester.h"
```
3. 设置属性变量，并在controller 上面实现代理。<WHPingDelegate>
```
  @property(nonatomic, strong) WHPingTester* pingTester;
  //ping
  self.pingTester = [[WHPingTester alloc] initWithHostName:@"www.baidu.com"];
  self.pingTester.delegate = self;
  [self.pingTester startPing];
```
4. 实现委托.
```
- (void) didPingSucccessWithTime:(float)time withError:(NSError *)error
{
    if(!error)
    {
        NSLog(@"ping的延迟是--->%f", time);
    }else{
        NSLog(@"网络不通");
     }
}
```
