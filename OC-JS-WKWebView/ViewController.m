//
//  ViewController.m
//  Interaction
//
//  Created by KT-yzx on 2019/9/20.
//  Copyright © 2019 QuickTo. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_initWithFrame"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_backgroundColor"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_buttonWithType"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_addTargetActionForControlEvents"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_setTitleForState"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_setTitleColorForState"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_setImageForState"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_buttonTitleLabelFont"];

    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"oh_initWithFrame"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"oh_backgroundColor"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_buttonWithType"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_addTargetActionForControlEvents"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_setTitleForState"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_setTitleColorForState"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_setImageForState"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"oh_buttonTitleLabelFont"];

    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebView];
    
    
    
}

//加载本地的html文件
- (void)loadWebView
{
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    WKUserContentController *userCC = config.userContentController;
    //JS调用OC 添加处理脚本
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 100, 20, 20) configuration:config];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"html"];
    
    
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    [self.wkWebView loadHTMLString:htmlCont baseURL:baseURL];
    
    [self.view addSubview:self.wkWebView];
    
    
}






#pragma mark - navigationDelegate


//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"开始加载2");
}

//内容返回时调用，得到请求内容时调用(内容开始加载) -> view的过渡动画可在此方法中加载
- (void)webView:(WKWebView *)webView didCommitNavigation:( WKNavigation *)navigation
{
    NSLog(@"内容返回时调用，得到请求内容时4");
    
}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation
{
    NSLog(@"页面加载完成时5");
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    NSString * funcStr = [NSString stringWithFormat:@"widthAndHeight(%f,%f)", width, height];
    [self.wkWebView evaluateJavaScript:funcStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ %@",response,error);
    }];
    
}

//请求失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error1:%@",error);
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error2:%@",error);
}

//在请求发送之前，决定是否跳转 -> 该方法如果不实现，系统默认跳转。如果实现该方法，则需要设置允许跳转，不设置则报错。
//该方法执行在加载界面之前
//Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Completion handler passed to -[ViewController webView:decidePolicyForNavigationAction:decisionHandler:] was not called'
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSLog(@"url =========== %@", navigationAction.request.URL);
    
    
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
    //不允许跳转
    //        decisionHandler(WKNavigationActionPolicyCancel);
    NSLog(@"在请求发送之前，决定是否跳转 1");
}

//在收到响应后，决定是否跳转（同上）
//该方法执行在内容返回之前
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //    decisionHandler(WKNavigationResponsePolicyCancel);
    NSLog(@"在收到响应后，决定是否跳转。 3");
    
}

//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"接收到服务器跳转请求之后调用");
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"webViewWebContentProcessDidTerminate");
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message.name = %@",message.name);
    NSLog(@"message.body = %@",message.body);
    
    if ([message.name isEqualToString:@"oh_initWithFrame"]) {//初始化和frame
        
        NSArray *array = message.body;
        [self oh_initWithFrame:array];
        
    }
    if ([message.name isEqualToString:@"oh_backgroundColor"]) {//背景颜色
        
        NSArray *array = message.body;
        [self oh_backgroundColor:array];
        
    }
    if ([message.name isEqualToString:@"oh_buttonWithType"]){//初始化按钮和样式
        NSArray *array = message.body;
        [self oh_buttonWithType:array];
    }
    if ([message.name isEqualToString:@"oh_addTargetActionForControlEvents"]) {//按钮点击事件
        NSArray *array = message.body;
        [self oh_addTargetActionForControlEvents:array];
    }
    if ([message.name isEqualToString:@"oh_setTitleForState"]) {//按钮上的文字
        NSArray *array = message.body;
        [self oh_setTitleForState:array];
    }
    if ([message.name isEqualToString:@"oh_setTitleColorForState"]) {//按钮上的文字颜色
        NSArray *array = message.body;
        [self oh_setTitleColorForState:array];
    }
    if ([message.name isEqualToString:@"oh_setImageForState"]) {//按钮上的图片
        NSArray *array = message.body;
        [self oh_setImageForState:array];
    }
    if ([message.name isEqualToString:@"oh_buttonTitleLabelFont"]){//按钮上文字的大小
        NSArray *array = message.body;
        [self oh_buttonTitleLabelFont:array];
    }
    
    
}

#pragma mark - UI控件的调用


- (void)oh_init{
    
    
}
//初始化控件
- (void)oh_initWithFrame:(NSArray *)model{
    if (model.count < 6) {
        return;
    }
    
    NSString * getView = (NSString *)[model objectAtIndex:0];
    NSString * getTag = (NSString *)[model objectAtIndex:1];
    NSString * x = (NSString *)[model objectAtIndex:2];
    NSString * y = (NSString *)[model objectAtIndex:3];
    NSString * width = (NSString *)[model objectAtIndex:4];
    NSString * height = (NSString *)[model objectAtIndex:5];
    
    
    
    if ([getView isEqualToString:@"UIView"]) {
        
        UIView * selectView = [[UIView alloc] initWithFrame:CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue])];
        selectView.tag = [getTag integerValue];
        [self.view addSubview:selectView];
        
    }else if ([getView isEqualToString:@"UIButton"]){
        
        
        NSArray * butArray = [NSArray arrayWithObjects:getTag, @"1", nil];
        [self oh_buttonWithType:butArray];
        
        UIButton * ohButton = [self.view viewWithTag:getTag.integerValue];
        ohButton.frame = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);
        
        
    }else if ([getView isEqualToString:@"UIImageView"]){
        
        UIImageView * selectView = [[UIImageView alloc] initWithFrame:CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue])];
        selectView.tag = [getTag integerValue];
        [self.view addSubview:selectView];
        
    }
    
}

