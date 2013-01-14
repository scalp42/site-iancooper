# Explode and Implode in VGL

_VGL_ is a proprietary language that's used throughout [SampleManager](http://www.thermo.com/samplemanager).  The name comes from the original creator of SampleManager, a company called Vacuum Generators (now [VG Scienta](http://www.vgscienta.com/)).  After changing hands a handful of times&#151;_pun intended_&#151;SampleManager is now part of [Thermo's](http://www.thermo.com/) [laboratory informatics portfolio](http://www.thermo.com/informatics) and my daily work life.  (Full disclosure: I'm employed by Thermo.)

VGL lacks native string-to-array and array-to-string routines, often seen as `explode` and `implode` or `split` and `join` in other tools.  These kinds of functions can be very handy to have when you're trying to store an array in a table field (i.e. when a sample is to be evalulated against multiple product specifications).

## Explode

Suppose we have a string containing `"victor|golf|lima"`.  The expression `explode("victor|golf|lima", "|")` would evaluate to a one-dimensional VGL array containing the strings `"victor"`, `"golf"`, and `"lima"`.  Here's the code for `explode()`:

[explode.rpf](gist:4431775)

## Implode

To reverse the process, suppose we have an array containing three strings: `"victor"`, `"golf"`, and `"lima"`.  To join these together in a pipe-delimited string (e.g. `"victor|golf|lima"`), we'd execute `implode(array, "|")`, where `array` is the above array (there's no inline array syntax in VGL).  Here's the code for `implode()`:

[implode.rpf](gist:4431755)

Note that we have to join the `STD_ARRAY` library to get the `size_of_array()` routine.  There are a few other routines in `STD_ARRAY` but it's woefully incomplete when compared to mainstream programming languages.

## Summary

Even though VGL is missing a lot of the usual array and string manipulation routines, we can implement most of them without too much trouble.

_The above code snippets are available [in this gist](https://gist.github.com/4431755).  Feel free to use them as you'd like!  Please keep in mind, though, that code samples are provided as-is and with no guarantees by myself or my employer._