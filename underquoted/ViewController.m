//
//  ViewController.m
//  underquoted
//
//  Created by Jessamyn Smith on 2/8/13.
//  Copyright (c) 2013 Jessamyn Smith. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *quotationTextView;
- (IBAction)GetQuotation:(id)sender;

@end

@implementation ViewController

NSMutableData *receivedData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    NSLog(@"Button Tapped!");
}

- (IBAction)GetQuotation:(id)sender {
    NSString *url = @"https://underquoted.herokuapp.com/api/v1/quotations/?format=json&random=true&limit=1";
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];

    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

    
    if (!theConnection) {
        NSLog(@"Could not get connection");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    NSLog(@"didReceiveResponse");
    
    receivedData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    NSLog(@"trying to append data: %d", [receivedData length]);
    NSLog(@"didReceiveData: %d", [data length]);
    
    [receivedData appendData:data];
    
    NSLog(@"appended data: %d", [receivedData length]);
    
}

- (void)connection:(NSURLConnection *)connection

  didFailWithError:(NSError *)error

{
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:receivedData
                          options:kNilOptions
                          error:&error];
    
    NSArray* objects = [json objectForKey:@"objects"];
    NSDictionary* quotation = [objects objectAtIndex:0];
    NSDictionary* author = [quotation objectForKey:@"author"];
    
    self.quotation = [NSString stringWithFormat:@"%@\n\t- %@", [quotation objectForKey:@"text"], [author objectForKey:@"name"]];
    
    self.quotationTextView.text = self.quotation;
}

@end
