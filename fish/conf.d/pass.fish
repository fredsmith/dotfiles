function genpass
    # Default value handling in fish
    set -q argv[1]; and set passlen $argv[1]; or set passlen 10
    set -q argv[2]; and set numpass $argv[2]; or set numpass 1
    
    # Case statement equivalent in fish using if/else
    if test "$argv[3]" = "nosym"
        set charset 'a-zA-Z0-9'
    else if test "$argv[3]" = "num"
        set charset '0-9'
    else
        set charset 'a-zA-Z0-9!@#$%^&*()' 
    end
    
    # Using LC_ALL=C to avoid UTF-8 character issues
    LC_ALL=C head -c 1000 /dev/urandom | LC_ALL=C tr -dc $charset | fold -w $passlen | head -n $numpass
end
