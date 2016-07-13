Encode
======

Dyalog APL tools for processing multiple files. 

The repo contains a namespace script `InFiles` for processing collections of files. These consist of three operators for iterating over files. Each operator takes a filepath eg `.\*.html` as `⍵` and applies its function `⍺⍺`
in its own way. 

Operators
---------

`Each`
: applies `⍺⍺` to the content of each file and returns its result. 
The file is not touched.

`Convert`
: applies `⍺⍺` to the content of each file and writes the result to an eponymous file of extension `⍵⍵`. If `⍵⍵` is the same as the source file, the source file is overwritten. Eg

    (Utf8ToAnsii Convert 'htm') '.\*.html' ⍝ writes new HTMs
    (Utf8ToAnsii Convert 'htm') '.\*.htm'  ⍝ overwrites HTMs

`Select`
: applies `⍺⍺` to the content of each file. `⍺⍺` returns a Boolean scalar.
The modified function returns a vector of filenames for which the result of `⍺⍺` was 1.

For all three operators `⍺⍺` is ambivalent. 


Functions
---------

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

To do
-----

* `Utf8ToHtml`
* 