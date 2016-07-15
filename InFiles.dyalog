:Namespace InFiles
⍝ Utilities for processing multiple files

  ⍝ requires #.Dfns

    ⍝ -- operators --
      Each←{                            ⍝ iterate ⍺⍺ on files in ⍵
          ⍺←⊣
          ⍺∘⍺⍺¨⊃∘⎕NGET¨filesIn ⍵
      }

      dest←{ ⍝ destructive dyadic file operation
          {⎕NEXISTS ⍵:⎕NDELETE ⍵ ⋄ 1}⍵:⍺ ⍺⍺ ⍵
          0
      }

      Convert←{
        ⍝ ⍺⍺ is a monadic or dyadic fn for which ⍵ and result are filestrings
        ⍝ ⍵⍵ is extension of target file; if empty or same as source file, overwrites
        ⍝ Result is a flag for each file indicating success
        ⍝ eg 1 0 1 ←→ (Utf8ToAnsii Convert 'htm') './*.html'
        ⍝ eg 1 0 1 ←→ (Utf8ToAnsii Convert '') './*.html' ⍝ overwrite
          ⍺←⊣
          srcs←filesIn ⍵
          rw←{
              (path name ext)←⎕NPARTS ⍵
              ext←⊃(×≢⍵⍵~' ')⌽ext ⍵⍵ ⍝ empty or blank ⍵⍵ => overwrite
              tgt←path,name,{('.'/⍨'.'≠⊃⍵),⍵~' '}ext
              (txt enc lb)←⎕NGET ⍵
              new←⍺⍺ txt
              (new enc lb)⎕NPUT dest tgt
          }
          ×(⍺∘⍺⍺ rw ⍵⍵)¨srcs
      }

      Select←{
         ⍝ ⍺⍺ is a monadic or dyadic fn for which ⍵ is a filestring and
         ⍝ result is a Boolean scalar
         ⍝ Result of the modified fn is a list of files for which ⍺⍺ returns 1
         ⍝ eg IsAnsii Select './*.html'
          ⍺←⊣
          srcs←filesIn ⍵
          srcs/⍨⍺∘⍺⍺¨⊃¨⎕NGET¨srcs
      }

    filesIn←{⊃(⎕NINFO⍠'Wildcard' 1)⍵}

    ⍝ -- functions --
    IsAnsii←{128∧.>⎕UCS∪⍵}

    IsNonAnsii←{127∨.<⎕UCS∪⍵}

    NonAnsii←{⍵/⍨127<⎕UCS ⍵}

⍝   toUppercase←{1(819⌶)⍵}

      Utf8ToAnsii←{                         ⍝ convert all non-ANSII chars to HTML character entities
          utf8←NonAnsii ⍵                   ⍝ unique code points above 127
          old←,¨utf8                        ⍝ characters
          new←{'\&#',(⍕⍵),';'}¨⎕UCS utf8    ⍝ character entities
          (old ⎕R new)⍵
      }

    ∇ Z←HtmlEntities filepath;xxx;∆;htx;txt;path;file;RX;sp
    ⍝ filepath: (str) to https://www.w3.org/TR/html401/sgml/entities.html
    ⍝ NS of characters, codes, HTML entities and W3.org comments
      Z←⎕NS''
      sp←{⌷∘⍵.Match¨⊂¨⊃+∘⍳¨/1↓¨⍵.(Offsets Lengths)}                 ⍝ subpatterns
      txt←⊃⎕NGET filepath
      (path file xxx)←⎕NPARTS filepath
      RX←'<!ENTITY (\w+)\s+CDATA "&amp;#(\d+);"\s+-- (.+)\s?-->'
      ∆←⊃,/'pre'#.Dfns.htx txt                                      ⍝ extract PRE elements
      ∆←('&lt;' '&gt;'⎕R(,¨'<' '>'))∆                               ⍝ convert lt gt to <>
      ∆←'<!ENTITY'∘{⍵⊂⍨⍺⍷⍵}∆                                        ⍝ lines
      ∆←⊃,/('<!ENTITY [^>]+ -->'⎕S'&')¨∆                            ⍝ select entity definitions
      Z.(ent code cmmt)←↓⍉↑⊃,/(RX ⎕S sp)¨∆
      Z.(char←⎕UCS ucs←{⊃2⊃⎕VFI ⍵}¨code)
    ∇

:EndNamespace
