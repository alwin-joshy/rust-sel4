//
// Copyright 2023, Colias Group, LLC
//
// SPDX-License-Identifier: BSD-2-Clause
//

#![no_std]
#![no_main]

use sel4_microkit::{memory_region_symbol, protection_domain, Channel};
use sel4_microkit_embedded_hal_adapters::rtc::driver::Driver;
use sel4_pl031_driver::Driver as DriverImpl;

const _DEVICE: Channel = Channel::new(0);
const CLIENT: Channel = Channel::new(1);

#[protection_domain]
fn init() -> Driver<DriverImpl> {
    let driver_impl =
        unsafe { DriverImpl::new(memory_region_symbol!(pl031_mmio_vaddr: *mut ()).as_ptr()) };
    Driver::new(driver_impl, CLIENT)
}
