CedarShortcuts is an Xcode plugin that adds handy shortcuts for [Cedar](https://github.com/pivotal/cedar) or [Quick](https://github.com/quick/quick). 

For example: Cedar and Quick allow you to focus on examples with `fit/fdescribe` but with this plugin you can select `it/describe` with your cursor and use a shortcut instead.

# Installation
* git clone https://github.com/cppforlife/CedarShortcuts.git
* cd CedarShortcuts
* rake install

# Shortcuts

* (This list may or may not be complete)

    <kbd>CTRL</kbd> + <kbd>F</kbd>
    Focus (or unfocus) the 'it', 'describe', or 'context' preceding the cursor.  
    (Edit > Focus spec under cursor)

    <kbd>CTRL</kbd> + <kbd>X</kbd>  
    Pend (or unpend) the 'it', 'describe' or 'context' preceding the cursor.  
    (Edit > Pend spec under cursor)

    <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>I</kbd>  
    Insert `#import` declaration for a symbol under the cursor.  
    (Edit > Insert Import)
    
    <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>C</kbd>  
    Insert `@class` forward-declaration for a symbol under the cursor.  
    (Edit > Forward declare class)

    <kbd>Shift</kbd> + <kbd>Ctrl</kbd> + <kbd>Cmd</kbd> + ↓
    Alternate between Spec and implementation in current editor.  
    (Navigate > Alternate Between Spec)

    <kbd>Shift</kbd> + <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Cmd</kbd> + ↓
    Open alternate (spec or implementation) in adjacent editor.  
    (Navigate > Open Spec/Impl in Adjacent Editor)

    <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>E</kbd>  
    Show list of recently opened files  
    (View > Standard Editor > Show Recent Files)

    <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>U</kbd>  
    Runs example under the cursor in the currently active file.   
    (Product > Run Focused Spec)

    <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Cmd</kbd> + <kbd>U</kbd>  
    Runs the all examples in the currently active file.  
    (Product > Run Focused File)

    <kbd>Shift</kbd> + <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Cmd</kbd> + <kbd>U</kbd>  
    Runs the previously focused example(s).  
    (Product > Run Last Focused Spec(s))

# Changing the keyboard shortcut bindings
You can use the OS X keyboard preferences pane to override shortcut for any menu item (System Preferences > Keyboard > Keyboard Shortcuts > Application Shortcuts > '+').

# Uninstalling the plugin
(Plugin can be uninstalled by removing `CedarShortcuts.xcplugin` from `~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins`)
