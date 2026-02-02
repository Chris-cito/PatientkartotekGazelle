procedure korrektionskoder (var s : string);
var m : set of char;
begin

  m := ['-',' ','0'];

  if s[69] = '-' then s[149] := '1'
  else
    s[149] := '0';

  if (copy(s,12,2) = 'UL') or (copy(s,63,6) = '100015') then
    if (s[100] = '-') and (s[85] <> '-') and (s[115] <> '-') and
      (s[127] <> '-') then s[149] := '2' { Patienten skal tilbagebetale }
    else
      if (s[100] <> '-') and (s[85] = '-') and
        (s[115] in m) and (s[127] in m) then s[149] := '3' { Patienten skal have udbetalt }
      else s[149] := '9'; { '9' betyder fejl }

  if s[149] <> '9' then begin { '-' fjernes hvis ingen fejl }
    if s[69]  = '-' then s[69]  := ' ';
    if s[75]  = '-' then s[75]  := ' ';
    if s[85]  = '-' then s[85]  := ' ';
    if s[100] = '-' then s[100] := ' ';
    if s[115] = '-' then s[115] := ' ';
    if s[127] = '-' then s[127] := ' ';
    if s[139] = '-' then s[139] := ' ';
    if s[160] = '-' then s[160] := ' '
  end
end { of korrektionskoder };
