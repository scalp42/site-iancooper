# Explode and Implode in VGL

_VGL_ is a proprietary language that's used throughout SampleManager.  The name comes from the original creator of SampleManager, a company called Vacuum Generators (now VG Scienta).  After changing hands a handful of times&#151;_pun intended_&#151;SampleManager is now part of Thermo Fisher Scientific's laboratory informatics portfolio and my daily work life.  (Full disclosure: I'm employed by Thermo.)

VGL lacks native string-to-array and array-to-string routines, often seen as `explode` and `implode` or `split` and `join` in other tools.  These kinds of functions can be very handy to have when you're trying to store an array in a table field (i.e. when a sample is to be evalulated against multiple product specifications).

## Explode

Suppose we have a string containing `"victor|golf|lima"`.  The expression `explode("victor|golf|lima", "|")` would evaluate to a one-dimensional VGL array containing the strings `"victor"`, `"golf"`, and `"lima"`.  Here's the code for `explode()`:

    ROUTINE explode(VALUE delimited_string, VALUE delimeter)
        DECLARE temp, dlen, arr, i, pos
        temp = delimited_string
        dlen = LENGTH(delimter)
        ARRAY arr
        i = 1
        
        pos = INDEX(temp, delimeter)
        WHILE (pos <> 0) DO
            arr[i] = LEFTSTRING(temp, pos - 1)
            temp = RIGHTSTRING(temp, LENGTH(temp) - pos - dlen + 1)
            i = i + 1
            pos = INDEX(temp, delimeter)
        ENDWHILE
        arr[i] = temp
        
        RETURN arr
    ENDROUTINE
