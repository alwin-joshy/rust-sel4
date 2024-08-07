#
# Copyright 2023, Colias Group, LLC
#
# SPDX-License-Identifier: BSD-2-Clause
#

{ mk, versions }:

mk {
  package.name = "sel4-synthetic-elf";
  dependencies = {
    inherit (versions) thiserror num;
    object = { version = versions.object; features = [ "all" ]; };
  };
}
