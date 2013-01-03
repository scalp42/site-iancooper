# Exploring Database Structures in VGL

In [SampleManager](http://www.thermo.com/samplemanager), the database structure is defined in `structure.txt`, unsurprisingly known as _the structure file_.  The structure file uses a pretty straightforward syntax that defines the various tables, views, and indicies in the database that are used by SampleManager.  For a quick example, this snippet could define a table called `person`:

    TABLE person;
    FIELD identity DATATYPE IDENTITY USED_FOR UNIQUE_KEY;
    FIELD first_name DATATYPE TEXT(32);
    FIELD middle_name DATATYPE TEXT(32);
    FIELD last_name DATATYPE TEXT(32);
    FIELD email_address DATATYPE TEXT(255);
    FIELD location LINKS_TO location.identity;
