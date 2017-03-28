
## 项目目录
* [Appointment](https://github.com/MoPellet/Appointment)
* [MOMenuView](https://github.com/MoPellet/MOMenuView)

一、项目介绍
----------
1、添加相关框架
SystemConfiguration.framework
Security.framework
NetworkExtension.framework

2、导入MoVPNManage.h 头文件到你的项目中
```c
#import "MoVPNManage.h"
```

3、创建MoVPNManage的实例
```c
MoVPNManage * vpnManage = [MoVPNManage shareVPNManage];
```

4、设置标题
```c
[vpnManage setVpnTitle:@"Happy Vpn"];
```

5、配置相关参数 服务器 账号 密码 私钥
```c
[vpnManage setServer:@"your host" ID:@"id" pwd:@"pwd" privateKey:@"key"];
```

6、保存配置参数
```c
[vpnManage saveConfigCompleteHandle:^(BOOL success, NSString *returnInfo) {
    NSLog(@"%@",returnInfo);
    if (success) {
        [vpnManage vpnStart];
    }
}];
```
7、启动VPN
```c
[vpnManage vpnStart];
```

8、在不越狱的情况下支持 ipsec协议 

二、相关资料
* [谈谈 iOS8 中的 Network Extension](http://blog.zorro.im/posts/iOS8-Network-Extension.html)
* [Configure and manage VPN connections programmatically in iOS 8](http://ramezanpour.net/post/2014/08/03/configure-and-manage-vpn-connections-programmatically-in-ios-8/)


    



