#
# Caius Functional Testing Framework
#
# Copyright (c) 2013, Tobias Koch <tobias.koch@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modifi-
# cation, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
# NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUD-
# ING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
# USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUD-
# ING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFT-
# WARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

package require Itcl
package require Error
package require tdom

namespace eval Caius {

    ::itcl::class Testplan {

        private variable _config

        method usage {} {
            puts "                                                                      "
            puts "Usage: caius testplan \[OPTIONS] <testplan>                           "
            puts "                                                                      "
            puts "Summary:                                                              "
            puts "                                                                      "
            puts " Executes all tests listed in the testplan. The testplan is written in"
            puts " an XML-based format. An example testplan can be found in the source  "
            puts " distribution.                                                        "
            puts "                                                                      "
            puts "Options:                                                              "
            puts "                                                                      "
            puts " -d, --work-dir <dir> Change working directory before running tests.  "
            puts "                                                                      "
        }

        method parse_command_line {{argv {}}} {
            set _config(work_dir) .

            if {[llength $argv] == 0} {
                lappend argv --help-me-please-i-have-no-clue
            }

            for {set i 0} {$i < [llength $argv]} {incr i} {
                set o [lindex $argv $i]
                set v {}

                if {[set pos [string first = $o]] != -1} {
                    set v [string range $o [expr $pos + 1] end]
                    set o [string range $o 0 [expr $pos - 1]]
                }

                switch $o {
                    -h -
                    --help-me-please-i-have-no-clue -
                    --help {
                        $this usage

                        if {$o eq {--help-me-please-i-have-no-clue}} {
                            exit 1
                        }

                        exit 0
                    }
                    -d -
                    --work-dir {
                        if {$v eq {}} { set v [lindex $argv [incr i]] }
                        set _config(work_dir) $v
                        if {![file isdirectory $v]} {
                            raise ::Caius::Error "'$v' does not exist or isn't a directory"
                        }
                    }
                }
            }
        }

        method execute {argv} {
            parse_command_line $argv
        }
    }
}
