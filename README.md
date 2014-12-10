This repository contains a series of analyses of the [mcstats](http://stats.minecraft.net) data.
'/img' contains the graphs, and plot.r contain the r scripts that created them.

## FPS Analysis

To start off, here is the distribution of frames per second (fps).

### FPS Distribution

![FPS Distribution](http://i.imgur.com/zyBZ79o.png)

A surpring amount of people have an FPS less than 30 fps. (And there's some odd spikes around 30, 60 and 120 fps.)[1]

To narrow down what may have caused this, and to see if it could be prevented, I decided to graph the correlation between
various settings that was logged.

### FPS-Setting correlation 1
![FPS-Setting correlation](http://i.imgur.com/CF9wCoK.png)

Since all correlations are below 0.3, there doesn't seem to be any one setting that affects the FPS in any major way.
This means there's no simple magic button you could toggle to increase the FPS, but that's probably a good thing
since it means there's no major performance hogs.

Even looking at settings which you can't easily change, such as the number of CPU cores,
there's no setting which goes higher than 0.3, which is well within the window of random noise.

### FPS-Setting correlation 2
![FPS-Setting correlation](http://i.imgur.com/RIsxRpT.png)

[1] When I analzed the average fps for a varying amount of minutes played (defined as the number of logged records per unique snooper token * 15),
it turns out none was below 40 fps, which means the users with less than 30 fps was probably just having lag-spikes.

## How do people play the game?

### Windowed vs Fullscreen
How many people are playing in windowed vs fullscreen mode, and how does it affect the time played?

![windowed vs fullscreen](http://i.imgur.com/uLUKNx1.png)

This is kind of surprising. People play about 10x more in fullscreen mode, but windowed mode is far more popular.
This may be selection bais, since people who know how to turn on fullscreen mode have may also been playing the game longer,
and are thus more likely to play for longer.

### Applet
How many people are playing in the applet, and how does it affect the time played?

![applet minutes](http://i.imgur.com/oSQdxMM.png)

This is even more surprising. People who use the applet also play for about twice as long, despite desktop more being more popular.
I'm not really sure why this is, and it seems hard to belive it's an anomaly since about 700,000 data points was analyzed.

## Popularity

### Mod popularity

About 15% of people are using mods! I decided to only include the forge modloader, since all others were well below 1%.
![mod popularity](http://i.imgur.com/1ct8cDq.png)

### Texturepack popularity

Default is used by 80% of users, this just shows non-default textures.
![texturepack popularity](http://i.imgur.com/Bcfz4BE.png)

### Java version popularity, ordered by users

![java version popularity, ordered by users](http://i.imgur.com/KfJ1nAG.png)

### Java version popularity, ordered by version number

![java version popularity, ordered by version number](http://i.imgur.com/pyW2hEJ.png)

### OpenGL vendor popularity

![OpenGL vendor popularity](http://i.imgur.com/CA4PZok.png)

