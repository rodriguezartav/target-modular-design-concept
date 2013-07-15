Target Modular Design is an alternative to Responsive Design, allowing developers to share the same code base while building app versions targeted at different screen sizes.

This is experimental at the moment and used to showcase the concept in a MVOSP ( Minimum Viable Open Source Project )

Comments greatly appreciated!

Responsive Web Design is the first attempt to provide differentiated content for different screen sizes. It’s widely accepted and used in the web development community.

What’s the problem that Responsive Web Design is solving?

Responsive Web Design prevents developers from building one app version for each screen size. It saves money and time spent in building multiple web pages/apps.
This approach is great for simple web sites where visitors watch and click on links. Anything more complex than simple web pages degrades user experience.

Other than the expected diference in screen-size and layout, on mobile and tablet devices people interact with apps throught touch gestures; on desktops and laptops people interact throught the click of a mouse or pad.

On the one side we have touch, pinch, twist and slide; while on the other one we have click, mouse over and drag&drop.

I am inventing ways to share the code base of an App and still provide targeted versions for each device.
Proof of Concept
The idea is to structure our App in modules and then dynamically compile just the specific modules for the target device.

There are as many approaches to choose from as there are opportunities to improve performance. However in this example my objetive is to explain this concept, I believe a minimum viable product is the best way.

Open the Demo - click to open in Browser and also try on mobile/table

Review Source Code - Important code in /compiler and /app folders

Concept Review
In this example we request an initial JS file with all the required libraries + modules that are shared by all versions independent of target device.

Once that initial JS file is loaded we request another file with the specific modules for the current device. We send a query paramenter with the width of our visitor’s screen, and according to that we compile the specific modules for that screen size and complete the request.

The second JS file brings all specific components and behaviors encapsulated in modules, they are used by the application to render the layout and initialize.

This is probably not the best architectural design. But I’ll leave that to specific implementations and focus on explaining the concept.

Request could be united or dinamically composed at runtime along with precompiling assets, requesting via CDN and loading server side templates to improve performance.

Demo Code Review
On this demo we separated our “app” into 3 sub-folders. They are /shared , /mobile and /web. The shared folder will always be included while the /mobile and /web are conditional to the vistor’s screen size.

The backend dynamically compiles the correct folder (/web or /mobile) depending on the width query paramenter of the request. ie:

/application.js?width=300 :::: will compile the contents of the /mobile folder /application.js?width=1000 ::will compile the /web folder

By mirroring the names of modules in both /mobile and /web folders we simplify the initialisation of the frontend once it receives all of the application’s modules,

ie. since the Main Controller exists and shares a name in both /web and /mobile. The App will just require(“controllers/main”) without having to know if it’s running on web or mobile.

The compiler is located at /compiler folder of the source code and is could be capable of handling dependencies and named groups. ie: /applications.js?app=mobile feel free to check it out.

Conclusion
Again this a basic draft and demo of the concept, it actually makes more sense when mixed with security policies and/or user preferences.

In production a similar approach that applies the concepts explained here by Alex Sexton would be necesarry.

It’s important to go beyond Responsive Web Design while keeping the development “sane” and within budget, the load performance of web apps must be above acceptable levels.

I don’t believe that this goals can be accomplished with a simple solution such as Responsive Web Design, we need powerfull methodologies, tools, very well written and structured code.