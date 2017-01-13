//
//  EVTableRowView.m
//  SwitchTunes
//
//  Created by Ethan Vaughan on 12/12/13.
//  Copyright (c) 2013 Ethan James Vaughan. All rights reserved.
//

#import "EJVTableRowView.h"

@implementation EJVTableRowView

- (NSBackgroundStyle)interiorBackgroundStyle
{
    return (self.isSelected) ? NSBackgroundStyleDark : NSBackgroundStyleLight;
}

// Draw a nice separator

- (void)drawSeparatorInRect:(NSRect)dirtyRect
{
    NSRect separatorRect;
    separatorRect.size.width = self.bounds.size.width - 20;
    separatorRect.origin.x = 10;
    separatorRect.origin.y = NSMaxY(self.bounds) - 1;
    separatorRect.size.height = 1;
    
    [[NSColor quaternaryLabelColor] set];
    NSRectFill(separatorRect);
}

@end
