//
//  SearchView.m
//  EatApp
//
//  Created by Michel Balamou on 2016-02-28.
//  Copyright © 2016 EatApp. All rights reserved.
//

#import "SearchView.h"
#define rgba(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];

@interface SearchView ()

@end

@implementation SearchView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchQuery.delegate=self;
    self.searchOutput.delegate=self;
    self.searchOutput.dataSource=self;
    
    self.historyOutput.delegate=self;
    self.historyOutput.dataSource=self;
    
    initY=self.searchQuery.frame.origin.y; //height constant
    intiHeight=self.DecorView.frame.size.height;
    
    /*
     ADD CLEAR VIEW BUTTON
     */
    UIImage* img=[UIImage imageNamed:@"clear.png"];
    
    UIButton* clearButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:img forState:UIControlStateNormal];
    [clearButton setFrame:CGRectMake(0, 0, 31, 28)];
    [clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchQuery.rightViewMode=UITextFieldViewModeNever;
    [self.searchQuery setRightView:clearButton];
    
    resultsFinalized=false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Clicking enter on the textField
 */
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if ([[textField text] length]>0)
    {
        [self addToHistory:textField.text];
        [self.historyOutput setHidden:true];
        
        //Hide keyboard
        [textField resignFirstResponder];
        
        float topOffset=30;
        float bottomOffset=1;
        
        CGRect frm=self.DecorView.frame;
        frm.size.height=topOffset+self.searchQuery.frame.size.height+bottomOffset;
        
        
        CGRect searchFrame=self.searchQuery.frame;
        searchFrame.origin.y=topOffset;
        
        
    /* Move textfield up */
    [UIView animateWithDuration:1.0f animations:^{
        self.searchOutput.center=CGPointMake(self.searchOutput.center.x,topOffset+self.searchQuery.frame.size.height+bottomOffset+self.searchOutput.frame.size.height/2);
        self.searchQuery.frame=searchFrame;
        
        self.DecorView.backgroundColor=rgba(239,239,244); //back to gray
        self.DecorView.frame=frm;
    }
    completion:^(BOOL done)
     {
         if (resultsFinalized==false)
         {
             [self.loadingView setHidden:false];
         }
     }];
    
    /* Hide the logo */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    
    self.logoImage.alpha = 0.0f;
    
    [UIView commitAnimations];
    
        /* Send request */
        [self sendSearchRequest:textField.text];
        
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return NO;
}


- (void)clearTextField:(id)sender
{
    if ([self.searchQuery.text length]>0)
    {
        self.searchQuery.text=@"";
        
        //Clear
        product_name=[NSMutableArray new];
        prices=[NSMutableArray new];
        images=[NSMutableArray new];
        distances=[NSMutableArray new];
        restaurant_name=[NSMutableArray new];
        
        [self.searchOutput reloadData];
        
        /* Move NotFound down */
        [UIView animateWithDuration:1.0f animations:^{
        self.notFound.center=CGPointMake(self.notFound.center.x,self.view.frame.size.height+self.notFound.frame.size.height/2);
        }];
        
        
        [self.historyOutput setHidden:false];
        searchHistory=[[self retriveHistory] subarrayWithRange:NSMakeRange(0, 10)];
        [self.historyOutput reloadData];
        
        [self.loadingView setHidden:true];
    }
    else
    {
    [self.historyOutput setHidden:true];
        
    //Hide keyboard
    [self.searchQuery resignFirstResponder];
    
    CGRect frm=self.DecorView.frame;
    frm.size.height=intiHeight;

    CGRect searchFrame=self.searchQuery.frame;
    searchFrame.origin.y=initY;
    
    /* Move textfield down */
    [UIView animateWithDuration:1.0f animations:^{
        self.searchOutput.center=CGPointMake(self.searchOutput.center.x,self.view.frame.size.height+self.searchOutput.frame.size.height/2);
        self.searchQuery.frame=searchFrame;
        
        self.DecorView.backgroundColor=rgba(255,153,102); //back to orange
        self.DecorView.frame=frm;

        self.notFound.center=CGPointMake(self.notFound.center.x,self.view.frame.size.height+self.notFound.frame.size.height/2);
    } ];
    
    /* Show the logo */
    [UIView animateWithDuration:0.5f animations:^{
              self.logoImage.alpha = 1.0f;
        }];
        
        self.searchQuery.text=@"";
        self.searchQuery.rightViewMode=UITextFieldViewModeNever;
    

        
        [self.loadingView setHidden:true];
    }
}


/*
 Hide keyboard when not touched
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]])
    {
        [touch.view endEditing:YES];
    }
}

#pragma mark - Connect
/*
 Send search request to server
 */
- (void)sendSearchRequest:(NSString*)search
{
    resultsFinalized=false;
    NSString* post=[NSString stringWithFormat:@"search_query=%@&longitude_app=%@&latitude_app=%@&device=iOS",search,longitude,latitude];
    NSData* postData=[post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString* postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.eatapp.ca/search/js/retrieve_search.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn)
    {
        NSLog(@"Connection Successful");
    }
    else
    {
        NSLog(@"Connection could not be made");
    }
}


/* 
 Fill arrays with incoming data from the server
*/
 - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    [self.loadingView setHidden:true];
    
    NSError* error=nil;
    NSDictionary* jsonArray=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil)
    {
        NSLog(@"Error parsing JSON.");
    }
    else
    {
        resultsFinalized=true;
        
        if (![jsonArray[@"results"] isEqualToString:@"0"])
        {
            [UIView animateWithDuration:0.5f animations:^{
                self.notFound.center=CGPointMake(self.notFound.center.x,self.view.frame.size.height+self.notFound.frame.size.height/2);
            }];
            
            NSDictionary* currentArray;
        
            product_name=[NSMutableArray new];
            prices=[NSMutableArray new];
            images=[NSMutableArray new];
            distances=[NSMutableArray new];
            restaurant_name=[NSMutableArray new];
        
            for (int i=0;i<[jsonArray[@"data"] count];i++)
            {
                currentArray=jsonArray[@"data"][i];
            
                [product_name addObject:currentArray[@"product_name"]];
                [prices addObject:currentArray[@"price"]];
                [images addObject:currentArray[@"image"]];
                [distances addObject:currentArray[@"distance"]];
                [restaurant_name addObject:currentArray[@"restaurant_name"]];
            }
        }
        else
        {
            [UIView animateWithDuration:1.0f animations:^{
            self.notFound.center=CGPointMake(self.notFound.center.x,30+self.searchQuery.frame.size.height+1+self.notFound.frame.size.height/2);
            }];
        }
        
        [self.searchOutput reloadData];
    }
}
#pragma mark - SearchTable
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.searchOutput)
    {
        return [product_name count];
    }
    else
        if (tableView==self.historyOutput)
        {
            return [searchHistory count];
        }
        else
        {
            return 0;
        }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.searchOutput)
    {
        ProductCell* cell=[tableView dequeueReusableCellWithIdentifier:@"displayCell"];
    
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"displayCell"];
            cell=[tableView dequeueReusableCellWithIdentifier:@"displayCell"];
        }
        
        return cell;
    }
    else
        if (tableView==self.historyOutput)
        {
            HistoryCell* cell=[tableView dequeueReusableCellWithIdentifier:@"histCell"];
            
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:nil] forCellReuseIdentifier:@"histCell"];
                cell=[tableView dequeueReusableCellWithIdentifier:@"histCell"];
            }
            
            return cell;
        }
    else
    {
        return nil;
    }
}

