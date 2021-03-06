# REQUIRES: x86
# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t.o

## Show that we emit .rela.bar when GC is disabled.
# RUN: ld.lld --emit-relocs %t.o -o %t
# RUN: llvm-objdump %t -section-headers | FileCheck %s --check-prefix=NOGC
# NOGC: .rela.bar

## GC collects .bar section and we exclude .rela.bar from output.
# RUN: ld.lld --gc-sections --emit-relocs --print-gc-sections %t.o -o %t \
# RUN:   | FileCheck --check-prefix=MSG %s
# MSG: removing unused section from '.bar' in file
# MSG: removing unused section from '.rela.bar' in file
# RUN: llvm-objdump %t -section-headers | FileCheck %s --check-prefix=GC
# GC-NOT:  rela.bar

.section .bar,"a"
.quad .bar
