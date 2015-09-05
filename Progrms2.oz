%% Tests

%% A test of cycles.
declare Pr1 = 
 [localvar ident(foo)
  [localvar ident(bar)
   [[bind ident(foo) [record literal(person) [[literal(name) ident(foo)]]]]
    [bind ident(bar) [record literal(person) [[literal(name) ident(bar)]]]]
    [bind ident(foo) ident(bar)]]]]

%% Another test of cycles.
declare Pr2 = 
 [localvar ident(foo)
  [localvar ident(bar)
   [[bind ident(foo) [record literal(person) [[literal(name) ident(bar)]]]]
    [bind ident(bar) [record literal(person) [[literal(name) ident(foo)]]]]
    [bind ident(foo) ident(bar)]]]]


%% Test of procedures, with a closure.
declare Pr3 = 
   [localvar ident(foo)
    [localvar ident(bar)
     [localvar ident(quux)
      [bind ident(bar) [procedure [ident(baz)]
        [bind [record literal(person) [[literal(age) ident(foo)]]] 
              ident(baz)]]]
       [apply ident(bar) ident(quux)]
       [bind [record literal(person) [[literal(age) literal(40)]]] ident(quux)]
       %% We'll check whether foo has been assigned the value by
       %% raising an exception here
       %[bind literal(42) ident(foo)]
       ]]]

%succesful case match
declare Pr4 = 
[localvar ident(foo)
  [localvar ident(result)
   [[bind ident(foo) [record literal(bar)
                       [[literal(baz) literal(42)]
                       [literal(quux) literal(314)]]]]
    [match ident(foo) [record literal(bar1)
                           [[literal(baz) ident(fortytwo)]
                           [literal(quux) ident(pitimes100)]]]
     [bind ident(result) ident(fortytwo)] %% if matched
     [bind ident(result) literal(314)]] %% if not matched
    %% This will raise an exception if result is not 42
    [bind ident(result) literal(314)]
    [nop]]]]


%% Test a failing case match.
declare Pr5 = % not working in our implementation
 [localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [[bind ident(foo) ident(bar)]
     [bind literal(20) ident(bar)]
     [match ident(foo) literal(21)
      [bind ident(baz) literal(t)]
      [bind ident(baz) literal(f)]]
     %% Check
     [bind ident(baz) literal(f)]
     [nop]]]]]


declare Pr6 = 
%% Test a successful if.
 [localvar ident(foo)
  [localvar ident(result)
   [[bind ident(foo) bool(yes)]
    [conditional ident(foo)
     [bind ident(result) literal(t)]
     [bind ident(result) literal(f)]]
    %% Check
    [bind ident(result) literal(t)]]]]


declare Pr7 = 
%% Test a failing if.
 [localvar ident(foo)
  [localvar ident(result)
   [[bind ident(foo) bool(no)]
    [conditional ident(foo)
     [bind ident(result) literal(t)]
     [bind ident(result) literal(f)]]
    %% Check
    [bind ident(result) literal(f)]]]]



