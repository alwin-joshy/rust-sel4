//
// Copyright 2024, Colias Group, LLC
//
// SPDX-License-Identifier: BSD-2-Clause
//

use spin::Mutex;

use sel4_config::sel4_cfg_bool;

use crate::{
    arch::{drivers::psci, reset_cntvoff},
    drivers::meson::MesonDevice,
    plat::Plat,
};

const SERIAL_DEVICE_BASE_ADDR: usize =  0xc81004c0;

static SERIAL_DEVICE: Mutex<MesonDevice> = Mutex::new(get_serial_device());

const fn get_serial_device() -> MesonDevice {
    unsafe { MesonDevice::new(SERIAL_DEVICE_BASE_ADDR) }
}

pub(crate) enum PlatImpl {}

impl Plat for PlatImpl {
    fn init() {
        SERIAL_DEVICE.lock().init();
    }

    fn init_per_core() {
        if sel4_cfg_bool!(ARM_HYPERVISOR_SUPPORT) {
            unsafe {
                reset_cntvoff();
            }
        }
    }

    fn put_char(c: u8) {
        SERIAL_DEVICE.lock().put_char(c);
    }

    fn put_char_without_synchronization(c: u8) {
        get_serial_device().put_char(c);
    }

    fn start_secondary_core(core_id: usize, sp: usize) {
        psci::start_secondary_core(core_id, sp)
    }
}