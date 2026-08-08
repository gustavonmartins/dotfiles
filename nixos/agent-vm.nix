{
              nixpkgs.hostPlatform = system;
              networking.hostName = "agent-vm";

              environment.systemPackages = [ pkgs.opencode ];

              users.users.agent = {
                isNormalUser = true;
                initialPassword = "test"; # ← add this
              };

              microvm = {
                hypervisor = "qemu";
                qemu.serialConsole = true;

                volumes = [
                  {
                    image = "nix.img";
                    mountPoint = "/";
                    size = 20480;
                  }
                ];
                #user = "aicoding";
                interfaces = [
                  {
                    type = "user";
                    id = "agent-vm";
                    mac = "02:00:00:00:00:01";
                  }
                ];
                forwardPorts = [ ];
                vcpu = 4;
                mem = 4096;
              };

            }

