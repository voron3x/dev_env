--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import System.Exit
import System.IO (hPutStrLn)

import Data.Ratio ((%))

import XMonad.Util.Run(spawnPipe)

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.XPropManage
import XMonad.Hooks.ManageHelpers


import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace

import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Prompt.Shell

import XMonad.Config.Gnome
import XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "mate-terminal"

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["shell","web","ssh","4","5","6","mail","im","full"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#00cc00"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modMask,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch gmrun
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window 
    , ((modMask .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    -- Refresh windows with xrefresh
    , ((modMask,               xK_x     ), spawn "xrefresh")

    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    , ((modMask              , xK_b     ), sendMessage ToggleStruts)

    -- Lauching Google Chrome Web Browser
    , ((modMask .|. shiftMask, xK_b     ), spawn "google-chrome")

    -- Lauching Firefox Web Browser
    , ((modMask .|. shiftMask, xK_f     ), spawn "firefox")

    -- Lauching Opera Web Browser
    , ((modMask .|. shiftMask, xK_o     ), spawn "opera")

    -- Lauching mutt
    , ((modMask .|. shiftMask, xK_m     ), spawn "thunderbird")

    -- Lauching alsamixer
    , ((modMask .|. shiftMask, xK_a     ), spawn "xterm alsamixer")

    -- Lauching wicd-curses
    , ((modMask .|. shiftMask, xK_n     ), spawn "xterm wicd-curses")

    -- Lauching gvim
    , ((modMask .|. shiftMask, xK_g     ), spawn "gvim")

    -- Try to reset black screen after suspend
    , ((modMask .|. shiftMask, xK_BackSpace ), spawn "xrandr --output LVDS1 --auto")
   
    -- Run ssh session
    , ((modMask .|. shiftMask, xK_s), sshPrompt defaultXPConfig)

    -- Run command
    , ((modMask .|. shiftMask, xK_x), shellPrompt defaultXPConfig)

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
defaultLayout = tiled ||| Mirror tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = smartBorders $  Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

bigMasterLayout = tiled ||| Mirror tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = smartBorders $ Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 3/4

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

tabbedLayout = noBorders simpleTabbed

imLayout = withIM (1%3) (roster) chatLayouts
  where
    roster      = ClassName "Pidgin" `And` Role "contact_list" `Or` Title "alex.manaev - Skype™ (Beta)"
    chatLayouts = Grid ||| Full

fullLayout = noBorders Full

myLayout = onWorkspace "ssh" tabbedLayout $
           onWorkspace "mail" bigMasterLayout $
           onWorkspace "im" imLayout $
           onWorkspace "full" fullLayout $
           defaultLayout

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , (role =? "gimp-toolbox" <||> role =? "gimp-image-window") --> (ask >>= doF . W.sink)
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "Firefox"        --> doF (W.shift "web" )
    , className =? "Google-chrome"  --> doF (W.shift "web" )
    , className =? "Qutim"          --> doF (W.shift "im"  )
    , className =? "Skype"          --> doF (W.shift "im"  )
    , className =? "Pidgin"         --> doF (W.shift "im"  )
    , className =? "Gajim.py"       --> doF (W.shift "im"  )
    , className =? "Empathy"        --> doF (W.shift "im"  )
    , className =? "Mail"           --> doF (W.shift "mail")
    , className =? "Thunderbird"    --> doF (W.shift "mail")
    , className =? "Vlc"            --> doF (W.shift "full")
    , isFullscreen                  --> doFullFloat
    ] 
    <+> (xPropManageHook xPropMatches)
  where 
    role         = stringProperty "WM_WINDOW_ROLE"
    xPropMatches = 
      [ ([ (wM_COMMAND, any ("ssh" ==))],  pmP (W.shift "ssh") )
      , ([ (wM_COMMAND, any ("mutt" ==))], pmP (W.shift "mail"))
      ]
 

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
-- myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Command to launch the bar.
--myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what's being written to
-- the bar.
--myPP = xmobarPP { ppTitle = xmobarColor "green" "" . shorten 50 } 

-- Keybinding to toggle the gap for the bar.
-- toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)


-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
myConfig = gnomeConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = avoidStruts $ myLayout ||| layoutHook gnomeConfig,
        manageHook         = myManageHook <+> manageHook gnomeConfig,
        startupHook        = myStartupHook,
        logHook            = logHook gnomeConfig
    }

-- Run xmonad with the settings you specify.
--
--main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
main = xmonad $ ewmh myConfig
