#!/bin/bash

(cd vasm && make CPU=m68k SYNTAX=mot && chmod ugo+rx vasmm68k_mot)
(cd vasm && make CPU=m68k SYNTAX=std && chmod ugo+rx vasmm68k_std)
