
# The default Makefile.Win32 (as of vasm 1.8f) specifies /Zp1 for the compiler. The Windows SDK is
#  incompatible with this setting, and starting with Windows 10 SDK 10.0.18362.0 the SDK will produce an
#  error if compiled with this switch.
#
# This will remove the /Zp1 flag from the compiler's command line (so the compiler defaults to /Zp8).
# This appears to have no negative effects on small test examples.

Copy-Item Makefile.Win32 vasm