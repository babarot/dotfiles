#!/usr/bin/env ruby

def test_initialize
    err = []
    dirs = Dir.glob("etc/init/*.sh") + Dir.glob("etc/init/osx/*.sh")
    dirs.each {|d|
        unless system("DEBUG=1 bash #{d} >/dev/null") && $? == 0 then
            err.push([d])
        end
    }
    exit 1 unless err.length == 0
end

test_initialize
