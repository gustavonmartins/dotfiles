import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
    ( xF86XK_AudioLowerVolume
    , xF86XK_AudioRaiseVolume
    )
import Numeric
import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Config.Desktop
import XMonad.Core
import XMonad.Hooks.DynamicBars
import XMonad.Hooks.DynamicLog
import qualified XMonad.Hooks.ManageDocks as Docks
import XMonad.Layout
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ThreeColumns
import XMonad.StackSet
import qualified XMonad.StackSet as SS
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
    , ((modMask, xK_p), spawn "rofi -combi-modi window,drun -show combi")
    , ((0, xF86XK_AudioLowerVolume), mkTerm)
      --take a screenshot of focused window
    , ((modMask, xK_b), sendMessage Docks.ToggleStruts)
    ] ++
      -- Do not swap workspaces in multi-monitor mode
    [ ((modMask .|. m, k), windows $ f i)
    | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
    , (f, m) <- [(SS.view, 0), (SS.shift, shiftMask)]
    ]

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
    spawnOnce "redshift-gtk"
    dynStatusBarStartup spawnBar killAllBars

statusBarEventHook = dynStatusBarEventHook spawnBar killAllBars

{- END Status Bar Config -}
myLogHook = multiPP myStatusBarPP myStatusBarPP

myConfig =
    Docks.docks $
    XMonad.Config.Desktop.desktopConfig
        { terminal = "alacritty"
        , modMask = mod4Mask
        , keys = myKeys
        , focusFollowsMouse = False
        , startupHook = myStartupHook
        , handleEventHook = statusBarEventHook
        , logHook = myLogHook
        , layoutHook =
              (Docks.avoidStruts . smartBorders) $
              (Mirror (ThreeCol 1 (3 / 100) (1 / 2)) |||
               ThreeCol 1 (3 / 100) (1 / 2) ||| Full)
        }

main = xmonad myConfig