//控件背景颜色
- (void)oh_backgroundColor:(NSArray *)model{
    
    if (model.count < 5) {
        return;
    }
    NSString * getTag = (NSString *)[model objectAtIndex:0];
    NSString * red = (NSString *)[model objectAtIndex:1];
    NSString * green = (NSString *)[model objectAtIndex:2];
    NSString * blue = (NSString *)[model objectAtIndex:3];
    NSString * alpha = (NSString *)[model objectAtIndex:4];
    
    
    float redFloat = [red floatValue];
    float greenFloat = [green floatValue];
    float blueFloat = [blue floatValue];
    float alphaFloat = [alpha floatValue];
    UIView * ohView = [self.view viewWithTag:[getTag integerValue]];
    ohView.backgroundColor = [UIColor colorWithRed:redFloat/255.0 green:greenFloat/255.0 blue:blueFloat/255.0 alpha:alphaFloat];
    
    
}

#pragma mark - UIButton

- (void)oh_buttonWithType:(NSArray *)buttonType{//初始化按钮
    
    if (buttonType.count < 2) {
        return;
    }
    
    
    NSString * getTag = (NSString *)[buttonType objectAtIndex:0];
    NSString * type = (NSString *)[buttonType objectAtIndex:1];
    
    UIButton * ohButton = [UIButton buttonWithType:type.integerValue];
    ohButton.tag = [getTag integerValue];
    [self.view addSubview:ohButton];
    

}

- (void)oh_addTargetActionForControlEvents:(NSArray *)addArray{//按钮点击事件
    
    if (addArray.count < 2) {
        return;
    }
    
    
    NSString * getTag = (NSString *)[addArray objectAtIndex:0];
    NSString * type = (NSString *)[addArray objectAtIndex:1];
    
    UIButton * ohButton = [self.view viewWithTag:getTag.integerValue];
    [ohButton addTarget:self action:@selector(pressOhButton:) forControlEvents:type.integerValue];

    
}

- (void)pressOhButton:(UIButton *)sender{//按钮点击方法
    
    NSInteger tag = sender.tag;
    NSString * funcStr = [NSString stringWithFormat:@"pressOhButton(%ld)", (long)tag];
    [self.wkWebView evaluateJavaScript:funcStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ %@",response,error);
    }];
    
}

- (void)oh_setTitleForState:(NSArray *)titleArray{//按钮上的文字
    
    
    if (titleArray.count < 3) {
        return;
    }
    
    
    NSString * getTag = (NSString *)[titleArray objectAtIndex:0];
    NSString * titleString = (NSString *)[titleArray objectAtIndex:1];
    NSString * type = (NSString *)[titleArray objectAtIndex:2];

    
    UIButton * ohButton = [self.view viewWithTag:getTag.integerValue];
    [ohButton setTitle:titleString forState:type.integerValue];

}

- (void)oh_setTitleColorForState:(NSArray *)titleArray{//按钮上文字颜色
    if (titleArray.count < 6) {
        return;
    }
    NSString * getTag = (NSString *)[titleArray objectAtIndex:0];
    NSString * red = (NSString *)[titleArray objectAtIndex:1];
    NSString * green = (NSString *)[titleArray objectAtIndex:2];
    NSString * blue = (NSString *)[titleArray objectAtIndex:3];
    NSString * alpha = (NSString *)[titleArray objectAtIndex:4];
    NSString * type = (NSString *)[titleArray objectAtIndex:5];
    
    float redFloat = [red floatValue];
    float greenFloat = [green floatValue];
    float blueFloat = [blue floatValue];
    float alphaFloat = [alpha floatValue];
    
    UIButton * ohButton = [self.view viewWithTag:getTag.integerValue];
    [ohButton setTitleColor:[UIColor colorWithRed:redFloat/255.0 green:greenFloat/255.0 blue:blueFloat/255.0 alpha:alphaFloat] forState:type.integerValue];
    
    

}

- (void)oh_buttonTitleLabelFont:(NSArray *)fontArray{// 按钮上文字的大小
    if (fontArray.count < 2) {
        return;
    }
    NSString * getTag = (NSString *)[fontArray objectAtIndex:0];
    NSString * font = (NSString *)[fontArray objectAtIndex:1];
    UIButton * ohButton = [self.view viewWithTag:getTag.integerValue];
    ohButton.titleLabel.font = [UIFont systemFontOfSize:font.integerValue];

    
}


- (void)oh_setImageForState:(NSArray *)imageArray{//按钮上的图片
    if (imageArray.count < 3) {
        return;
    }
    NSString * getTag = (NSString *)[imageArray objectAtIndex:0];
    NSString * imageStr = (NSString *)[imageArray objectAtIndex:1];
    NSString * type = (NSString *)[imageArray objectAtIndex:2];

    
    UIButton * ohButton = [self.view viewWithTag:getTag.integerValue];
    [ohButton setImage:[UIImage imageNamed:imageStr] forState:type.integerValue];

}


@end
