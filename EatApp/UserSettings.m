//
//  UserSettings.m
//  EatApp
//
//  Created by Michel Balamou on 2016-02-28.
//  Copyright © 2016 EatApp. All rights reserved.
//

#import "UserSettings.h"

@interface UserSettings ()

@end

@implementation UserSettings

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float decorHeight = self.decorView.frame.size.height; //256
    float totalHeight = 667;//self.view.frame.size.height; //667
    
    [self print:totalHeight]; //PRINT
    btnSignUp_initial = self.viewSignUp.frame;
    btnSignUp = self.viewSignUp.frame;
    btnLogin = self.viewLogin.frame;
    
    
    [self print:btnSignUp.size.height]; //PRINT
    
    float btnHeight = 64;//btnSignUp.size.height; //64 px
    
    btnSignUp.origin.y = totalHeight - 2*btnHeight;
    btnLogin.origin.y = totalHeight - btnHeight; // final login button state
    
    //Up+++
    login_Down = loginUp = self.loginForm.frame;
    signUp_Down = signUp_Up = self.formSignUp.frame;
    
    loginUp.origin.y = decorHeight + btnHeight;
    signUp_Up.origin.y = decorHeight - btnHeight;
  
    //Down+++
    login_Down.origin.y = totalHeight - btnHeight;
    signUp_Down.origin.y = totalHeight - 2*btnHeight - signUp_Down.size.height;
    
    
    //
    specialLogin.origin.y=decorHeight; //decorHeight-loginUp.size.height+btnSignUp.size.height;
    
    activeView=@"Neutral"; // initial state
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"memory!");
    //Dispose of any resources that can be recreated.
}

-(void)print:(float)num
{
    NSLog([NSString stringWithFormat:@"%.20f", num]);
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touch=[touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]])
    {
        [touch.view endEditing:YES];
    }
}

- (IBAction)onLogin:(id)sender
{
    /* Move up the Login View if clicked on login first */
    if ([activeView isEqualToString:@"Neutral"])
    {
        self.loginForm.frame=specialLogin;
    }
    
    /* Move login and sign up button down */
    [UIView animateWithDuration:0.5f animations:^{
        
        self.viewLogin.frame=btnLogin;
        self.viewSignUp.frame=btnSignUp_initial; // good
        
        self.loginForm.frame=loginUp;
        self.formSignUp.frame=signUp_Up;
    
    }
    completion:^(BOOL finished)
    {
        activeView=@"Login";
        NSLog(@"%@",activeView);
    }];
    
    [self hideInfo];
}

- (IBAction)onSignUp:(id)sender
{
     /* Move login and sign up button down */
     [UIView animateWithDuration:0.5f animations:^{
         
         self.viewLogin.frame=btnLogin;
         self.viewSignUp.frame=btnSignUp;
         
         self.loginForm.frame=login_Down;
         self.formSignUp.frame=signUp_Down;
         
     } completion:^(BOOL finished){
         activeView=@"Sign up";
         NSLog(@"%@",activeView);
     }];
    
      [self hideInfo];
}

/* Hide the text info */
- (void)hideInfo
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    
    self.textInfo.alpha = 0.0f;
    
    [UIView commitAnimations];
}


@end
