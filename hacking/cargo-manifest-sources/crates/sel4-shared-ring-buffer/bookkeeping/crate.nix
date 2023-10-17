{ mk, versions }:

mk {
  package.name = "sel4-shared-ring-buffer-bookkeeping";
  dependencies = {
    async-unsync = { version = versions.async-unsync; default-features = false; optional = true; };
  };
}