//
//  ChooseFlightViewController.m
//  MyFlight2.0
//
//  Created by apple on 12-12-26.
//  Copyright (c) 2012年 LIAN YOU. All rights reserved.
//

#import "ChooseFlightViewController.h"

@interface ChooseFlightViewController ()

@end

@implementation ChooseFlightViewController

@synthesize isQuery;

@synthesize passName;
@synthesize idNo;
@synthesize depCity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) requestForData
{
    NSURL *url = [NSURL URLWithString:@"http://223.202.36.179:9580/web/phone/prod/flight/huet/getCussSegHandler.jsp"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [request setPostValue:self.passName forKey:@"passName"];
    [request setPostValue:self.idNo forKey:@"idNo"];
    [request setPostValue:self.depCity forKey:@"depCity"];
    [request setPostValue:@"1" forKey:@"source"];
    
    [request setCompletionBlock:^(void){
        
        NSData *response = [request responseData];
        
        NSError *error = nil;
        
        [responseDictionary release];
        
        responseDictionary = [[response objectFromJSONDataWithParseOptions:JKSerializeOptionNone error:&error] retain];
        
        if(error != nil)
        {
            NSLog(@"JSON Parse Failed\n");
        }
        else
        {
            NSLog(@"JSON Parse Succeeded\n");
            
            NSDictionary *result = [responseDictionary objectForKey:@"result"];
            
            if([[result objectForKey:@"resultCode"] isEqualToString:@""])
            {
                [passengerInfoTable reloadData];
                [flightInfoTable reloadData];
                for(NSString *string in [responseDictionary allKeys])
                {
                    NSLog(@"%@\n",string);
                }
                for(NSString *string in [responseDictionary allValues])
                {
                    NSLog(@"%@\n",string);
                }
            }
            else
            {
                NSLog(@"%@,%@\n", [result objectForKey:@"resultCode"], [result objectForKey:@"message"]);
            }
        }
    }];
    
    [request setFailedBlock:^(void){
        NSLog(@"JSON Request Failed\n");
    }];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requestForData];
    
    currentSelection = -1;
    
    passengerInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 30, 300, 100) style:UITableViewStylePlain];
    
    passengerInfoTable.delegate = self;
    passengerInfoTable.dataSource = self;
    passengerInfoTable.scrollEnabled = NO;
    
    passengerInfoTable.rowHeight = 50.0f;
    passengerInfoTable.layer.borderColor = [[UIColor grayColor] CGColor];
    passengerInfoTable.layer.borderWidth = 1.0f;
    passengerInfoTable.layer.cornerRadius = 5.0f;
    
    flightInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 160, 300, 210) style:UITableViewStylePlain];
    
    flightInfoTable.delegate = self;
    flightInfoTable.dataSource = self;
    
    flightInfoTable.rowHeight = 70.0f;
    flightInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    flightInfoTable.backgroundColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f];
    
    [self.view addSubview:passengerInfoTable];
    [self.view addSubview:flightInfoTable];
    
    [passengerInfoTable release];
    [flightInfoTable release];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    
    confirm.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height < 500 ? 370:450, 300, 40);
    
    [confirm addTarget:self action:@selector(confirmSelection) forControlEvents:UIControlEventTouchUpInside];
    
    confirm.backgroundColor = [UIColor orangeColor];
    confirm.layer.borderColor = [[UIColor grayColor] CGColor];
    confirm.layer.borderWidth = 1.0f;
    confirm.layer.cornerRadius = 5.0f;
    
    if(isQuery)
    {
        [confirm setTitle:@"查询值机进度" forState:UIControlStateNormal];
    }
    else
    {
        [confirm setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    confirm.titleLabel.font = [UIFont systemFontOfSize:20];
    confirm.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:confirm];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    else
    {
        for(UIView *view in [cell subviews])
        {
            [view removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(tableView == passengerInfoTable)
    {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 17, 48, 16)];
        
        switch (indexPath.row) {
            case 0:
                title.text = @"姓 名";
                break;
            case 1:
                title.text = @"身份证";
                break;
            default:
                break;
        }
        
        title.font = [UIFont systemFontOfSize:16.0f];
        title.textColor = [UIColor colorWithRed:0.1f green:0.4f blue:0.8f alpha:1.0f];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:title];
        [title release];
        
        UILabel *value = [[UILabel alloc]initWithFrame:CGRectMake(100, 17, 190, 16)];
        
        switch (indexPath.row) {
            case 0:
                value.text = self.passName;
                break;
            case 1:
                value.text = self.idNo;
                break;
            default:
                break;
        }
        
        value.font = [UIFont systemFontOfSize:16.0f];
        value.textColor = [UIColor colorWithRed:0.1f green:0.4f blue:0.8f alpha:1.0f];
        value.textAlignment = NSTextAlignmentRight;
        value.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:value];
        [value release];
        
        cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:239/255.0 alpha:1];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *flightInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
        
        flightInfo.backgroundColor = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:239/255.0 alpha:1];
        flightInfo.layer.borderColor = [[UIColor grayColor] CGColor];
        flightInfo.layer.borderWidth = 1.0f;
        flightInfo.layer.cornerRadius = 5.0f;
        
        NSDictionary *flight = [[responseDictionary objectForKey:@"segs"] objectAtIndex:indexPath.row];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 50, 10)];
        
        label.text = [flight objectForKey:@"flightNo"];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        
        [flightInfo addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 50, 10)];
        
        label.text = [NSString stringWithFormat:@"%@舱", [flight objectForKey:@"cabin"]];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        
        [flightInfo addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, 120, 10)];
        
        label.text = [NSString stringWithFormat:@"%@ - %@", [flight objectForKey:@"deCity"], [flight objectForKey:@"arCity"]];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        
        [flightInfo addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, 120, 10)];
        
        label.text = [NSString stringWithFormat:@"票号:%@", [flight objectForKey:@"tktNo"]];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        
        [flightInfo addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(190, 15, 75, 10)];
        
        NSRange range;
        
        range.length = 14;
        range.location = 10;
        
        label.text = [[flight objectForKey:@"takeoffDateTime"] stringByReplacingCharactersInRange:range withString:@""];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        
        [flightInfo addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(190, 35, 75, 10)];
        
        range.length = 10;
        range.location = 0;
        
        label.text = [[flight objectForKey:@"takeoffDateTime"] stringByReplacingCharactersInRange:range withString:@""];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        
        [flightInfo addSubview:label];
        [label release];
        
        UIImageView *selectIcon;
        
        if(indexPath.row == currentSelection)
        {
            selectIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_Selected.png"]];
        }
        else
        {
            selectIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_Default"]];
        }
        
        selectIcon.frame = CGRectMake(270, 20, 20, 20);
        
        [flightInfo addSubview:selectIcon];
        [selectIcon release];
        
        [cell addSubview:flightInfo];
        [flightInfo release];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != passengerInfoTable)
    {
        if(indexPath.row == currentSelection)
        {
            currentSelection = -1;
            [tableView reloadData];
        }
        else
        {
            currentSelection = indexPath.row;
            [tableView reloadData];
        }
    }
}

