
This repository contains a series of analyses of the [mcstats](http://stats.minecraft.com) data.
'/img' contains the graphs, and plot.r contain the r scripts that created them.

If anyone from Mojang is reading; I'm a Computer Science student at Linköping University currently searching for a summer intership.

FPS Analysis
--

To start off, here is the distribution of frames per second (fps).

## FPS Distribution

![FPS Distribution](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/fps_dist.png)

A surpring amount of people have an FPS less than 30 fps. (And there's some odd spikes around 30, 60 and 120 fps.)[1]

To narrow down what may have caused this, and to see if it could be prevented, I decided to graph the correlation between
various settings that was logged.

## FPS-Setting correlation 1
![FPS-Setting correlation](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/fps_corr.png)

Since all correlations are below 0.3, there doesn't seem to be any one setting that affects the FPS in any major way.
This means there's no simple magic button you could toggle to increase the FPS, but that's probably a good thing
since it means there's no major performance hogs.

Even looking at settings which you can't easily change, such as the number of CPU cores,
there's no setting which goes higher than 0.3, which is well within the window of random noise.

## FPS-Setting correlation 2
![FPS-Setting correlation](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/fps_corr_more.png)

[1] When I analzed the average fps for a varying amount of minutes played (defined as the number of logged records per unique snooper token * 15),
it turns out none was below 40 fps, which means the users with less than 30 fps was probably just having lag-spikes.

How do people play the game?
--

## Windowed vs Fullscreen
How many people are playing in windowed vs fullscreen mode, and how does it affect the time played?

![windowed vs fullscreen](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/display_type_minutes.png)

This is kind of surprising. People play about 10x more in fullscreen mode, but windowed mode is far more popular.
This may be selection bais, since people who know how to turn on fullscreen mode have may also been playing the game longer,
and are thus more likely to play for longer.

## Applet
How many people are playing in the applet, and how does it affect the time played?

![applet minutes](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/applet_minutes.png)

This is even more surprising. People who use the applet also play for about twice as long, despite desktop more being more popular.
I'm not really sure why this is, and it seems hard to belive it's an anomaly since about 700,000 data points was analyzed.

Popularity
--

## Mod popularity

About 15% of people are using mods! I decided to only include the forge modloader, since all others were well below 1%.
![mod popularity](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/client_brand.png)

## Texturepack popularity

Default is used by 80% of users, this just shows non-default textures.
![texturepack popularity](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/texpack.png)

## Java version popularity, ordered by users

![java version popularity, ordered by users](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/java_by_popularity.png)

## Java version popularity, ordered by version number

![java version popularity, ordered by version number](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/java_by_version.png)

## OpenGL vendor popularity

![OpenGL vendor popularity](http://github.com/DanielRapp/mcstats-analysis/raw/master/img/opengl_vendor.png)

