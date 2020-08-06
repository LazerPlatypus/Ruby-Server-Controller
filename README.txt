This program is designed to aid in the management of a very basic
Sinatra server. To use the program, simply double-click "start.bat"
If you are unconfortable doing so, open a command prompt, navigate to
This folder, and run "ruby tk_controller.rb", and in a seperate command
prompt, navigate to this folder, and run "ruby sinatra_server.rb"

The program allows an administrator to add or remove logins for the server.
The program allows an administrator to change basic css options, or they
can use the text box at the bottom of the application to manually edit
the CSS page.
The program allows an administrator to backup, rollback, start and stop
the server **THIS WAS HIGHTLY UNSTABLE AND HAS BEEN REMOVED**
  Any button pertaining to those fields has been deactivated and replaced
  with messages until a more stable solution can be found.
To test the server options, go to localhost:4567, and the webpage appears.
User settings, as well as css settings can be changed in real time, without
restarting the server (press shift+f5 to refresh cache in chrome so updated
css is displayed). to log in to the server, visit localhost:4567/login and use
any of the logins you made in the admin program. to log out, click the 'log out'
button.

Everything is very primitive, and is meant as a demo. This is not the complete
product but demonstrates competence in the course.

<sidenote>The logging is purposely made not visable from the homepage</sidenote>

** First-time startup from scratch **
Visual Studio code w/ ruby extension is highly recommended for editing.
Install Ruby+Devkit 2.6.6-1 (x64)
gem install sinatra
gem install tk

click the bat file OR
  open a terminal, and enter "ruby tk_controller.rb"
  open another terminal and enter "ruby sinatra_server.rb"