:Namespace Tests
⍝ Tests for InFiles Namespace
⍝ Vern: sjt15jul16

    I←#.InFiles ⍝ alias

    same←{∧/⍵∊⊂⊃⍵}∘,
    LB←⎕UCS 10 ⍝ line break
    ∇ cont nput file
    ⍝ (over)write cont to file
      :If ⎕NEXISTS file
          ⎕NDELETE file
      :EndIf
      cont ⎕NPUT file
    ∇

    TEST_FLDR←'./test_files/'

    SPECIAL←'"&<>' ⍝ ANSII characters that must be escaped

    ANSII←'The quick brown "fox" jumps over the lazy dog.'
    UTF8←'The quick br○wn "fo×" jumps over the lazy dog.'
    CHAR←'The quick br&#9675;wn "fo&#215;" jumps over the lazy dog.' ⍝ HTML character entities for non-ANSII

    ∇ Initial;file
    ⍝ Initialise state
      :If ~⎕NEXISTS TEST_FLDR
          ⎕MKDIR TEST_FLDR
      :EndIf
      ANSII nput TEST_FLDR,'ansii.txt'
      UTF8 nput TEST_FLDR,'utf8.txt'
    ∇

    ∇ Cleanup
     ⍝ clean up after tests
    ∇

    ⍝ # Tests

    ⍝ ## IsAnsii
    ∇ Z←Test_IsAnsii_001(debugFlag batchFlag)
     ⍝ plain ANSII text
      Z←1≢I.IsAnsii ANSII
    ∇

    ∇ Z←Test_IsAnsii_002(debugFlag batchFlag)
     ⍝ includes APL characters
      Z←0≢I.IsAnsii UTF8
    ∇

    ∇ Z←Test_IsAnsii_003(debugFlag batchFlag)
     ⍝ empty string
      Z←1≢I.IsAnsii''
    ∇

    ⍝ ## IsNonAnsii
    ∇ Z←Test_IsNonAnsii_001(debugFlag batchFlag)
     ⍝ plain ANSII text
      Z←0≢I.IsNonAnsii ANSII
    ∇

    ∇ Z←Test_NonIsAnsii_002(debugFlag batchFlag)
     ⍝ includes APL characters
      Z←1≢I.IsNonAnsii UTF8
    ∇

    ∇ Z←Test_IsNonAnsii_003(debugFlag batchFlag)
     ⍝ empty string
      Z←0≢I.IsNonAnsii''
    ∇

    ⍝ ## Utf8ToAnsii
    ∇ Z←Test_Utf8ToAnsii_001(debugFlag batchFlag);∆
     ⍝ plain ANSII text
      Z←ANSII≢I.Utf8ToAnsii ANSII
    ∇

    ∇ Z←Test_Utf8ToAnsii_002(debugFlag batchFlag)
     ⍝ includes APL characters
      Z←CHAR≢I.Utf8ToAnsii UTF8
    ∇

    ∇ Z←Test_Utf8ToAnsii_003(debugFlag batchFlag)
     ⍝ empty string
      Z←''≢I.Utf8ToAnsii''
    ∇

    ⍝ ## HtmlEntities
    ∇ Z←Test_HtmlEntities_001(debugFlag batchFlag);∆;ns;special
     ⍝ table of HTML entities
      special←'"&<>' ⍝ ANSII but must be escaped
      ns←I.HtmlEntities'./entities.html'
      :If Z←9≠⎕NC'ns'
      :OrIf Z←2∨.≠ns.⎕NC↑'ent' 'code' 'cmmt' 'char' 'ucs'
      :OrIf Z←~same≢∘⍴¨ns.(ent code cmmt char ucs)
      :OrIf Z←~same≢¨ns.(ent code cmmt char ucs)
      :OrIf Z←128∨.>⎕UCS ns.char~special
      :OrIf Z←128∨.>ns.ucs~⎕UCS special
      :EndIf
    ∇

    ⍝ ## file operators
    ∇ Z←Test_Files_001(debugFlag batchFlag)
     ⍝ read all TXT files
      Z←(ANSII UTF8,¨LB)≢I.(⊣Each)TEST_FLDR,'*.txt'
    ∇

    ∇ Z←Test_Files_002(debugFlag batchFlag)
     ⍝ test all TXT files for character set
      Z←1 0≢I.(IsAnsii Each)TEST_FLDR,'*.txt'
    ∇

    ∇ Z←Test_Files_003(debugFlag batchFlag)
     ⍝ select TXT files with ANSII character set
      Z←(,⊂TEST_FLDR,'ansii.txt')≢I.(IsAnsii Select)TEST_FLDR,'*.txt'
    ∇

    ∇ Z←Test_Files_004(debugFlag batchFlag)
     ⍝ Convert files to ANSII character set
      :If Z←1 1≢I.(Utf8ToAnsii Convert'dat')TEST_FLDR,'*.txt'
      :OrIf Z←0∊I.(IsAnsii Each)TEST_FLDR,'*.dat'
      :OrIf Z←(ANSII CHAR,¨LB)≢I.(⊣Each)TEST_FLDR,'*.dat'
      :EndIf
    ∇

    ∇ Z←Test_Files_005(debugFlag batchFlag);ext
     ⍝ Convert files to ANSII character set and overwrite (specified)
      ext←'xxx' ⍝ source extension
      ANSII nput TEST_FLDR,'ansii.',ext
      UTF8 nput TEST_FLDR,'utf8.',ext
      :If Z←1 1≢(I.Utf8ToAnsii I.Convert ext)TEST_FLDR,'*.',ext
      :OrIf Z←0∊I.(IsAnsii Each)TEST_FLDR,'*.',ext
      :OrIf Z←(ANSII CHAR,¨LB)≢I.(⊣Each)TEST_FLDR,'*.',ext
      :EndIf
    ∇

    ∇ Z←Test_Files_006(debugFlag batchFlag);ext
     ⍝ Convert files to ANSII character set and overwrite (explicit)
      ext←'yyy' ⍝ source extension
      ANSII nput TEST_FLDR,'ansii.',ext
      UTF8 nput TEST_FLDR,'utf8.',ext
      :If Z←1 1≢I.(Utf8ToAnsii Convert'')TEST_FLDR,'*.',ext
      :OrIf Z←0∊I.(IsAnsii Each)TEST_FLDR,'*.',ext
      :OrIf Z←(ANSII CHAR,¨LB)≢I.(⊣Each)TEST_FLDR,'*.',ext
      :EndIf
    ∇

:EndNamespace
