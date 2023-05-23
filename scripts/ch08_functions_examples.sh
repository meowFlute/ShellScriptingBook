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
#	    trap function_name [kill code list - e.g. 1 2 3 6 9 15 20]
#
#		trap handle_exceptions 1 2 3 6 9 15 20
#		handle_exceptions
#		{
#		    # clean up tmp files, prepare to exit, etc.
#		}
#
#	this allows you to execute a function (presumably to cleanup) when you recieve a kill command before exiting
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

