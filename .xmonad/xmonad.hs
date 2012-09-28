import XMonad hiding (Tall)
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Layout.Tabbed
import XMonad.Layout.HintedTile
import XMonad.Util.EZConfig
import XMonad.Util.Dmenu
import XMonad.Util.Dzen
import XMonad.Util.Run

import System.IO
import System.Exit
import Control.Monad
import Data.List

-- Use dmenu to ask for confirmation on quit
quitWithWarning :: X ()
quitWithWarning = do
    let m = "confirm quit"
    s <- dmenu [m]
    when (m == s) (io exitSuccess)

myTerminal = "gnome-terminal"
myFont = "-fn '-*-terminus-*-*-*-*-16-*-*-*-*-*-*-*'"

dmenuCommand = "`dmenu_path | dmenu -nb '#000000' -nf '#ffffff' " ++
    myFont ++ " -b` && exec $exe"

myStatusBar = "dzen2 -p -x '0' -y '0' -h '24' -w '1100' -ta 'l' " ++
    myFont ++ " -fg '#FFFFFF' -bg black"

ws1 = "1:dev"
ws2 = "2:sh"
ws3 = "3:web"
ws4 = "4:comm"
ws5 = "5:other"

myWorkspaces = [ws1, ws2, ws3, ws4, ws5]

-- Use xprop to gather window properties
myManageHook = composeAll . concat $
    [
        [ className =? w --> doShift ws1 | w <- myWs1Shifts]
      , [ className =? w --> doShift ws2 | w <- myWs2Shifts]
      , [ className =? w --> doShift ws3 | w <- myWs3Shifts]
      , [ className =? w --> doShift ws4 | w <- myWs4Shifts]
      , [ className =? c --> doFloat | c <- myClassFloats]
      , [ fmap ( t `isInfixOf`) title --> doFloat | t <- myTitleFloats ]
    ]
    where
       myWs1Shifts   = ["Eclipse", "Idea"]
       myWs2Shifts   = ["gnome-terminal"]
       myWs3Shifts   = ["Firefox", "Google-chrome"]
       myWs4Shifts   = ["GroupWise", "xchat"]
       myClassFloats = []
       myTitleFloats = ["Mail From", "Mail To"]

-- Bind log hooks to dzen
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#3EB5FF" "black" . pad
      , ppVisible           =   dzenColor "white" "black" . pad
      , ppHidden            =   dzenColor "white" "black" . pad
      , ppHiddenNoWindows   =   dzenColor "#444444" "black" . pad
      , ppUrgent            =   dzenColor "red" "black" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppTitle             =   (" " ++) . dzenColor "white" "black" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }

-- EZConfig additionalKeys
myKeys = [
        ("M-p", spawn dmenuCommand)
      , ("M-S-q", quitWithWarning)
      , ("M-g", goToSelected defaultGSConfig)
      , ("M-S-l", spawn "gnome-screensaver-command --lock")
      , ("M-<R>", nextWS)
      , ("M-<L>", prevWS)
      , ("M-<U>", swapNextScreen)
      , ("M-<D>", swapPrevScreen)]

myLayout = hintedTile Tall ||| hintedTile Wide ||| simpleTabbed
  where
     hintedTile = HintedTile nmaster delta ratio TopLeft
     nmaster    = 1
     ratio      = 1/2
     delta      = 3/100

main = do
    workspaceBar <- spawnPipe myStatusBar
    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig {
          terminal           = myTerminal
        , focusFollowsMouse  = False
        , borderWidth        = 1
        -- "windows key" is usually mod4Mask.
        , modMask            = mod4Mask
        , workspaces         = myWorkspaces
        , layoutHook         = avoidStruts $ myLayout
        , manageHook         = manageDocks <+> myManageHook
        , logHook            = myLogHook workspaceBar >>
                               fadeInactiveLogHook 0xdddddddd  >> 
                               -- Fixes issues with java swing applications
                               takeTopFocus >> setWMName "LG3D"
} `additionalKeysP` myKeys
