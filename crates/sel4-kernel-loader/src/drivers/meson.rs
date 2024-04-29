//
// Copyright 2024, Colias Group, LLC
//
// SPDX-License-Identifier: BSD-2-Clause
//

#![allow(dead_code)]

use core::ops::Deref;

use tock_registers::{
    interfaces::{Readable, Writeable},
    register_structs,
    registers::ReadWrite,
};

const UART_CONTROL_TX_ENABLE: u32 = 1 << 12;
const UART_STATUS_TX_FIFO_FULL: u32 = 1 << 21;

register_structs! {
    #[allow(non_snake_case)]
    pub(crate)MesonRegisterBlock {
        (0x000 => wfifo: ReadWrite<u32>),
        (0x004 => rfifo: ReadWrite<u32>),
        (0x008 => ctrl: ReadWrite<u32>),
        (0x00c => status: ReadWrite<u32>),
        (0x010 => misc: ReadWrite<u32>),
        (0x014 => reg5: ReadWrite<u32>),
        (0x018 => @END),
    }
}

pub(crate) struct MesonDevice {
    base_addr: usize
}

impl MesonDevice {
    pub(crate) const unsafe fn new(base_addr:  usize) -> Self {
        Self {base_addr}
    }

    fn ptr(&self) -> *const MesonRegisterBlock {
        self.base_addr as *const _
    }

    pub(crate) fn init(&self) {
        self.ctrl.set(self.ctrl.get() | UART_CONTROL_TX_ENABLE);
    }

    pub(crate) fn put_char(&self, c: u8) {
        while self.status.get() & UART_STATUS_TX_FIFO_FULL != 0 {}
        self.wfifo.set(c as u32);
    }
}

impl Deref for MesonDevice {
    type Target = MesonRegisterBlock;

    fn deref(&self) -> &Self::Target {
        unsafe { &*self.ptr() }
    }
}