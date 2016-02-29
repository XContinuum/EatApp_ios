//
//  UserSettings.h
//  EatApp
//
//  Created by Michel Balamou on 2016-02-28.
//  Copyright © 2016 EatApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSettings : UIViewController
{
    NSString* activeView;
    
    CGRect specialLogin;
    
    CGRect btnSignUp;
    CGRect btnLogin;
    CGRect btnSignUp_initial;
    
    CGRect loginUp;
    CGRect signUp_Up;
    
    CGRect login_Down;
    CGRect signUp_Down;
}
@property (strong, nonatomic) IBOutlet UIView *viewLogin; // Login button
@property (strong, nonatomic) IBOutlet UIView *viewSignUp; // Signup button

// FORMS
@property (strong, nonatomic) IBOutlet UIView *loginForm;
@property (strong, nonatomic) IBOutlet UIView *formSignUp;


@property (strong, nonatomic) IBOutlet UIView *decorView;
@property (strong, nonatomic) IBOutlet UILabel *textInfo;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)print:(float)num;

- (IBAction)onLogin:(id)sender;
- (IBAction)onSignUp:(id)sender;
@end
