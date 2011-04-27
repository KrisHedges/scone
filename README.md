# Scone

Scone (Stylus, CoffeScript On node.js) makes developing node.js apps 
that use coffeescript and stylus easier. Scone is a development server 
monitor much like nodemon, but lighter, simpler, and providing a merged view of
the Node webserver console, the coffee watch console, and the stylus watch console. 
Giving the dev one terminal to rule them all.

When you make a change to either .coffee files or .styl files they will be compiled and output immediately.
Scone then watches the .js files in your node app for these changes and will restart the web server when they happen.
Stylus compiles .css files to /public/css these compiles WILL not cause the web-server to restart, but you will see the "compiled output" in the console.
It's only css so... just refresh the page.

In order to accomplish all these amazing feats Scone expects a basic few conventions (still very much subject to change, so... for now) to be followed.

* Your .coffee files are to stored in a ./coffee directory in the root of your app, and the resulting .js files are output to the root of your app ./.
* Your .styl files are kept in a /views/stylus directory and compiled to /public/css.
* Your main application file is called app.js

## Install:

   npm install scone

### Optionally
   
Scone can be installed in your app as a standalone script.
Compile scone.js
   
   coffee -c scone.coffee
   
Place scone.js in the root of your app and run it with node.

   node scone.js   


## Usage:

In the root of your app do:
 
   scone 
 
## Requirements:

* node & npm, of course.
* coffee-script
* stylus

## License:

 Licensed under the terms of MIT License. For the full copyright and license
 information, please see the LICENSE file in the root folder.
