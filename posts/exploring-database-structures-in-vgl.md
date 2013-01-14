# Exploring Database Structures in VGL

In [SampleManager](http://www.thermo.com/samplemanager), the database structure is defined in `structure.txt`, unsurprisingly known as _the structure file_.  The structure file uses a pretty straightforward syntax that defines the various tables, views, and indicies in the database that are used by SampleManager.  For a quick example, this snippet could define a table called `person`:

    TABLE person;
    FIELD identity       DATATYPE IDENTITY
                         USED_FOR UNIQUE_KEY;
    FIELD first_name     DATATYPE TEXT(32);
    FIELD middle_name    DATATYPE TEXT(32);
    FIELD last_name      DATATYPE TEXT(32);
    FIELD email_address  DATATYPE TEXT(255);
    FIELD location       LINKS_TO location.identity;

The syntax is case-insensitive and whitespace is also insignificant, so we can use capitalization, spacing, and indentation to help make it more human-readable.

When you're developing VGL code (the scripting language used throughout SampleManager), there are several routines and commands available to get access to the database structure:

 * `get_table_names()`
 * `get_field_names()`
 * `get_real_field_name()`
 * `GET_TABLE_DETAILS`
 * `GET_FIELD_DETAILS`

## `get_table_names()`

The `STD_STRUCTURE` standard library contains the `get_table_names()` routine.  It takes one argument, an array variable, which will be populated by the routine with a list of all of the table (and view) names.  The array will be a two-dimensional array, which makes it easy to use with the `browse_on_array()` routine.  For example:

    #vgl
    JOIN STANDARD_LIBRARY STD_DATABASE
    DECLARE real_field
    get_real_field_name("person", "location", real_field)
    
This would populate `tables_array` with data that looks something like this; the second element of each row will always be `EMPTY`:

    #js
    tables_array = [
        [ "person", EMPTY ],
        [ "sample", EMPTY ],
        [ "test",   EMPTY ],
        [ "result", EMPTY ],
        ⋮
    ]

## `get_field_names()`

The `get_field_names()` routine, also in `STD_DATABASE`, takes two arguments.  The first is a string value containing the name of the table for which you want the field names.  The second argument, similar to `get_table_names()`, should be an array variable to receive the list of fields.  The array will be a two-dimensional array, but instead of the second element of each row being `EMPTY`, it will be `TRUE` for fields that are aliases and `FALSE` otherwise.

For example:

    #vgl
    JOIN STANDARD_LIBRARY STD_STRUCTURE
    DECLARE fields_array
    get_field_names("person", fields_array)
    
Using the definition of `person` from above, this would populate `fields_array` with something that looks like this:

    #js
    fields_array = [
        [ "identity",      FALSE ],
        [ "first_name",    FALSE ],
        [ "last_name",     FALSE ],
        [ "email_address", FALSE ],
        [ "location_id",   FALSE ],
        [ "location",      TRUE  ]
    ]

See that `location` is designated as an alias, but no indication is made as to which field it is an alias of.  This will be exposed by the `get_real_field_name()` routine.

## `get_real_field_name()`

The `STD_DATABASE` routine `get_real_field_name()` provides the real field name that a given alias points to.  Three arguments are provided to the routine:  the table name, the alias name, and a variable that will be populated with the name of the real field that the alias points to.

For example:

    #vgl
    JOIN STANDARD_LIBRARY STD_DATABASE
    DECLARE real_field
    get_real_field_name("person", "location", real_field)

Using the above `person` table definition, `real_field` would be populated with the value `"location_id"`.

## `GET_TABLE_DETAILS` and `GET_FIELD_DETAILS`

I'm grouping these two commands together because they're very similar.  Each command takes three arguments: the name of a table or field (in the format of `table.field` for fields), a string containing the name of an attribute of that table or field, and a variable that will be populated with the value of the attribute.

For example:

    #vgl
    GET_FIELD_DETAILS person.email_address, "DATA_TYPE", email_data_type

Continuing with the `person` table described above, `email_data_type` would be populated with the value `"Text"`.  There are many attributes of tables and fields; the full list is available in the _VGL Programmer's Guide_, located in the `Help` folder of your SampleManager server, usually at `C:\Program Files (x86)\Thermo\SampleManager\10.2\Help\Programmers_Guide.chm` or similar.

## Summary

The details of the table structure can be accessed in VGL through the routines of the `STD_DATABASE` standard library and a few additional commands.  In my next post, we'll see a practical application of these methods.

_The above code snippets are available [in this gist](https://gist.github.com/4447646). Feel free to use them as you'd like! Please keep in mind, though, that code samples are provided as-is and with no guarantees by myself or my employer._



