{ lib, stdenv
, buildPackages, pkgsBuildBuild
, linkFarm, symlinkJoin, writeText, runCommand
, callPackage
, sel4cp
, mkTask
, sources
, crates
, crateUtils
, seL4RustTargetInfoWithConfig
, mkCorePlatformInstance
, worldConfig
}:

let
  mkPD = args: mkTask (rec {
    # layers = [
    #   crateUtils.defaultIntermediateLayer
    #   {
    #     crates = [ "sel4" ];
    #     modifications = {
    #       modifyDerivation = drv: drv.overrideAttrs (self: super: {
    #         SEL4_PREFIX = seL4ForUserspace;
    #       });
    #     };
    #   }
    # ];
    rustTargetInfo = seL4RustTargetInfoWithConfig { cp = true; minimal = true; };
  } // args);

  inherit (worldConfig) isCorePlatform;

in {
  hello = rec {
    pds = {
      hello = mkPD rec {
        rootCrate = crates.sel4cp-hello;
        release = false;
      };
    };
    system = mkCorePlatformInstance {
      system = sel4cp.mkSystem {
        searchPath = "${pds.hello}/bin";
        systemXML = sources.srcRoot + "/crates/examples/sel4cp/hello/hello.system";
      };
      isSupported = isCorePlatform;
    };
  };

  banscii = rec {
    pds = {
      pl011-driver = mkPD rec {
        rootCrate = crates.banscii-pl011-driver;
      };
      assistant = mkPD rec {
        rootCrate = crates.banscii-assistant;
        rustTargetInfo = seL4RustTargetInfoWithConfig { cp = true; minimal = false; };
      };
      artist = mkPD rec {
        rootCrate = crates.banscii-artist;
        extraProfile = {
          # For RSA key generation
          build-override = {
            opt-level = 2;
          };
        };
      };
    };
    system = mkCorePlatformInstance {
      system = sel4cp.mkSystem {
        searchPath = symlinkJoin {
          name = "x";
          paths = [
            "${pds.pl011-driver}/bin"
            "${pds.assistant}/bin"
            "${pds.artist}/bin"
          ];
        };
        systemXML = sources.srcRoot + "/crates/examples/sel4cp/banscii/banscii.system";
      };
      isSupported = isCorePlatform;
    };
  };
}