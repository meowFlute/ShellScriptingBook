#!/bin/bash

# Colors to differentiate my notes from program execution
PURPLE='\033[1;34m'
NO_COLOR='\033[0m'
echo_purple()
{
    # Usage 
    #	echo_purple "message"		for normal echo
    #	echo_purple "message" "\n"	for a skip prior to separate lines
    echo -e "${2:-""}${PURPLE}${1}${NO_COLOR}"
}

# -- Function Syntax
#	you can define functions in three ways:
#	    1) function_name()		    # most portable, accepted by the Bourne shell
#	    2) function function_name	    # maybe a little more clear
#	    3) function function_name()	    # Bash only, probably don't want to use it, but you can

# -- Function Output
#	Return Codes:
#	    One unsigned byte for return values (0-255). Use this by something like "return 0". 
#	    A case statement might be good for processing return codes
#	    These codes are returned via #?
#	Returning a String:
#	    return_string=`function_name [args]` will return all echo output to return_string
#	    tmp_file=`mktemp` takes advantage of this to generate a random tmp filename, because
#		mktemp will echo the randomly generated filename, and in this configuration it is
#		silently applied to the tmp_file variable
#	Writing to a (tmp) file:
#	    A function can write to a file -- think about doing a tmp_output=`mktemp` as described above!
#		This allows for complex return behavior (because shell doesn't support anything not described above)
#	Redirecting stdout:
#	    you can use echo in the function and then redirect all of it to a file (e.g. function > file.tmp)
#	    tee can redirect output to a file and to stdout (e.g. function | tee file.tmp will echo to terminal and to file)

# Writing to a tmp file example
echo_purple "A cool example of using the backtick echo format to generate a random tmp filename for complex return behavior" "\n"
squarecube()
{
  echo "$2 * $2" | bc > $1
  echo "$2 * $2 * $2" | bc >> $1
}

output=`mktemp`
for i in 1 2 3
do
  squarecube $output $i
  echo "The square of $i is `head -1 $output`"
  echo "The cube of $i is `tail -1 $output`"
done
rm -f $output

# capturing all args starting with $1 example
echo_purple "Here we show a tee redirect example and also use the \$@ to grab all args" "\n"
echo_all_args()
{
    echo "$# arguments passed:"
    echo $@
}
output=`mktemp`
echo "echoing:"
echo_all_args how much wood could a woodchuck chuck "if" a woodchuck could chuck wood | tee $output
echo "reading the tee'd file $output:"
cat $output
rm -f $output

# -- trap
#	you can trap for kill codes using the following syntax:
#	    trap function_name [signal list - e.g. 1 2 3 6 9 15 20]
#
#		trap handle_exceptions 1 2 3 6 9 15 20
#		handle_exceptions
#		{
#		    # clean up tmp files, prepare to exit, etc.
#		}
#
#	this allows you to execute a function (presumably to cleanup) when you recieve a kill command before exiting
#
#	I won't do an example of this here, but check out /Book_Downloads/Chapter_08*/ldd.sh
#	it is a program that would take a very long time and is using a tmp file, so it handles the quit signals
#	so that you can quit multiple times without making a mess of your filesystem
#
#	Here are a list of notes I compiled, mostly from man signal(7) 
#
#   	Signal        x86/ARM     Alpha/   MIPS   PARISC    Notes
#		     most others   SPARC		    *=You likely want to think about trapping for this case
#       ─────────────────────────────────────────────────────────────────
#       SIGHUP           1           1       1       1	  * Hangup of controlling terminal or death of controlling process
#       SIGINT           2           2       2       2	  * Interrupt from the keyboard (I'm guessing this is ) 
#       SIGQUIT          3           3       3       3	  * Quit from keyboard (???) this generates a core dump as well as the signal apparently
#       SIGILL           4           4       4       4	    Illegal instruction (depends on compiler, could be leaving a function without returning)
#       SIGTRAP          5           5       5       5	    Trace/breakpoint trap
#       SIGABRT          6           6       6       6	  * Abort signal from abort(3) -- this happens only from code calling it (e.g. assert failing)
#       SIGIOT           6           6       6       6	  * Same as above (even the same code
#       SIGBUS           7          10      10      10	    Bus error (bad memory access)
#       SIGEMT           -           7       7      -	    Emulator trap
#       SIGFPE           8           8       8       8	    Floating-point exception
#       SIGKILL          9           9       9       9	  * Kill signal 
#       SIGUSR1         10          30      16      16	    User-defined signal 1
#       SIGSEGV         11          11      11      11	    Invalid memory access (e.g. reading beyond bounds -- segfault)
#       SIGUSR2         12          31      17      17	    User-defined signal 2
#       SIGPIPE         13          13      13      13	    Broken pipe: write to pipe with no readers; see pipe(7)
#       SIGALRM         14          14      14      14	    Timer signal (see man alarm(2))
#       SIGTERM         15          15      15      15	  * Termination signal (default from kill)
#       SIGSTKFLT       16          -       -        7	    Stack fault on coprocessor
#       SIGCHLD         17          20      18      18	    Child process stopped or terminated
#       SIGCLD           -          -       18      -	    Same as SIGCHLD
#       SIGCONT         18          19      25      26	    Continue if stopped
#       SIGSTOP         19          17      23      24	    Stop process (cannot be handled or ignored)
#       SIGTSTP         20          18      24      25	  * Stop typed at terminal (this is )
#       SIGTTIN         21          21      26      27	    Terminal input for background process
#       SIGTTOU         22          22      27      28	    Terminal output for background process
#       SIGURG          23          16      21      29	    Urgent condition on socket (4.2BSD)
#       SIGXCPU         24          24      30      12	    CPU time exceeded (4.2BSD -- see man setrlimit(2))
#       SIGXFSZ         25          25      31      30	    File size limit exceeded (4.2BSD -- see man setrlimit(2))
#       SIGVTALRM       26          26      28      20	    Virtual alarm clock (4.2BSD)
#       SIGPROF         27          27      29      21	    Profiling timer expired
#       SIGWINCH        28          28      20      23	    Window resize signal (4.3BSD, Sun)
#       SIGIO           29          23      22      22	    I/O now possible (4.2BSD)
#       SIGPOLL						    Same as SIGIO
#       SIGPWR          30         29/-     19      19	    Power failure (System V)
#       SIGINFO          -         29/-     -       -	    same as SIGPWR

