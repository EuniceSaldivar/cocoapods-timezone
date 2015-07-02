//
//  ViewController.m
//  notif
//
//  Created by Eunice Saldivar on 6/24/15.
//  Copyright (c) 2015 jumpdigital. All rights reserved.
//

#import "ViewController.h"
#import "TimezoneAPIClient.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *zones;
    NSArray *tZones;
    NSIndexPath *selectedRow;
    UIButton *button;
    BOOL twice;
    NSInteger num;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    zones = [NSArray arrayWithObjects:@"Argentina", @"Australia", @"Brazil", @"Canada", @"France", @"Germany", @"Italy", @"Netherlands", @"Phlippines", @"Spain", @"United States - LA", @"Yemen", nil];
    tZones = [NSArray arrayWithObjects:@"America/Argentina/Mendoza", @"Australia/Melbourne", @"America/Fortaleza", @"America/Vancouver", @"Europe/Paris", @"Europe/Berlin", @"Europe/Rome", @"Europe/Amsterdam", @"Asia/Manila", @"Europe/Madrid", @"America/Los_Angeles", @"Asia/Aden", nil];
    twice = NO;
    //num = (sizeof(zones));
    num = 20;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [zones count];
}

//added
-(BOOL)tableView:(UITableView *)tableView canCollapse:(NSIndexPath *)indexpath
{
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableID = @"tableSites";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableID];
    }
    
    cell.textLabel.text = [zones objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Zone Name:\n%@",[tZones objectAtIndex:indexPath.row]];
    cell.detailTextLabel.hidden = YES;
    cell.detailTextLabel.numberOfLines = 2;
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.clipsToBounds = YES;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



-(void)buttonPressed:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:senderButton.tag inSection:0];
//    NSString *notif = [zones objectAtIndex:path.row];
    
    TimezoneAPIClient *client = [TimezoneAPIClient sharedClient];
    //NSLog(@"%@", [zones objectAtIndex:path.row]);
    [client getTimeForZone:[NSString stringWithFormat:@"%@", [tZones objectAtIndex:path.row]]
                   success:^(NSURLSessionDataTask *task, id responseObject) {
                       //NSLog(@"Success -- %@", responseObject);
                       
                       //NSDictionary *jsonDictionary = [parser objectWithString:responseObject error:nil];
                       NSString *epoch = [responseObject objectForKey:@"timestamp"];
                       
                       NSDate *date = [NSDate dateWithTimeIntervalSince1970:[epoch doubleValue]];
                       //NSLog(@"EPO: %@ TIME! %@", epoch, date);
                       
                       
                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Time Retrieved: %@", [zones objectAtIndex:path.row]]
                                                                           message:[NSString stringWithFormat:@"%@", date] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                       [alertView show];
                       
                   }
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                       NSLog(@"Failure -- %@", error);
                       
                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Timezone" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                       [alertView show];
                       
                   }];

   /*
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join" message:[NSString stringWithFormat:@"%@", notif] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //checking
    NSLog(@"num: %lu row:%lu", num, indexPath.row);
    
    //tapped twice
    if(num == indexPath.row)
        twice = YES;
    
    if(!twice){
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        self->selectedRow = indexPath;
        [tableView beginUpdates];
        cell.detailTextLabel.hidden = NO;
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = indexPath.row;
        num = indexPath.row;
        button.frame = CGRectMake(210.0f, 40.0f, 100.0f, 30.0f);
        [button setTitle:@"Check Time" forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [tableView endUpdates];
    }
    else{
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [tableView beginUpdates];
        cell.detailTextLabel.hidden = YES;
        //    if([[self.view.subviews objectAtIndex:indexPath.row] isKindOfClass:[UIButton class]]){
        //        [[self.view.subviews objectAtIndex:indexPath.row] removeFromSuperview];
        //    }
        if([[cell.contentView viewWithTag:indexPath.row] isKindOfClass:[UIButton class]]){
            [[cell.contentView viewWithTag:indexPath.row] removeFromSuperview];
        }
        [tableView endUpdates];
        twice = NO;
        //num = (sizeof(zones));
        num = 20;

    }

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView beginUpdates];
    cell.detailTextLabel.hidden = YES;
//    if([[self.view.subviews objectAtIndex:indexPath.row] isKindOfClass:[UIButton class]]){
//        [[self.view.subviews objectAtIndex:indexPath.row] removeFromSuperview];
//    }
    if([[cell.contentView viewWithTag:indexPath.row] isKindOfClass:[UIButton class]]){
        [[cell.contentView viewWithTag:indexPath.row] removeFromSuperview];

    }    [tableView endUpdates];

}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(twice == YES){
        return 50;
    }
    else if(selectedRow && indexPath.row == selectedRow.row){
        return 100;
    }
    return 50;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
