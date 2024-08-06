//
// Copyright 2023, Colias Group, LLC
//
// SPDX-License-Identifier: BSD-2-Clause
//

use core::ops::Range;

use zerocopy::{AsBytes, FromBytes, FromZeroes};

pub trait Descriptor {}

#[repr(C)]
#[derive(Copy, Clone, Debug, PartialOrd, Ord, PartialEq, Eq, AsBytes, FromBytes, FromZeroes)]
pub struct NetworkDescriptor {
    encoded_addr: usize,
    len: u16,
    _padding: [u8; 6],
}

impl Descriptor for NetworkDescriptor {}

impl NetworkDescriptor {
    pub fn new(encoded_addr: usize, len: u16) -> Self {
        Self {
            encoded_addr,
            len,
            _padding: [0; 6],
        }
    }

    pub fn from_encoded_addr_range(encoded_addr_range: Range<usize>) -> Self {
        let encoded_addr = encoded_addr_range.start;
        let len = encoded_addr_range.len().try_into().unwrap();
        Self::new(encoded_addr, len)
    }

    pub fn encoded_addr(&self) -> usize {
        self.encoded_addr
    }

    pub fn set_encoded_addr(&mut self, encoded_addr: usize) {
        self.encoded_addr = encoded_addr;
    }

    #[allow(clippy::len_without_is_empty)]
    pub fn len(&self) -> u16 {
        self.len
    }

    pub fn set_len(&mut self, len: u16) {
        self.len = len;
    }

    pub fn encoded_addr_range(&self) -> Range<usize> {
        let start = self.encoded_addr();
        let len = self.len().try_into().unwrap();
        start..start.checked_add(len).unwrap()
    }
}
