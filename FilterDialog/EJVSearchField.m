//
//  EVSearchField.m
//  SearchTab
//
//  Created by Ethan Vaughan on 12/16/14.
//  Copyright (c) 2014 Ethan James Vaughan. All rights reserved.
//

#import "EJVSearchField.h"

@implementation EJVSearchField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSSearchFieldCell *cell = self.cell;
    cell.cancelButtonCell.target = self;
    cell.cancelButtonCell.action = @selector(cancelButtonPressed:);
}

- (void)cancelButtonPressed:(id)sender
{
    // Clear input without resigning first responder
    
    self.stringValue = @"";
    [self sendAction:self.action to:self.target];
}

@end
