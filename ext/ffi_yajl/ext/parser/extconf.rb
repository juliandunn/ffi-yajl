require 'mkmf'
require 'libyajl2'

# the customer is always right, ruby is always compiled to be stupid
$CFLAGS = ENV['CFLAGS'] if ENV['CFLAGS']
$LDFLAGS = ENV['LDFLAGS'] if ENV['LDFLAGS']
RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

# pick up the vendored libyajl2 out of the libyajl2 gem
$CFLAGS = "-I#{Libyajl2.include_path} -L#{Libyajl2.opt_path} #{$CFLAGS}"
$LDFLAGS = "-L#{Libyajl2.opt_path} #{$CFLAGS}"

puts $CFLAGS
puts $LDFLAGS

# except if you're doing an unoptimized gcc install we're going to help you out a bit
if RbConfig::MAKEFILE_CONFIG['CC'] =~ /gcc|clang/
  $CFLAGS << " -O3" unless $CFLAGS[/-O\d/]
  # how many people realize that -Wall is a compiler-specific flag???
  # apparently not many based on reading lots of shitty extconf.rb's out there
  $CFLAGS << " -Wall"
end

$LDFLAGS << " -lyajl"

dir_config 'parser'

create_makefile 'ffi_yajl/ext/parser'
