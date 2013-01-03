# Exploring Database Structures in VGL

In [SampleManager](http://www.thermo.com/samplemanager), the database structure is defined in `structure.txt`, unsurprisingly known as _the structure file_.  The structure file uses a pretty straightforward syntax that defines the various tables, views, and indicies in the database that are used by SampleManager.  For a quick example, this snippet could define a table called `person`:

    TABLE person;
        FIELD identity      DATATYPE IDENTITY USED_FOR UNIQUE_KEY;
        FIELD first_name    DATATYPE TEXT(32);
        FIELD middle_name   DATATYPE TEXT(32);
        FIELD last_name     DATATYPE TEXT(32);
        FIELD email_address DATATYPE TEXT(255);
        FIELD location      LINKS_TO location.identity;

The syntax is case-insensitive and whitespace is also insignificant, so we can use capitalization, spacing, and indentation to help make it more human-readable.

When you're developing VGL code (the scripting language used throughout SampleManager), there are several routines available to get access to the database structure:

 * `get_table_names()`
 * `get_field_names()`
 * `GET_TABLE_DETAILS`
 * `GET_FIELD_DETAILS`

## `get_table_names()`
