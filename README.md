CedarShortcuts is an Xcode 4 plugin that adds handy shortcuts for Cedar to the Xcode menus.  For example: Cedar allows you to focus on examples with `fit/fdescribe` but with this plugin you can select `it/describe`
with your cursor and use a shortcut instead.

You can use OS X keyboard preferences to override the shortcut for any menu item.

* Running focused examples (Product Menu):

  ```text
  Ctrl + Alt + U                  Runs example under the cursor in the currently active file
  Ctrl + Alt + Cmd + U            Runs the all examples in the currently active file
  Shift + Ctrl + Alt + Cmd + U    Runs the previously focused example(s)
  ```

* Opening alternate file (File Menu):

  ```text
  Shift + Ctrl + Cmd + DownArrow          Alternate between Spec and implementation in current editor
  Shift + Ctrl + Alt + Cmd + DownArrow    Open alternate (spec or implementation) in adjacent editor
  ```

* Install by building this project

(Plugin can be uninstalled by removing `CedarShortcuts.xcplugin` from
`~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins`)