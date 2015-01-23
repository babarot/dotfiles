#!/usr/bin/env ruby

def test_deploy
    c=0
    list = []
    make_list = `make list 2>&1`
    exit 1 unless $? == 0

    list = make_list.rstrip.split(/\r?\n/).map {|line| line.chomp }
    list.each {|f|
        source = File.expand_path(f)
        dest = File.expand_path(ENV["HOME"] + "/" + f)
        if File.symlink?(dest) then
            c += 1 if File.readlink(dest) == source
        end
    }
    exit 1 unless c == list.length
end

def test_initialize
    err = []
    dirs = Dir.glob("etc/init/*.sh") + Dir.glob("etc/init/osx/*.sh")
    dirs.each {|d|
        unless system("DEBUG=1 bash #{d} >/dev/null") && $? == 0 then
            err.push([d])
        end
    }
    exit 2 unless err.length == 0
end

test_deploy
test_initialize