- (void) confirmSelection
{
    if(currentSelection != -1)
    {
        if([self isQuery])
        {
            FlightInformationViewController *flightInformation = [[FlightInformationViewController alloc] init];
            
            flightInformation.org = [responseDictionary objectForKey:@"departure"];
            flightInformation.passName = self.passName;
            flightInformation.idNo = self.idNo;
            
            [self.navigationController pushViewController:flightInformation animated:YES];
            [flightInformation release];
        }
        else
        {
            NSURL *url = [NSURL URLWithString:@"http://223.202.36.179:9580/web/phone/prod/flight/huet/cussCheckHandler.jsp"];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            [request setRequestMethod:@"POST"];
            [request setDefaultResponseEncoding:NSUTF8StringEncoding];
            
            NSDictionary *segs = [[responseDictionary objectForKey:@"segs"] objectAtIndex:currentSelection];
            
            [request setPostValue:[segs objectForKey:@"tktNo"] forKey:@"tktno"];
            [request setPostValue:self.passName forKey:@"passName"];
            [request setPostValue:self.idNo forKey:@"id"];
            [request setPostValue:[segs objectForKey:@"segIndex"] forKey:@"segIndex"];
            [request setPostValue:@"1" forKey:@"source"];
            
            [request setCompletionBlock:^(void){
                
                NSData *response = [request responseData];
                
                NSError *error = nil;
                
                NSDictionary *responseDict = [response objectFromJSONDataWithParseOptions:JKSerializeOptionNone error:&error];
                
                if(error != nil)
                {
                    NSLog(@"JSON Parse Failed\n");
                }
                else
                {
                    NSLog(@"JSON Parse Succeeded\n");
                    
                    NSDictionary *result = [responseDict objectForKey:@"result"];
                    
                    if([[result objectForKey:@"resultCode"] isEqualToString:@""])
                    {
                        for(NSString *string in [responseDict allKeys])
                        {
                            NSLog(@"%@\n",string);
                        }
                        for(NSString *string in [responseDict allValues])
                        {
                            NSLog(@"%@\n",string);
                        }
                        
                        PickSeatViewController *pickSeat = [[PickSeatViewController alloc] init];
                        
                        pickSeat.tktno = [responseDict objectForKey:@"tktNo"];
                        pickSeat.segIndex = [responseDict objectForKey:@"segIndex"];
                        pickSeat.passName = [responseDict objectForKey:@"passName"];
                        pickSeat.airline = [responseDict objectForKey:@"airline"];
                        pickSeat.orgId = [responseDict objectForKey:@"orgId"];
                        pickSeat.org = [responseDict objectForKey:@"org"];
                        pickSeat.symbols = [responseDict objectForKey:@"symbols"];
                        
                        
                        [self.navigationController pushViewController:pickSeat animated:YES];
                        [pickSeat release];
                    }
                    else
                    {
                        NSLog(@"%@,%@\n", [result objectForKey:@"resultCode"], [result objectForKey:@"message"]);
                        // information incorrect
                    }
                }
            }];
            
            [request setFailedBlock:^(void){
                NSLog(@"JSON Request Failed\n");
            }];
            
            [request setDelegate:self];
            [request startAsynchronous];
        }
    }
    else
    {
        // error : must pick a flight
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == passengerInfoTable)
    {
        return 2;
    }
    else
    {
        return [[responseDictionary objectForKey:@"segs"] count];
    }
}

- (void) dealloc
{
    [responseDictionary release];
    
    [super dealloc];
}

@end