/*
 Style the search output contents
 */
- (void)tableView:(UITableView*)tableView willDisplayCell:(id)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView==self.searchOutput)
    {
    ProductCell* protoCell=(ProductCell*)cell;
    protoCell.productName.text=[product_name objectAtIndex:indexPath.row];
    [protoCell.productName sizeToFit];
    
    protoCell.price.text=[NSString stringWithFormat:@"$%@",[prices objectAtIndex:indexPath.row]];
    [protoCell.price sizeToFit];
    
    /* LOAD FOOD IMAGES */
    NSURL* url=[NSURL URLWithString:[images objectAtIndex:indexPath.row]];
    
    NSURLSessionTask *task=[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                            {
                                if (data)
                                {
                                    UIImage* image=[UIImage imageWithData:data];
                                    if (image)
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            ProductCell* updateCell=(id)[tableView cellForRowAtIndexPath:indexPath];
                                            if (updateCell)
                                                
                                            {
                                                protoCell.product_image.image=image;
                                                protoCell.product_image.layer.cornerRadius=30;
                                                protoCell.product_image.layer.masksToBounds=YES;
                                            }
                                        });
                                    }
                                }
                            }];
    [task resume];
    }
    else
         if (tableView==self.historyOutput)
         {
             HistoryCell* protoCell=(HistoryCell*)cell;
             protoCell.historyTxt.text=[searchHistory objectAtIndex:indexPath.row];
             
         }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return NO;
}


/*
 History
 */
- (void)addToHistory:(NSString*)search
{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray* history=[NSMutableArray arrayWithArray:[defaults objectForKey:@"history"]];
    
    if (history==nil)
    {
        history=[NSMutableArray new];
    }
    
    [history addObject:search];
    
    [defaults setObject:history forKey:@"history"];
}

- (NSArray*)retriveHistory
{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:@"history"];
}
@end
