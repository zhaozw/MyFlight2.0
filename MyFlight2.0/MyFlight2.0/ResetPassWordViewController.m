//
//  ResetPassWordViewController.m
//  MyFlight2.0
//
//  Created by Davidsph on 12/16/12.
//  Copyright (c) 2012 LIAN YOU. All rights reserved.
//

#import "ResetPassWordViewController.h"
#import "AppConfigure.h"
#import "LoginBusiness.h"
#import "UIQuickHelp.h"
#import "LogViewController.h"
#import "ViewController.h"
#import "UIButton+BackButton.h"
#import "MBProgressHUD.h"
@interface ResetPassWordViewController ()
{
    
    
    BOOL isResetPwdSuccess;
}
@end

@implementation ResetPassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}



- (void) setNav{
    
    UIButton * backBtn = [UIButton  backButtonType:0 andTitle:@""];
    
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBtn1=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=backBtn1;
    [backBtn1 release];
    
}


- (void) back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    self.title = @"重置密码";
    
    isResetPwdSuccess = NO;
    CCLog(@"重置密码页面 用户手机号 %@ 验证码 %@",self.mobile,self.code);
    
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_newPassword release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNewPassword:nil];
    [super viewDidUnload];
}


//显示密码
- (IBAction)showPasswordState:(id)sender {
    
    
}


//发送重置密码 请求 
- (IBAction)commitResetPasswordRequest:(id)sender {
    
    NSString *pwd = [self.newPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([pwd length]==0) {
        
        [UIQuickHelp showAlertViewWithTitle:@"温馨提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [self.newPassword becomeFirstResponder];
    } else{
        LoginBusiness *bis = [[LoginBusiness alloc] init];
        
        
        [bis findPassWd_ResetPassWdWithNewPwd:self.newPassword.text mobile:self.mobile code:self.code andDelegate:self];
        [bis release];
     }
    
         
}





#pragma mark -
#pragma mark 返回有错误信息时的处理
//请求 返回失败时 调用的方法
- (void)requestDidFinishedWithFalseMessage:(NSDictionary *)info{
    
    
       
//    NSString *thisMessage = [info objectForKey:KEY_Request_Type];
    
    NSString *returnMessage = [info objectForKey:KEY_message];
    
    //判断是哪一个业务返回的网络请求
    
            CCLog(@"这是请求重置密码返回错误处理信号");
        
        [UIQuickHelp showAlertViewWithTitle:@"温馨提醒" message:returnMessage   delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        
        

}



#pragma mark -
#pragma mark 成功执行注册操作
//正确信息后调用的方法
- (void) requestDidFinishedWithRightMessage:(NSDictionary *)info{
    
    
//    NSString *thisMessage = [info objectForKey:KEY_Request_Type];
//    NSString *returnMessage = [info objectForKey:KEY_message];
    
    NSString *returnMessage = @"恭喜您，重置密码成功";
    
    isResetPwdSuccess = YES;
    
    
    
    [UIQuickHelp showAlertViewWithTitle:nil message:returnMessage   delegate:self cancelButtonTitle:@"回首页" otherButtonTitles:@"登录"];
        

    
}

#pragma mark -
#pragma mark 警告视图代理方法

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (isResetPwdSuccess) {
        
        switch (buttonIndex) {
            case 0:
                
                
               
                
                break;
                
            default:
                break;
        }
        
        
        
    }
    
    
    
    
    
}


#pragma mark -
#pragma mark 网络返回失败时的处理
- (void) requestDidFailed:(NSDictionary *)info{
    
  //    isSecretBnEnabled = YES;
//    
//    self.getSecretCodeBn.userInteractionEnabled = YES;
//    
//    NSString *thisMessage = [info objectForKey:KEY_Request_Type];
    NSString *returnMessage = [info objectForKey:KEY_message];
    
            
        [UIQuickHelp showAlertViewWithTitle:@"温馨提醒" message:returnMessage   delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        
        
    
}






@end
