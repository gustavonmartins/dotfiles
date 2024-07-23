;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu))
(use-service-modules cups desktop networking ssh xorg syncthing pm mail linux)

(operating-system
  (locale "en_GB.utf8")
  (timezone "Europe/Berlin")
  (keyboard-layout (keyboard-layout "de,us"))
  (host-name "guguix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "gustavo")
                  (comment "Gustavo")
                  (group "users")
                  (home-directory "/home/gustavo")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (map specification->package '(
						  "gparted"
						  "openbox" "awesome" "fluxbox" "fvwm" "icewm"
						  "tar" "atool" "unzip" "pigz"
						  "picom" "rofi" "tint2"
						  "ncurses" "xsettingsd"
						  "openssh" "sshfs" "gvfs"
						  "curl" "uget"
						  "git" 
						  "libtree"
						  "neovim" "guile-studio" "gedit" "geany" "pandoc" "apostrophe" "kate" 
						  "calibre" "evince" "qpdfview" "mupdf" "zathura" "xpdf" "gv"
						  "abiword" "gnumeric" "qalculate-gtk"
						  "gthumb" "shotwell"
						  "skim" "fzf" "ripgrep"
						  "stow"
						  "keepassxc"
						  "xterm" "rxvt-unicode" "xclip" "setxkbmap"
						  "htop" "net-tools" "dstat" "lsof"
						  "librewolf" "lynx" "ungoogled-chromium" "ublock-origin-chromium" 
						  "claws-mail" "mutt"
						  "mpv" "smplayer" "yt-dlp"
						  "gajim" "gajim-omemo" "hexchat"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service xfce-desktop-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout)))
		 (service syncthing-service-type
		  (syncthing-configuration
		   (user "gustavo")))
		 (service tlp-service-type)
		 (service radicale-service-type)
		 (service zram-device-service-type 		; compressed ram.
			(zram-device-configuration
               (size "6G") 						; this is double the amount of ram plus 1-2 gb
               (compression-algorithm 'zstd) 	; very fast, wont steal much of CPU
               (priority 32767) 				; maximum priority. so everything goes here.
             ))
          (service earlyoom-service-type) 		; to not make the computer unresponsive when out of ram.
		 
		 )

           ;; This is the default list of services we
           ;; are appending to.
           %desktop-services))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "2a9227da-5328-45cc-bf9c-0f0e80814281")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/home")
                         (device (file-system-label "GUIXHOME"))
                         (type "ext4"))
                       (file-system
                         (mount-point "/")
                         (device (file-system-label "GUIXROOT"))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "3DD8-190A"
                                       'fat16))
                         (type "vfat")) %base-file-systems)))
