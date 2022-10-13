import Control.Monad
import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
    ( xF86XK_AudioLowerVolume
    , xF86XK_AudioRaiseVolume
    , xF86XK_MonBrightnessDown
    , xF86XK_MonBrightnessUp
    )
import Numeric
import System.Exit
import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Config.Desktop
import XMonad.Core
import XMonad.Hooks.DynamicBars
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import qualified XMonad.Hooks.ManageDocks as Docks
import XMonad.Layout
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.ThreeColumns
import XMonad.StackSet
import qualified XMonad.StackSet as SS
import XMonad.Util.Dmenu
import qualified XMonad.Util.Run as Run
import XMonad.Util.SpawnOnce (spawnOnce)

{- BEGIN Keyboard Config -}
myWorkspaces = (: []) <$> ['1' .. '9']

mkTerm = withWindowSet launchTerminal
  where
    launchTerminal ws =
        case peek ws of
            Nothing -> Run.runInTerm "" "$SHELL"
            Just xid -> terminalInCwd xid
    terminalInCwd xid =
        let hex = showHex xid " "
            shInCwd =
                "'cd $(readlink /proc/$(ps --ppid $(xprop -id 0x" ++
                hex ++
                "_NET_WM_PID | cut -d\" \" -f3) -o pid= | tr -d \" \")/cwd) && $SHELL'"
         in Run.runInTerm "" $ "sh -c " ++ shInCwd

keyOverrides conf@(XConfig {XMonad.modMask = modMask}) =
    M.fromList $ -- Screenshot key bindings
  --take a screenshot of entire display
    [ ((0, xK_Print), spawn "flameshot gui")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 10%+")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 10%-")
    , ((0, xF86XK_MonBrightnessUp), spawn "lux -a 10%")
    , ((0, xF86XK_MonBrightnessDown), spawn "lux -s 10%")
    , ( (modMask, xK_p)
      , spawn
            "rofi -combi-modi window,drun -show combi -matching fuzzy -sort -sorting-method fzf -theme solarized_alternate")
    , ((modMask, xK_Return), mkTerm)
    , ( (mod4Mask .|. shiftMask, xK_q)
      , confirm "Confirm logout?" $ io (exitWith ExitSuccess))
    , ((mod4Mask .|. shiftMask, xK_Return), mkTerm)
      --take a screenshot of focused window
    , ((modMask, xK_b), sendMessage Docks.ToggleStruts)
    ] ++
      -- Do not swap workspaces in multi-monitor mode
    [ ((modMask .|. m, k), windows $ f i)
    | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
    , (f, m) <- [(SS.view, 0), (SS.shift, shiftMask)]
    ]
  where
    confirm :: String -> X () -> X ()
    confirm msg f = do
        result <- dmenu [msg, "y", "n"]
        when (result == "y") f

myKeys =
    \c -> M.union (keyOverrides c) (keys XMonad.Config.Desktop.desktopConfig c)

{- END Keyboard Config -}
{- BEGIN Status Bar Config -}
myStatusBarPP = xmobarPP {ppCurrent = xmobarColor "#429942" "" . wrap "<" ">"}

spawnBar screenId = Run.spawnPipe $ "xmobar -x " ++ screenNum
  where
    screenNum = last (words $ show screenId)

killAllBars = Run.safeSpawn "killall" ["-9", "xmobar"]

myStartupHook = do
    spawnOnce "redshift-gtk &"
    spawnOnce "nitrogen --restore &"
    spawnOnce
        "trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --widthtype percent --width 10 --transparent true --alpha 0 --tint 0x800080 &"
    spawnOnce "nm-applet &"
    spawnOnce "volumeicon &"
    spawnOnce "fcitx -d &"
    dynStatusBarStartup spawnBar killAllBars

statusBarEventHook = dynStatusBarEventHook spawnBar killAllBars

{- END Status Bar Config -}
myLogHook :: X ()
myLogHook = multiPP myStatusBarPP myStatusBarPP

myConfig =
    Docks.docks $
    XMonad.Config.Desktop.desktopConfig
        { terminal = "alacritty"
        , focusedBorderColor = "#429942"
        , borderWidth =  3
        , normalBorderColor = "#000000"
        , modMask = mod4Mask
        , keys = myKeys
        , focusFollowsMouse = False
        , startupHook = myStartupHook
        , handleEventHook = statusBarEventHook
        , logHook = myLogHook
        , manageHook = insertPosition Above Newer
        , layoutHook =
              (smartBorders) $
           --  ThreeCol 1 (3 / 100) (1 / 2) |||
              (Docks.avoidStruts (Tall 1 (3 / 100) (1 / 2))) |||
              (Docks.avoidStruts (Mirror (ThreeCol 1 (3 / 100) (1 / 2))) |||
               Full ||| (Docks.avoidStruts (Mirror (Tall 1 (3 / 100) (1 / 2)))))
        }

main = (xmonad . ewmh) myConfig
