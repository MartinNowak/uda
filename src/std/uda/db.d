/**
   This module standardizes commonly used User Defined Attributes to
   be used with Database Drivers and Object Relational Mappers.

   License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).
   Authors: Martin Nowak
   Source: $(PHOBOSSRC std/_uda/_package.d)
*/
module std.uda.db;

@safe @nogc pure nothrow:

/**
   Marks a field as primary key.
*/
struct id
{
}

///
unittest
{
    struct User
    {
        @id string email;
    }

    struct Entry
    {
        int id;
    }

    struct Person
    {
        import std.datetime : Date;

        // compound key
        static struct Key
        {
            string firstname, surname;
            Date birthday;
        }

        @id Key key;
    }
}

/**
   Marks a one-to-one relation with another model.

   The foreign key field for one-to-one relations is usually inferable. In case
   it is ambiguous this UDA can be used to explicitly select the foreign key
   field of the other model.

Params:
  foreignKey = name of the foreign key field
*/
struct oneToOne(string foreignKey)
{
}

///
unittest
{
    struct Models
    {
        struct User
        {
            PhoneNumber phoneNumer;
            @oneToOne!"owner" EmailAddress emailAddress;
        }

        struct PhoneNumber
        {
            // inferable one-to-one, type and name match
            User* user;
            string value;
        }

        struct EmailAddress
        {
            // not inferable, type not unique, name mismatches
            User* owner;
            User* admin;
        }
    }
}

/**
   Marks a field as one-to-many relation with another model.

   In case the foreign key in that type cannot be inferred, it can be specified
   explicitly as `foreignKey`.

Params:
  foreignKey = optional name of the foreign key field
 */
struct oneToMany(string foreignKey = null)
{
}

///
unittest
{
    struct Models
    {
        struct User
        {
            // ...
            @oneToMany!"author" Commit[] authored;
            @oneToMany!"committer" Commit[] committed;
        }

        struct Commit
        {
            // ...
            User* author, committer;
        }
    }
}
