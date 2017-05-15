/*:
 [Previous](@previous)
 # Project San Jose
 ## This is where the fun begins!

### Please don't alter the code below. We are turning on your working station...
### Enable the Assistant Editor and select the Timeline display.
 ---
*/
    import PlaygroundSupport
    var viewController = ViewController()
    PlaygroundPage.current.liveView = viewController.view
    let c = Computer(viewController.consoleView.textView)
    PlaygroundPage.current.needsIndefiniteExecution = true
/*:
---
To use a method, type 'c.method()'. Method list:

* `setUserName(String)` - receives a user name and logs in.
* `echo(String)` - prints something on the console. Can be used to answer certain questions.
* `content()` - lists the content of the computer you are using.
* `openFile(String)` - receives a file name and opens the file.
* `closeFile()` - closes a file that is blocking your commands, such as images.
* `network()` - lists the available connections.
* `connectTo(String)` - receives a computer name and connects to it.
* `password(String)` - receives a password and validates it. Only works on a few machines.
* `disable(String)` - disables the security of a station. Can only be used inside de SecuritySystem.

Okay, we are good to go!
Insert your userName below and uncomment the line to log in.
*/
c.setUserName("Lucas")
//: Try saying "Hello"! Use the 'echo()' command.
//: For a better experience, comment the line, write the full command and then uncomment it (Command+/).
c.echo("Hello")
c.echo("Yes")
c.network()
c.content()
c.openFile("FamilyPic.png")
c.closeFile()
c.content()
