:Namespace Utf8ToAnsii
⍝ Convert UTF-8 files to ANSII character set by mapping
⍝ non-ANSII characters to HTML character entities
⍝ sjt15jul16

⍝ Command-line usage: ConvertUtf8 "path\to\some\files\*.abc" xyz
⍝ If abc ≡ xyz then the original files are overwritten

    :Namespace EXIT ⍝ Windows exit codes
        OK←0
        EMPTY←100    ⍝ no files found
        FAILED←101    ⍝ one or more files not converted
    :EndNamespace

    ∆←⊂'Exporting to an EXE can fail unpredictably.'
    ∆,←⊂'Retry the following expression if it fails,'
    ∆,←⊂'or use the File>Export dialogue from the menus.'
    ∆,←⊂'      #.Utf8ToAnsii.Export ''.\Utf8ToAnsii.exe'''
    Greeting←∆{(≢⍵)↓⊃,/⍵∘,¨⍺}⎕UCS 13

⍝    Greeting←{
⍝    ∆←'Exporting to an EXE can fail unpredictably.'
⍝    ∆,←⊂'Retry the following expression if it fails,'
⍝    ∆,←⊂'or use the File>Export dialogue from the menus.'
⍝    ∆,←⊂'      #.Utf8ToAnsii.Export ''.\Utf8ToAnsii.exe'''
⍝    (≢⍵)↓⊃,/⍵∘,¨∆
⍝    }⎕UCS 13
⍝
    ∇ msg←Export filename;type;flags;resource;icon;cmdline;nl
      #.⎕LX←'#.Utf8ToAnsii.Start'
     
      type←'StandaloneNativeExe'
      flags←2 ⍝ BOUND_CONSOLE
      resource←''
      icon←'.\images\gear.ico'
      cmdline←''
      :Trap 0
          2 ⎕NQ'.' 'Bind',filename type flags resource icon cmdline
          msg←'Exported ',filename
      :Else
          msg←'**ERROR: Failed to export EXE.'
      :EndTrap
    ∇

    ∇ Start;args;fss;ext;res
      args←⌷2 ⎕NQ'.' 'GetCommandLineArgs'
      (fss ext)←1↓3↑args ⍝ file search string; extension
      res←(#.InFiles.Utf8ToAnsii #.InFiles.Convert ext)fss~'"'
      :If 0=≢res
          exit←EXIT.EMPTY
      :ElseIf 0∊res
          exit←EXIT.FAILED
      :Else
          exit←EXIT.OK
      :EndIf
    ∇

:EndNamespace
