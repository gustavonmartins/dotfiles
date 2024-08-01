;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu) (nongnu system linux-initrd))
(use-service-modules desktop networking ssh xorg syncthing pm mail linux security virtualization)
(use-package-modules package-management)

(operating-system
 (initrd microcode-initrd) ; nonfree, to prevent security exploits
 (locale "en_GB.utf8")
 (timezone "Europe/Berlin")
 (keyboard-layout (keyboard-layout "de,us"))
 (host-name "guguix")

 ;; The list of user accounts ('root' is implicit).
 (users
  (cons* (user-account
          (name "gustavo")
          (comment "Gustavo")
          (group "users")
          (home-directory "/home/gustavo")
          (supplementary-groups '("wheel" "netdev" "audio" "video"
									"libvirt")))
         %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 (packages
  (append (map specification->package '(
					"setxkbmap" "xterm" 
					))
          %base-packages))

 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (append (list
           (service xfce-desktop-service-type)
           (set-xorg-configuration
            (xorg-configuration (keyboard-layout keyboard-layout)))
           (service openssh-service-type
                    (openssh-configuration (max-connections 0)))
	   (service syncthing-service-type
	            (syncthing-configuration
		     (user "gustavo")))
	   (service tlp-service-type
                    (tlp-configuration
                     (tlp-default-mode "BAT")))
                                        ;(service radicale-service-type)
	   (service zram-device-service-type 		; compressed ram.
		    (zram-device-configuration
                     (size "6G") 						; this is double the amount of ram plus 1-2 gb
                     (compression-algorithm 'zstd) 	; very fast, wont steal much of CPU
                     (priority 32767) 				; maximum priority. so everything goes here.
                     ))
           (service earlyoom-service-type) 		; to not make the computer unresponsive when out of ram.
           ;(fail2ban-service-type)
           (service nftables-service-type)
           (service libvirt-service-type)
	   )

          ;; This is the default list of services we
          ;; are appending to.
          %desktop-services))
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets (list "/boot/efi"))
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (swap-space
         (target "/dev/sda3"))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems
  (cons* (file-system
          (mount-point "/home")
          (device (file-system-label "GUIXHOME"))
          (type "ext4"))
         (file-system
          (mount-point "/")
          (device (file-system-label "GUIXROOT"))
          (type "btrfs")
          (options "compress=lzo"))
         (file-system
          (mount-point "/boot/efi")
          (device "/dev/sda1")
          (type "vfat")) %base-file-systems)))
