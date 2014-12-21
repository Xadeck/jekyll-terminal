{% terminal %}
$ echo "Hello world!"
Hello world!
$ date
Sun Dec 14 09:56:26 CET 2014
$ cat <<END
/This will disappear in void
/END
$ echo 'this line is an artificially long comand' | sed 's/comand/command to test rendering/' | grep line | tee /dev/null
this is an artificially long command to test rendering
$ echo
{% endterminal %}
