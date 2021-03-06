//
//  EVSearchPanel.m
//  SwitchTunes
//
//  Created by Ethan Vaughan on 12/12/13.
//  Copyright (c) 2013 Ethan James Vaughan. All rights reserved.
//

#import "EJVSearchPanel.h"
#import "EJVFilterListWindowController.h"

@implementation EJVSearchPanel

// Override the designated intializer to make the window transparent. This allows the rounded corners of the content view to be seen.

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    
    if (self) {
        self.backgroundColor = [NSColor clearColor];
    }
    
    return self;
}

// Override -setContentView: to round the corners of the window's content view

- (void)setContentView:(NSView *)aView
{
    aView.wantsLayer            = YES;
    aView.layer.frame           = aView.frame;
    aView.layer.cornerRadius    = 6.0;
    aView.layer.masksToBounds   = YES;
    aView.layer.backgroundColor = [NSColor windowBackgroundColor].CGColor;
    
    [super setContentView:aView];
}

/* NSWindow -canBecomeKeyWindow must be overridden to return YES because the panel is borderless,
   which normally prevents the window from becoming key.
 */

- (BOOL)canBecomeKeyWindow
{
    return YES;
}
    
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if (menuItem.action == @selector(performClose:)) {
        if ([((EJVFilterListWindowController *)self.windowController).delegate respondsToSelector:@selector(filterListWindowControllerHandleCloseAction:)]) {
            return YES;
        }
    }
    
    return [super validateMenuItem:menuItem];
}

- (void)performClose:(id)sender
{
    EJVFilterListWindowController *controller = (EJVFilterListWindowController *)self.windowController;
    [controller.delegate filterListWindowControllerHandleCloseAction:controller];
}

@end
