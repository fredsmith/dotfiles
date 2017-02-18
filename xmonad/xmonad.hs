import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.ManageDocks
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Grid
import XMonad.Layout.FixedColumn
import XMonad.Hooks.DynamicLog
import Graphics.X11.ExtraTypes.XF86
import System.IO

myTheme = defaultTheme
	{ activeColor         = blue
	, inactiveColor       = grey
	, activeBorderColor   = blue
	, inactiveBorderColor = grey
	, activeTextColor     = "white"
	, inactiveTextColor   = "black"
	, decoHeight          = 12
	}
	where
		blue = "#4a708b" -- same color used by pager
		grey = "#cccccc"

main = do
     spawnPipe "killall i3status"
     spawnPipe "~/bin/screen_setup"
     spawnPipe "killall trayer; trayer --monitor primary --edge top --align right --width 25 --transparent true --alpha 0 --tint 0 --height 17"
     spawnPipe "killall nm-applet; nm-applet"
     spawnPipe "killall xfce4-volumed; xfce4-volumed"
     spawnPipe "killall xfce4-power-manager; xfce4-power-manager"
     spawnPipe "killall xscreensaver -nosplash; xscreensaver -nosplash"
     spawnPipe "synclient MaxTapTime=0"
     spawnPipe "synclient TouchpadOff=1"
     spawnPipe "setxkbmap -option 'ctrl:nocaps'"
     spawnPipe "nitrogen --restore"
     xmproc <- spawnPipe "i3status -c ~/dotfiles/i3status/config | /usr/bin/xmobar -o -t \"%StdinReader%\" -c \"[Run StdinReader]\" -a right"
     xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , normalBorderColor  = inactiveBorderColor myTheme
        , focusedBorderColor = activeBorderColor myTheme
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys`
	[
		((mod4Mask .|. shiftMask, xK_l), spawn "gnome-screensaver-command -l")
	]
