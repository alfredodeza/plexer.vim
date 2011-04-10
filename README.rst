Plexer
======
A multi-line multi-edit plugin for vim. 

Just mark your lines (as many as you want) edit a single one and
apply your changes. Watch how everything propagates!

Not sure what this is about? Watch a short clip about it:
http://www.cafepais.com/media/i/plexer.gif


Why?
----
First question that comes up: "Wait! doesn't Visual Block do the same?"
and you would be *almost* right. But visual block selections in Vim need
to be contiguous. Not with Plexer! You can select arbitrary lines that 
might be (or not) contiguous. 


Usage
-----
The most basic usage scenario is: add a bunch of marks and then
go edit in a non-mark line and hit `:Plexer apply` to get the edits
propagated properly.

.. note::
    marks in Plexer are specific to the plugin itself and have nothing
    to do with Vim Marks (e.g. no conflicts or overlapping occurs)


Commands
--------
Plexer is very simple, but to harness the power from it you should
add some mappings. These are the calls that Plexer takes:

To add a mark
-------------

::

    :Plexer add

To apply changes
----------------

::

    :Plexer apply

To clear all marks
------------------

::

    :Plexer clear


Other options that you might find useful are the `signs` that Plexer creates
when you add a mark.

Show all the marks:

::

    :Plexer show


Hide all the marks:

::

    :Plexer hide
