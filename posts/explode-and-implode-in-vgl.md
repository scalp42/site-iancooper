<h1>Explode and Implode in VGL</h1>

<p>
  <em>VGL</em> is a proprietary language that's used throughout SampleManager.  The name comes from the original creator of SampleManager, a company called Vacuum Generators (now VG Scienta).  After changing hands a handful of times&#151;<em>pun intended</em>&#151;SampleManager is now part of Thermo Fisher Scientific's laboratory informatics portfolio and my daily work life.  (Full disclosure: I'm employed by Thermo.)
</p>

<p>
  VGL lacks native string-to-array and array-to-string routines, often seen as <code>explode</code> and <code>implode</code> or <code>split</code> and <code>join</code> in other tools.  These kinds of functions can be very handy to have when you're trying to store an array in a table field (i.e. when a sample is to be evalulated against multiple product specifications).
</p>

<h2>Explode</h2>

<p>
  Suppose we have a string containing <code>"victor|golf|lima"</code>.  The expression <code>explode("victor|golf|lima", "|")</code> would evaluate to a one-dimensional VGL array containing the strings <code>"victor"</code>, <code>"golf"</code>, and <code>"lima"</code>.  Here's the code for <code>explode()</code>:
</p>

![explode.rpf](gist:4431755.js)
