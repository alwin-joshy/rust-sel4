{ mk, localCrates, versions, serdeWith, smoltcpWith }:

mk {
  package.name = "sel4cp-http-server-example-server";
  dependencies = rec {
    sel4-newlib = {
      features = [
        "nosys"
        "all-symbols"
        "sel4-panicking-env"
      ];
    };

    inherit (versions) log;

    serde = serdeWith [ "alloc" "derive" ];

    futures = {
      version = versions.futures;
      default-features = false;
      features = [
        "async-await"
        "alloc"
      ];
    };

    smoltcp = smoltcpWith [];

    virtio-drivers = {
      version = "0.5.0";
    };

    # virtio-drivers = {
    #   git = "https://github.com/nspin/virtio-drivers.git";
    #   rev = "409ee723c92adf309e825a7b87f53049707ed306"; # branch new-netdev
    #   # default-features = false; # disable "alloc"
    # };

    async-unsync = { version = "0.2.2"; default-features = false; };

    tock-registers = "0.8.1";

    sel4cp-http-server-example-server-core.features = [
      # "debug"
    ];

    sel4cp = { default-features = false; features = [ "alloc" ]; };
    sel4-externally-shared.features = [ "unstable" "alloc" ];
  };
  build-dependencies = {
    rcgen = "0.11.1";
  };
  nix.local.dependencies = with localCrates; [
    sel4
    sel4-sync
    sel4-logging
    sel4-immediate-sync-once-cell
    sel4cp
    sel4-externally-shared
    sel4-async-single-threaded-executor
    sel4-async-network
    sel4-async-timers
    sel4-async-request-statuses
    sel4-newlib
    sel4-bounce-buffer-allocator
    sel4-shared-ring-buffer
    sel4-shared-ring-buffer-smoltcp
    sel4cp-http-server-example-server-core
    sel4cp-http-server-example-server-cpiofs
    sel4cp-http-server-example-sp804-driver-interface-types
    sel4cp-http-server-example-virtio-net-driver-interface-types

    # virtio-drivers
  ];
  nix.meta.labels = [ "leaf" ];
  nix.meta.requirements = [ "sel4" ];
}