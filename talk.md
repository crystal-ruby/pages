---
layout: light
title: 5 minute talk
---

### ruby in ruby (3 rubies)

- speed
- parallelism
- clarity / understandibility



### Impossible, no

- Metasm, generate binary in ruby
- whitequark Parse
- c interface, not needed



### Difficult / low level - no

- exception in c is difficult, no c, not difficult
- function / os calling surprisingly easy
- vm - just code



### Architecture

- arm   + elf --> binary
- parslet parser, ast
- virtual machine - object machine
- register machine
- passes (vm->reg , reg optimisation , extensible)


- parfait (pure "normal" ruby) std/core on top
- builtin, code that can not be coded in ruby (ie array[])
- macro , shared code for builtin

- object memory layout, cache lines , type info external
  (type word / layout ref / payload ) 
  
.
     
    -Virtual::CompiledMethod(:name => :__init__, :class_name => :Object, :receiver => &4 Virtual::Integer, :return_type => *2)
      :args []
      :locals []
      :tmps []
      :blocks 
      -Virtual::Block(:name => :enter, :position => 172)
        :codes 
        -Arm::MemoryInstruction(:right => 2, :operand => 0, :pre_post_index => 1, :add_offset => 0, :position => 172)
         :result Register::RegisterReference(:symbol => :pc)
         :left Register::RegisterReference(:symbol => :r0)
         :attributes {:opcode => :str, :update_status => 0, :condition_code => :al}
        -Arm::MemoryInstruction(:right => 1, :operand => 0, :pre_post_index => 1, :add_offset => 0, :position => 176)
         :result Register::RegisterReference(:symbol => :r0)
         :left Register::RegisterReference(:symbol => :r5)
         :attributes {:opcode => :ldr, :update_status => 0, :condition_code => :al}
        -Arm::CallInstruction(:first => *5, :position => 180)
         :attributes {:opcode => :call, :update_status => 0, :condition_code => :al}
    -Virtual::Block(:name => :return, :position => 184)
      :codes -Arm::MemoryInstruction(:right => 2, :operand => 0, :pre_post_index => 1, :add_offset => 0, :position => 184)
         :result Register::RegisterReference(:symbol => :pc)
         :left Register::RegisterReference(:symbol => :r0)
         :attributes {:opcode => :ldr, :update_status => 0, :condition_code => :al}

.
         
    Disassembly of section .text:

    00000000 <_start>:
       0:   ea00002b        b       b4 <Kernel::__init__@enter+0x8>

    000000a4 <Virtual::CompiledMethod::a4>:
      a4:   00111111        andseq  r1, r1, r1, lsl r1
      a8:   00000244        andeq   r0, r0, r4, asr #4

    000000ac <Kernel::__init__@enter>:
      ac:   e580f002        str     pc, [r0, #2]
      b0:   e5950001        ldr     r0, [pc, #124]
      b4:   ebfffff6        bl      94 <Kernel::main@return+0x4>

    000000b8 <Kernel::__init__@return>:
      b8:   e590f002        ldr     pc, [r0, #2]
  
    00000204 <Virtual::BootSpace::204>:
     204:   00000000        andeq   r0, r0, r0
     208:   00000224        andeq   r0, r0, r4, lsr #4
     20c:   000002a4        andeq   r0, r0, r4, lsr #5
     210:   000005c4        andeq   r0, r0, r4, asr #11
            ...
   

### Understand the language at a new level, new possibilities

### Ruby makes even a vm easy & understandable

### Gems / bundler make parts independent

### Surprisingly fast
(6 weeks for first executable)

### Surprisingly fun !!
and wasn't ruby supposed to be

### salama
