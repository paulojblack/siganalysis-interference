# siganalysis-interference  

This is still super messy as I've been teaching myself Matlab to write this and haven't had much thought for good design practice, I'm just limping to the finish line at this point. If the script works well I want I'll come back and clean it up.

## Summary  
A signal analysis script I've been working on to try and scan over ImageJ files I've been taking with a CCD camera for one of my experiments. The files read are 1080 by 1392 histograms with bins representing pixel intensity. I can't share the data as it's unpublished right now, but here's a quick run down for what its worth:

<a href = "https://en.wikipedia.org/wiki/Surface_plasmon_polariton">Surface Plasmon Polaritons</a> (SPPs)are excited at the surface of a thin layer of metal with dye molecules embedded on top. Long story short, the SPPs make the dye molecules emit light, and I built a setup that passes the light from one molecule through one thin slit and the light from another, nearby molecule through another thin slit (separated by a short distance on the order of micrometers). Following the principles of Young's Double Slit experiment, we want to see interference created from these two single point sources, as that would demonstrate they emit light "coherently" which would prove an important quantum mechanical concept about SPPs.

## Future  
Right now I'm working on a good way to read the minima in each plot (can't just invert plot and findmax because the minima are above the trendline). Once I'm done with that I'll probably be finished with the whole thing, I could just add some neat output files that detail the visiblity of each plot, maybe I'll add capability to read a folder of ImageJ images and output data for all of them. I think it would be nice to share this with other groups around the world that are working on the same project, all of the commercial signal analysis software I've found doesn't give enough control over which section of an image you can analyze to automate the process.


