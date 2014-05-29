#!/usr/bin/env ruby

def usage()
	puts "Usage: " + File.basename($0) + " [-h|--help] file"
	puts "It is a unarchiver supporting various file extensions."
	puts
	exit(1)
end

for path in ARGV
	case path
	when '-h', '--help'
		usage
	when /\.tar\.gz$/, /\.tgz$/
		system("tar", "xvzf", path)
	when /\.tar\.bz2$/
		system("tar", "xvjf", path)
	when /\.gz$/
		system("gunzip", path)
	when /\.bz2$/
		system("bunzip2", "-k", path)
	when /\.zip$/i
		system("unzip", path)
	else
		$stderr.puts("Unknown archive format: " + path)
		exit(1)
	end
	status= $?.to_i()/256
	exit(status) if status!=0
end
