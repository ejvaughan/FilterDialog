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
    
    [[NSColor colorWithWhite:0.9 alpha:1] set];
    NSRectFill(separatorRect);
}

/* By default, the selection highlight is a light gray when the table view is not the first responder.
   Since our table view will never be the first responder, we override -drawSelectionInRect: to always draw the dark selection highlight.
 */

- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    [[NSColor alternateSelectedControlColor] setFill];
    NSRectFill(dirtyRect);
}

@end
