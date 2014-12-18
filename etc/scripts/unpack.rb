#! /usr/bin/env ruby
#

def usage()
    puts "Usage: " + File.basename($0) + " [-h|--help] file"
    puts "It is a unarchiver supporting various file extensions."
    puts
    exit(1)
end

if ARGV[0] == '-h' || ARGV[0] == '--help' then
    usage
end

module Enumerable
    def any(&f)
        self.each do|item|
            x = f.call item
            return x if x
        end
        return nil
    end
end

class App
    def initialize
        @cmds = []
        instance_eval DATA.read
    end

    def ext(ext, &f)
        @cmds << lambda{|file|
            if file =~ /#{Regexp.quote ext}\Z/ then
                f.call file
            end
        }
    end

    def mime(mime, &f)
        @cmds << lambda{|file|
            if %x(file -bI #{file}).chop == mime then
                f.call file
            end
        }
    end

    def unpack(files)
        files.each do|file|
            cmd = @cmds.any{|f| f.call file}
            abort("unknown file type: #{file}") unless cmd
            puts ">>> #{cmd}"
            system cmd
        end
    end
end

App.new.unpack(*ARGV)

__END__

ext '.tar.bz2' do|file|
    "tar xvjf #{file}"
end

ext '.tar.gz' do|file|
    "tar xvzf #{file}"
end


mime 'application/x-zip' do|file|
    t = File.basename file,".*"
    "unzip -d #{t} #{file}"
end