# -- recursion
#	works like you'd expect, check out the factorial.sh, and recursive-*.sh examples

# -- local variables
#	This one is going to be a huge lifesaver!
#	the "local" keyword makes it so the function ignores variables already set AND doesn't clobber them, for example
echo_purple "This example shows how a local variable works to not clobber the others with the same name - very cool!" "\n"
meow_function()
{
    local meow_var="meeeow"
    echo "local \$meow_var in the function: $meow_var"
}
meow_var="purrr"
echo "\$meow_var outside the function before the function call: $meow_var"
meow_function
echo "\$meow_var outside the function after the function call: $meow_var"
echo_purple "note how setting ${NO_COLOR}\$meow_var${PURPLE} in the function didn't have any effect on the ${NO_COLOR}\$meow_var${PURPLE} outside of the function even AFTER!"

# -- libraries
#	libraries are just files that
#	    - have no shebang
#	    - have no file extension (since they're not executed) -- I'd be tempted to use .bash.lib so it is obvious they need #!/bin/bash in the sourcing file
#		> this is not traditiona I don't think
#	    - are sourced 
#		> as a result of being sources, it doesn't matter if a function references another function defined later in the file, they're all loaded at source time
#		> if shopt sourcepath is set, then bash searches $PATH before searching the current directory, if it isn't it just searches the current dir
#		> they can soure each other, and then anything sourcing them will source both
#		    ~ if you make the mistake of creating a loop however, they'll recursively source each other forever and you'll get an error:
#			.: l: 3: "too many open files" (set by "nofile" in /etc/security/limits.conf
#		> YOU CAN AVOID THIS SAME WAY YOU DO IN C
#		    1) set a variable that is _lib_name=1 at the top of all library files
#		    2) load additional library files as needed by checking for their variables being set
#			e.g. [ -z "$_other_lib" ] && . /path/to/other_lib
#			    ~ just like "#ifndef __HEADER_FILE_NAME"!
#	NOTE: the author suggested the following locations as potentially suitable:
#	    - $HOME/lib for generic libraries (added to the path in ~/.bashrc)
#	    - for a script packaged with an app, /usr/local/app_name/bin fo the script and /usr/local/app_name/lib for the library
#	A good example of all of this is the client > *network > definitions example in /Book_Download/Chapter_08*
#	Makes me also want to write a library for colored outputs! -- maybe I will!

# -- getopts
#	getopts works in functions just like it does in scripts
#	    - a few things to know that the book points out:
#		> Setting OPTERR=0 suppresses the getopts errors
#		    ~ OPTERR=1 is set every time a new script launches automatically
#		    ~ starting your argument list with a colong, e.g. ':habc:d' sets OPTERR=0
#		    ~ check out the difference between /Book_Download/mkfile and /Book_Download/mkfile2 for a good example
#		> Because getopts increments OPTIND each time it works through a variable it must be reset to 1 each time you enter the function
#		    ~ /Book_Download/temperature.sh brings this all together, showing a good example of a function using getopts usefully
