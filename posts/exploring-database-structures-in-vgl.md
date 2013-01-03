# Exploring Database Structures in VGL

In [SampleManager](http://www.thermo.com/samplemanager), the database structure is defined in `structure.txt`, unsurprisingly known as _the structure file_.  The structure file uses a pretty straightforward syntax that defines the various tables, views, and indicies in the database that are used by SampleManager.  For a quick example, this snippet could define a table called `person`:

![person.txt](gist:4447646)

The syntax is case-insensitive and whitespace is also insignificant, so we can use capitalization, spacing, and indentation to help make it more human-readable.
