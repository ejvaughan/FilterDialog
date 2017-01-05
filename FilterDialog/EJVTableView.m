//
//  EVTableView.m
//  SearchTab
//
//  Created by Ethan Vaughan on 12/16/14.
//  Copyright (c) 2014 Ethan James Vaughan. All rights reserved.
//

#import "EJVTableView.h"

@implementation EJVTableView

// Override -acceptsFirstResponder to refuse first responder status (the search field should always be the first responder).

- (BOOL)acceptsFirstResponder
{
    return NO;
}

@end
