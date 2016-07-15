Encode
======

Dyalog APL tools for processing multiple files. 

The repo contains a namespace script `InFiles` for processing collections of files. These consist of three operators for iterating over files. Each operator takes a filepath eg `.\*.html` as `⍵` and applies its function `⍺⍺`
in its own way. 

The `InFiles` namespace
-----------------------

### Operators

`Each`
: applies `⍺⍺` to the content of each file and returns its result. 
The file is not touched.

`Convert`
: applies `⍺⍺` to the content of each file and writes the result to an eponymous file of extension `⍵⍵`. If `⍵⍵` is tblank, empty, or the same as the source file, the source file is overwritten. Eg

    (Utf8ToAnsii Convert 'htm') '.\*.html' ⍝ writes new HTMs
    (Utf8ToAnsii Convert 'htm') '.\*.htm'  ⍝ overwrites HTMs
    (Utf8ToAnsii Convert '   ') '.\*.htm'  ⍝ overwrites HTMs
    (Utf8ToAnsii Convert '') '.\*.htm'  ⍝ overwrites HTMs

`Select`
: applies `⍺⍺` to the content of each file. `⍺⍺` returns a Boolean scalar.
The modified function returns a vector of filenames for which the result of `⍺⍺` was 1.

For all three operators `⍺⍺` is ambivalent. 


### Functions

`IsAnsii`
: Whether `⍵` contains only ANSII characters.

`IsNonAnsii`
: Whether `⍵` contains any non-ANSII characters.

`NonAnsii`
: Unique non-ANSII characters in `⍵`

`Utf8ToAnsii`
: Result is `⍵` with non-ANSII characters replaced by HTML character entities.

`Utf8ToHtml`
: Result is `⍵` with non-ANSII characters replaced by [HTML entities](https://www.w3.org/TR/html401/sgml/entities.html).

`HtmlEntities`
: Namespace of HTML entities from copy of [W3.org definition of HTML entities](https://www.w3.org/TR/html401/sgml/entities.html)


Installation and dependencies
-----------------------------

The project contains no saved workspace. Active workspaces are built by DYAPPs. The DYAPPs assume the project folder is a sibling of the following dependencies:

`APLTree\`
: Contains the DYALOGs for (at least) `WinFile` and `Tester`.

`Dfns.dyalog`
: Contains (at least) the `htx` function copied from the `dfns` workspace shipped with the interpreter. 

`Devt.dyalog`
: Contains any development tools you want defined in the workspace root while you are working. If you have none, you can delete from `Develop.dyapp` the line that loads it. 


Development
-----------

The development environment is built by `Develop.dyapp`. 

The DYAPP installs the Tester Helpers in `#.Tests`. You can then run the InFiles tests: `#.Tests.Run`. 


Export
------

Executing `Utf8ToAnsii.dyapp` builds the production workspace and exports it as `Utf8ToAnsii.exe`. The Windows icon for the EXE is in the `images` folder. 

The components required for this are the DYALOGs `Dfns`, `InFiles`, and `Utf8ToAnsii` and the `images` folder. 


The `Utf8ToAnsii` EXE
---------------------

This EXE runs from the command line with one or two arguments: 

    Utf8ToAnsii {searchstring} [{ext}]

`{searchstring}` specifies target files to convert. The conversion replaces characters with Unicode points above 127 with corresponding HTML character entities. For example, `6÷3=2` becomes `6&#247;3=2`. The result is written to an eponymous file with extension `{ext}`. If the `{ext}` parameter is omitted, the source file is overwritten. 

    Utf8ToAnsii C:\temp\*.txt htm
    Utf8ToAnsii C:\temp\*.htm

In the examples above, the former writes an HTM for each TXT found. The latter overwrites any HTMs found. 


Limitations
-----------

All the InFiles operators read their source files into memory. Handling files too large for this would require extending the operators.


To do
-----

* `--help` output from EXE
* Write ADOC comments
* `Utf8ToHtml`: replace non-ANSII characters with HTML entities (where defined)


