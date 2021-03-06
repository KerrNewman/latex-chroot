%!PS-Adobe-2.0
%%Creator: Terry Burton
%%DocumentPaperSizes: a4
%%EndComments
%%EndProlog

% Barcode Writer in Pure PostScript - Version 2006-05-26
% http://www.terryburton.co.uk/barcodewriter/
%
% Copyright (c) 2006 Terry Burton - tez@terryburton.co.uk
%
% Permission is hereby granted, free of charge, to any
% person obtaining a copy of this software and associated
% documentation files (the "Software"), to deal in the
% Software without restriction, including without
% limitation the rights to use, copy, modify, merge,
% publish, distribute, sublicense, and/or sell copies of
% the Software, and to permit persons to whom the Software
% is furnished to do so, subject to the following
% conditions:
%
% The above copyright notice and this permission notice
% shall be included in all copies or substantial portions
% of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
% KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
% THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
% PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
% CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
% IN THE SOFTWARE.

% Uncomment this next line to allow these procedure definitions to 
% remain resident within a printer's PostScript virtual machine 
% so that the barcode generation capability persists between jobs.

% serverdict begin 0 exitserver 

% --BEGIN TEMPLATE--

% --BEGIN ENCODER ean13--
/ean13 {

    0 begin

    /options exch def                  % We are given an option string
    /useropts options def
    /barcode exch def                  % We are given a barcode string

    /includetext false def             % Enable/disable text
    /textfont /Helvetica def
    /textsize 12 def
    /textpos -4 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    /barlen barcode length def         % Length of the code

    % Add checksum digit to barcode if length is even
    barlen 2 mod 0 eq {
        /pad barlen 1 add string def   % Create pad one bigger than barcode
        /checksum 0 def
        0 1 barlen 1 sub {
            /i exch def
            /barchar barcode i get 48 sub def
            i 2 mod 0 eq {
                /checksum barchar checksum add def
            } {
                /checksum barchar 3 mul checksum add def
            } ifelse
        } for
        /checksum 10 checksum 10 mod sub 10 mod def
        pad 0 barcode putinterval       % Add barcode to the start of the pad
        pad barlen checksum 48 add put  % Put ascii for checksum at end of pad
        /barcode pad def                % barcode=pad
        /barlen barlen 1 add def        % barlen++
    } if

    % Create an array containing the character mappings
    /encs
    [ (3211) (2221) (2122) (1411) (1132)
      (1231) (1114) (1312) (1213) (3112)
      (111) (11111) (111)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    % Digits to mirror on left side
    /mirrormaps
    [ (000000) (001011) (001101) (001110) (010011)
      (011001) (011100) (010101) (010110) (011010)
    ] def

    /sbs barlen 1 sub 4 mul 11 add string def
    /txt barlen array def
  
    % Put the start character
    sbs 0 encs 10 get putinterval

    % First digit - determine mirrormap by this and show before guard bars
    /mirrormap mirrormaps barcode 0 get 48 sub get def
    txt 0 [barcode 0 1 getinterval -10 textpos textfont textsize] put

    % Left side - performs mirroring
    1 1 6 {
        % Lookup the encoding for the each barcode character
        /i exch def
        barcode i 1 getinterval barchars exch search
        pop                            % Discard true leaving pre
        length /indx exch def          % indx is the length of pre
        pop pop                        % Discard seek and post
        /enc encs indx get def         % Get the indxth encoding
        mirrormap i 1 sub get 49 eq {   % Reverse enc if 1 in this position in mirrormap
            /enclen enc length def
            /revenc enclen string def
            0 1 enclen 1 sub {
                /j exch def
                /char enc j get def
                revenc enclen j sub 1 sub char put
            } for
            /enc revenc def
        } if
        sbs i 1 sub 4 mul 3 add enc putinterval   % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 1 sub 7 mul 4 add textpos textfont textsize] put
    } for

    % Put the middle character
    sbs 7 1 sub 4 mul 3 add encs 11 get putinterval

    % Right side
    7 1 12 {
        % Lookup the encoding for the each barcode character
        /i exch def
        barcode i 1 getinterval barchars exch search
        pop                            % Discard true leaving pre
        length /indx exch def          % indx is the length of pre
        pop pop                        % Discard seek and post
        /enc encs indx get def         % Get the indxth encoding
        sbs i 1 sub 4 mul 8 add enc putinterval  % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 1 sub 7 mul 8 add textpos textfont textsize] put
    } for

    % Put the end character
    sbs barlen 1 sub 4 mul 8 add encs 12 get putinterval
    
    % Return the arguments
    /retval 4 dict def
    retval (sbs) [sbs {48 sub} forall] put
    includetext {
        retval (bhs) [height height 12{height .075 sub}repeat height height 12{height .075 sub}repeat height height] put
        retval (bbs) [0 0 12{.075}repeat 0 0 12{.075}repeat 0 0] put
        retval (txt) txt put
    } {
        retval (bhs) [30{height}repeat] put        
        retval (bbs) [30{0}repeat] put
    } ifelse
    retval (opt) useropts put
    retval (guardrightpos) 10 put
    retval (borderbottom) 5 put
    retval
    
    end

} bind def
/ean13 load 0 1 dict put
% --END ENCODER ean13--

% --BEGIN ENCODER ean8--
/ean8 {

    0 begin

    /options exch def                  % We are given an option string
    /useropts options def
    /barcode exch def                  % We are given a barcode string

    /includetext false def              % Enable/disable text
    /textfont /Helvetica def
    /textsize 12 def
    /textpos -4 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (3211) (2221) (2122) (1411) (1132)
      (1231) (1114) (1312) (1213) (3112)
      (111) (11111) (111)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    /barlen barcode length def           % Length of the code
    /sbs barlen 4 mul 11 add string def
    /txt barlen array def
    
    % Put the start character
    sbs 0 encs 10 get putinterval

    % Left side
    0 1 3 {
        % Lookup the encoding for the each barcode character
        /i exch def
        barcode i 1 getinterval barchars exch search
        pop                                % Discard true leaving pre
        length /indx exch def              % indx is the length of pre
        pop pop                            % Discard seek and post
        /enc encs indx get def             % Get the indxth encoding
        sbs i 4 mul 3 add enc putinterval  % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 7 mul 4 add textpos textfont textsize] put
    } for

    % Put the middle character
    sbs 4 4 mul 3 add encs 11 get putinterval

    % Right side
    4 1 7 {
        % Lookup the encoding for the each barcode character
        /i exch def
        barcode i 1 getinterval barchars exch search
        pop                                % Discard true leaving pre
        length /indx exch def              % indx is the length of pre
        pop pop                            % Discard seek and post
        /enc encs indx get def             % Get the indxth encoding
        sbs i 4 mul 8 add enc putinterval  % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 7 mul 8 add textpos textfont textsize] put
    } for

    % Put the end character
    sbs barlen 4 mul 8 add encs 12 get putinterval

    % Return the arguments
    /retval 4 dict def
    retval (sbs) [sbs {48 sub} forall] put
    includetext {
        retval (bhs) [height height 8{height .075 sub}repeat height height 8{height .075 sub}repeat height height] put
        retval (bbs) [0 0 8{.075}repeat 0 0 8{.075}repeat 0 0] put
        retval (txt) txt put
    } {
        retval (bhs) [22{height}repeat] put        
        retval (bbs) [22{0}repeat] put
    } ifelse
    retval (opt) useropts put
    retval (guardleftpos) 10 put
    retval (guardrightpos) 10 put
    retval (borderbottom) 5 put
    retval

    end

} bind def
/ean8 load 0 1 dict put
% --END ENCODER ean8--

% --BEGIN ENCODER upca--
/upca {

    0 begin

    /options exch def
    /useropts options def
    /barcode exch def             % We are given a barcode string

    /includetext false def         % Enable/disable text
    /textfont /Helvetica def
    /textsize 12 def
    /textpos -4 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    /barlen barcode length def         % Length of the code

    % Add checksum digit to barcode if length is odd
    barlen 2 mod 0 ne {
        /pad barlen 1 add string def   % Create pad one bigger than barcode
        /checksum 0 def
        0 1 barlen 1 sub {
           /i exch def
           /barchar barcode i get 48 sub def
           i 2 mod 0 ne {
               /checksum checksum barchar add def
           } {
               /checksum checksum barchar 3 mul add def
           } ifelse
        } for
        /checksum 10 checksum 10 mod sub 10 mod def
        pad 0 barcode putinterval       % Add barcode to the start of the pad
        pad barlen checksum 48 add put  % Put ascii for checksum at end of pad
        /barcode pad def                % barcode=pad
        /barlen barlen 1 add def        % barlen++
    } if

    % Create an array containing the character mappings
    /encs
    [ (3211) (2221) (2122) (1411) (1132)
      (1231) (1114) (1312) (1213) (3112)
      (111) (11111) (111)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    /sbs barlen 4 mul 11 add string def
    /txt barlen array def

    % Put the start character
    sbs 0 encs 10 get putinterval

    % Left side
    0 1 5 {
        % Lookup the encoding for the each barcode character
        /i exch def
        barcode i 1 getinterval barchars exch search
        pop                                % Discard true leaving pre
        length /indx exch def              % indx is the length of pre
        pop pop                            % Discard seek and post
        /enc encs indx get def             % Get the indxth encoding
        sbs i 4 mul 3 add enc putinterval  % Put encoded digit into sbs
        i 0 eq {      % First digit is before the guard bars
            txt 0 [barcode 0 1 getinterval -7 textpos textfont textsize 2 sub] put
        } {
            txt i [barcode i 1 getinterval i 7 mul 4 add textpos textfont textsize] put
        } ifelse
    } for

    % Put the middle character
    sbs 6 4 mul 3 add encs 11 get putinterval

    % Right side
    6 1 11 {
        % Lookup the encoding for the each barcode character
        /i exch def
        barcode i 1 getinterval barchars exch search
        pop                                % Discard true leaving pre
        length /indx exch def              % indx is the length of pre
        pop pop                            % Discard seek and post
        /enc encs indx get def             % Get the indxth encoding
        sbs i 4 mul 8 add enc putinterval  % Put encoded digit into sbs
        i 11 eq {       % Last digit is after guard bars
            txt 11 [barcode 11 1 getinterval 96 textpos textfont textsize 2 sub] put
        } {
            txt i [barcode i 1 getinterval i 7 mul 8 add textpos textfont textsize] put
        } ifelse
    } for

    % Put the end character
    sbs barlen 4 mul 8 add encs 12 get putinterval

    % Return the arguments
    /retval 4 dict def
    retval (sbs) [sbs {48 sub} forall] put
    includetext {
        retval (bhs) [4{height}repeat 10{height .075 sub}repeat height height 10{height .075 sub}repeat 5{height}repeat] put      
        retval (bbs) [0 0 0 0 10{.075}repeat 0 0 10{.075}repeat 0 0 0 0 0] put
        retval (txt) txt put
    } {
        retval (bhs) [31{height}repeat] put
        retval (bbs) [31{0}repeat] put
    } ifelse
    retval (opt) useropts put
    retval (borderbottom) 5 put
    retval

    end

} bind def
/upca load 0 1 dict put
% --END ENCODER upca--

% --BEGIN ENCODER upce--
/upce {

    0 begin

    /options exch def                   % We are given an option string
    /useropts options def
    /barcode exch def                   % We are given a barcode string

    /includetext false def               % Enable/disable text
    /textfont /Helvetica def
    /textsize 12 def
    /textpos -4 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    /barlen barcode length def          % Length of the code

    % Create an array containing the character mappings
    /encs
    [ (3211) (2221) (2122) (1411) (1132)
      (1231) (1114) (1312) (1213) (3112)
      (111) (1111111)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    /mirrormaps
    [ (000111) (001011) (001101) (001110) (010011)
      (011001) (011100) (010101) (010110) (011010)
    ] def

    % Add checksum digit to barcode if length is odd
    barlen 2 mod 0 ne {
        /pad barlen 1 add string def    % Create pad one bigger than barcode
        /checksum 0 def
        0 1 barlen 1 sub {
            /i exch def
            /barchar barcode i get 48 sub def
            i 2 mod 0 ne {
                /checksum barchar checksum add def
            } {
                /checksum barchar 3 mul checksum add def
            } ifelse
        } for
        /checksum 10 checksum 10 mod sub 10 mod def
        pad 0 barcode putinterval       % Add barcode to the start of the pad
        pad barlen checksum 48 add put  % Put ascii for checksum at end of pad
        /barcode pad def                % barcode=pad
        /barlen barlen 1 add def        % barlen++
    } if
    /txt barlen array def
    txt 0 [barcode 0 1 getinterval -7 textpos textfont textsize 2 sub] put

    % Determine the mirror map based on checksum
    /mirrormap mirrormaps barcode barlen 1 sub get 48 sub get def

    % Invert the mirrormap if we are using a non-zero number system
    barcode 0 get 48 eq {
        /invt mirrormap length string def
        0 1 mirrormap length 1 sub {
            /i exch def
            mirrormap i get 48 eq {
                invt i 49 put
            } {
                invt i 48 put
            } ifelse
        } for
        /mirrormap invt def
    } if

    /sbs barlen 2 sub 4 mul 10 add string def

    % Put the start character
    sbs 0 encs 10 get putinterval

    1 1 6 {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                            % Discard true leaving pre
        length /indx exch def          % indx is the length of pre
        pop pop                        % Discard seek and post
        /enc encs indx get def         % Get the indxth encoding
        mirrormap i 1 sub get 49 eq {  % Reverse enc if 1 in this position in mirrormap        
            /enclen enc length def
            /revenc enclen string def
            0 1 enclen 1 sub {
                /j exch def
                /char enc j get def
                revenc enclen j sub 1 sub char put
            } for
            /enc revenc def
        } if
        sbs i 1 sub 4 mul 3 add enc putinterval   % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 1 sub 7 mul 4 add textpos textfont textsize] put
    } for

    txt 7 [barcode 7 1 getinterval 6 7 mul 11 add textpos textfont textsize 2 sub] put

    % Put the end character
    sbs barlen 2 sub 4 mul 3 add encs 11 get putinterval

    % Return the arguments
    /retval 4 dict def
    retval (sbs) [sbs {48 sub} forall] put
    includetext {
        retval (bhs) [height height 12{height .075 sub}repeat height height height] put      
        retval (bbs) [0 0 12{.075}repeat 0 0 0] put    
        retval (txt) txt put
    } {
        retval (bhs) [17{height}repeat] put      
        retval (bbs) [17{0}repeat] put    
    } ifelse
    retval (opt) useropts put
    retval (borderbottom) 5 put
    retval

    end

} bind def
/upce load 0 1 dict put
% --END ENCODER upce--

% --BEGIN ENCODER ean5--
/ean5 {

    0 begin

    /options exch def                   % We are given an option string
    /useropts options def
    /barcode exch def                   % We are given a barcode string

    /includetext false def              % Enable/disable text
    /textfont /Helvetica def
    /textsize 12 def
    /textpos (unset) def
    /height 0.7 def    
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /height height cvr def
    textpos (unset) eq {
        /textpos height 72 mul 1 add def
    } {
        /textpos textpos cvr def
    } ifelse
    
    /barlen barcode length def          % Length of the code

    % Create an array containing the character mappings
    /encs
    [ (3211) (2221) (2122) (1411) (1132)
      (1231) (1114) (1312) (1213) (3112)
      (112) (11)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    % Determine the mirror map based on mod 10 checksum
    /mirrormaps
    [ (11000) (10100) (10010) (10001) (01100)
      (00110) (00011) (01010) (01001) (00101)
    ] def
    /checksum 0 def
    0 1 4 {
        /i exch def
        /barchar barcode i get 48 sub def
        i 2 mod 0 eq {
            /checksum barchar 3 mul checksum add def
        } {
            /checksum barchar 9 mul checksum add def
        } ifelse
    } for
    /checksum checksum 10 mod def
    /mirrormap mirrormaps checksum get def

    /sbs 31 string def
    /txt 5 array def
   
    0 1 4 {
        /i exch def

        % Prefix with either a start character or separator character
        i 0 eq {
            sbs 0 encs 10 get putinterval
        } {
            sbs i 1 sub 6 mul 7 add encs 11 get putinterval
        } ifelse

        % Lookup the encoding for the barcode character
        barcode i 1 getinterval barchars exch search
        pop                     % Discard true leaving pre
        length /indx exch def   % indx is the length of pre
        pop pop                 % Discard seek and post
        /enc encs indx get def  % Get the indxth encoding
        mirrormap i get 49 eq { % Reverse enc if 1 in this position in mirrormap
            /enclen enc length def
            /revenc enclen string def
            0 1 enclen 1 sub {
                /j exch def
                /char enc j get def
                revenc enclen j sub 1 sub char put
            } for
            /enc revenc def
        } if
        sbs i 6 mul 3 add enc putinterval   % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 1 sub 9 mul 13 add textpos textfont textsize] put
    } for

    % Return the arguments
    /retval 4 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [16{height}repeat] put
    retval (bbs) [16{0}repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval (guardrightpos) 10 put
    retval (guardrightypos) textpos 4 add put
    retval (bordertop) 10 put
    retval

    end

} bind def
/ean5 load 0 1 dict put
% --END ENCODER ean5--

% --BEGIN ENCODER ean2--
/ean2 {

    0 begin

    /options exch def                   % We are given an options string
    /useropts options def
    /barcode exch def                   % We are given a barcode string

    /includetext false def               % Enable/disable text
    /textfont /Helvetica def
    /textsize 12 def
    /textpos (unset) def
    /height 0.7 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /height height cvr def
    textpos (unset) eq {
        /textpos height 72 mul 1 add def
    } {
        /textpos textpos cvr def
    } ifelse
    
    /barlen barcode length def          % Length of the code

    % Create an array containing the character mappings
    /encs
    [ (3211) (2221) (2122) (1411) (1132)
      (1231) (1114) (1312) (1213) (3112)
      (112) (11)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    % Determine the mirror map based on mod 4 checksum
    /mirrormap [(00) (01) (10) (11)] barcode 0 2 getinterval cvi 4 mod get def

    /sbs 13 string def
    /txt 2 array def
    
    0 1 1 {
        /i exch def

        % Prefix with either a start character or separator character
        i 0 eq {
            sbs 0 encs 10 get putinterval
        } {
            sbs i 1 sub 6 mul 7 add encs 11 get putinterval
        } ifelse

        % Lookup the encoding for the barcode character
        barcode i 1 getinterval barchars exch search
        pop                     % Discard true leaving pre
        length /indx exch def   % indx is the length of pre
        pop pop                 % Discard seek and post
        /enc encs indx get def  % Get the indxth encoding
        mirrormap i get 49 eq { % Reverse enc if 1 in this position in mirrormap    
            /enclen enc length def
            /revenc enclen string def
            0 1 enclen 1 sub {
                /j exch def
                /char enc j get def
                revenc enclen j sub 1 sub char put
            } for
            /enc revenc def
        } if
        sbs i 6 mul 3 add enc putinterval   % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 1 sub 9 mul 13 add textpos textfont textsize] put
    } for

    % Return the arguments
    /retval 4 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [12{height}repeat] put
    retval (bbs) [12{0}repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval (guardrightpos) 10 put
    retval (guardrightypos) textpos 4 add put
    retval (bordertop) 10 put
    retval

    end

} bind def
/ean2 load 0 1 dict put
% --END ENCODER ean2--

% --BEGIN ENCODER isbn--
% --REQUIRES ean13--
/isbn {

    0 begin

    /options exch def      % We are given an options string
    /useropts options def
    /isbntxt exch def      % We are given the isbn text with dashes

    /includetext false def  % Enable/disable ISBN text
    /isbnfont /Courier def
    /isbnsize 9 def
    /isbnpos (unset) def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /isbnfont isbnfont cvlit def
    /isbnsize isbnsize cvr def
    /height height cvr def
    isbnpos (unset) eq {
        /isbnpos height 72 mul 3 add def
    } {
        /isbnpos isbnpos cvr def
    } ifelse
    
    % Read the digits from isbntxt and calculate checksums
    /isbn 13 string def
    /checksum10 0 def
    /checksum13 0 def
    /i 0 def /n 0 def
    { % loop
        /isbnchar isbntxt i get 48 sub def
        isbnchar -3 ne {     % Ignore dashes
            isbn n isbnchar 48 add put
            /checksum10 checksum10 10 n sub isbnchar mul add def
            n 2 mod 0 eq {
                /checksum13 isbnchar checksum13 add def
            } {
                /checksum13 isbnchar 3 mul checksum13 add def
            } ifelse
            /n n 1 add def
        } if
        /i i 1 add def
        i isbntxt length eq {exit} if
    } loop

    % Add the ISBN header to the isbntxt
    n 9 eq n 10 eq or {
        /checksum 11 checksum10 11 mod sub 11 mod def
        /isbn isbn 0 9 getinterval def
        /pad 18 string def
    } {
        /checksum 10 checksum13 10 mod sub 10 mod def
        /isbn isbn 0 12 getinterval def
        /pad 22 string def
    } ifelse
    pad 0 (ISBN ) putinterval
    pad 5 isbntxt putinterval  % Add isbntxt to the pad

    % Add checksum digit if isbntxt length is 11 or 15
    isbntxt length 11 eq isbntxt length 15 eq or {
        pad isbntxt length 5 add 45 put  % Put a dash
        checksum 10 eq {
            pad isbntxt length 6 add checksum 78 add put  % Check digit for 10 is X
        } {
            pad isbntxt length 6 add checksum 48 add put  % Put check digit
        } ifelse
    } if
    /isbntxt pad def                    % isbntxt=pad

    % Convert ISBN digits to EAN-13
    /barcode 12 string def
    isbn length 9 eq {        
        barcode 0 (978) putinterval
        barcode 3 isbn putinterval
    } {
        barcode 0 isbn putinterval
    } ifelse

    % Get the result of encoding with ean13    
    /args barcode options ean13 def

    % Add the ISBN text
    includetext {
        isbn length 9 eq {
            /isbnxpos -1 def
        } {
            /isbnxpos -12 def
        } ifelse
        args (txt) known {
            /txt args (txt) get def
            /newtxt txt length 1 add array def
            newtxt 0 txt putinterval
            newtxt newtxt length 1 sub [isbntxt isbnxpos isbnpos isbnfont isbnsize] put
            args (txt) newtxt put
        } {
            args (txt) [ [isbntxt isbnxpos isbnpos isbnfont isbnsize] ] put
        } ifelse
    } if

    args (opt) useropts put
    args

    end
 
} bind def
/isbn load 0 1 dict put
% --END ENCODER isbn--

% --BEGIN ENCODER code128--
/code128 {

    0 begin                  % Confine variables to local scope

    /options exch def        % We are given an option string
    /useropts options def
    /barcode exch def        % We are given a barcode string

    /includetext false def    % Enable/disable text
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (212222) (222122) (222221) (121223) (121322) (131222) (122213)
      (122312) (132212) (221213) (221312) (231212) (112232) (122132)
      (122231) (113222) (123122) (123221) (223211) (221132) (221231)
      (213212) (223112) (312131) (311222) (321122) (321221) (312212)
      (322112) (322211) (212123) (212321) (232121) (111323) (131123)
      (131321) (112313) (132113) (132311) (211313) (231113) (231311)
      (112133) (112331) (132131) (113123) (113321) (133121) (313121)
      (211331) (231131) (213113) (213311) (213131) (311123) (311321)
      (331121) (312113) (312311) (332111) (314111) (221411) (431111)
      (111224) (111422) (121124) (121421) (141122) (141221) (112214)
      (112412) (122114) (122411) (142112) (142211) (241211) (221114)
      (413111) (241112) (134111) (111242) (121142) (121241) (114212)
      (124112) (124211) (411212) (421112) (421211) (212141) (214121)
      (412121) (111143) (111341) (131141) (114113) (114311) (411113)
      (411311) (113141) (114131) (311141) (411131) (211412) (211214)
      (211232) (2331112)
    ] def

    % Create a string of the available characters for alphabets A and B
    /barchars ( !"#$%&'\(\)*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~) def
    /barlen barcode length def    % Length of the code
    /sbs barlen 6 mul string def  % sbs is 6 times length of barcode
    /txt barlen array def

    /mode -1 def         % A=0, B=1, C=2
    /checksum barcode 1 3 getinterval cvi def  % Initialise the checksum

    /i 0 def /j 0 def
    { % loop
        i barlen eq {exit} if
        barcode i 1 getinterval (^) eq {
            % indx is given by the next three characters
            /indx barcode i 1 add 3 getinterval cvi def
            txt j [( ) j 11 mul textpos textfont textsize] put
            /i i 4 add def
        } {
            % indx depends on the mode
            mode 2 eq {
                /indx barcode i 2 getinterval cvi def
                txt j [barcode i 2 getinterval j 11 mul textpos textfont textsize] put
                /i i 2 add def
            } {
                barchars barcode i 1 getinterval search
                pop                    % Discard true leaving pre
                length /indx exch def  % indx is the length of pre
                pop pop                % Discard seek and post
                txt j [barchars indx 1 getinterval j 11 mul textpos textfont textsize] put
                /i i 1 add def
            } ifelse
        } ifelse
        /enc encs indx get def         % Get the indxth encoding
        sbs j 6 mul enc putinterval    % Put encoded digit into sbs

        % Update the mode
        indx 101 eq indx 103 eq or {/mode 0 def} if
        indx 100 eq indx 104 eq or {/mode 1 def} if
        indx 99 eq indx 105 eq or {/mode 2 def} if

        /checksum indx j mul checksum add def  % checksum+=indx*j
        /j j 1 add def
    } loop

    % Put the checksum character
    /checksum checksum 103 mod def
    sbs j 6 mul encs checksum get putinterval

    % Put the end character
    sbs j 6 mul 6 add encs 106 get putinterval

    % Shrink sbs and txt to fit exactly
    /sbs sbs 0 j 6 mul 13 add getinterval def
    /txt txt 0 j getinterval def

    % Return the arguments
    /retval 1 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/code128 load 0 1 dict put
% --END ENCODER code128--

% --BEGIN ENCODER code39--
/code39 {

    0 begin                 % Confine variables to local scope

    /options exch def       % We are given an option string
    /useropts options def
    /barcode exch def       % We are given a barcode string

    /includecheck false def  % Enable/disable checkdigit
    /includetext false def
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (1113313111) (3113111131) (1133111131) (3133111111) (1113311131)
      (3113311111) (1133311111) (1113113131) (3113113111) (1133113111)
      (3111131131) (1131131131) (3131131111) (1111331131) (3111331111)
      (1131331111) (1111133131) (3111133111) (1131133111) (1111333111)
      (3111111331) (1131111331) (3131111311) (1111311331) (3111311311)
      (1131311311) (1111113331) (3111113311) (1131113311) (1111313311)
      (3311111131) (1331111131) (3331111111) (1311311131) (3311311111)
      (1331311111) (1311113131) (3311113111) (1331113111) (1313131111)
      (1313111311) (1311131311) (1113131311) (1311313111)
    ] def

    % Create a string of the available characters
    /barchars (0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*) def

    /barlen barcode length def  % Length of the code

    includecheck {
        /sbs barlen 10 mul 30 add string def
        /txt barlen 3 add array def
    } {
        /sbs barlen 10 mul 20 add string def
        /txt barlen 2 add array def
    } ifelse

    /checksum 0 def

    % Put the start character
    sbs 0 encs 43 get putinterval
    txt 0 [(*) 0 textpos textfont textsize] put

    0 1 barlen 1 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                                  % Discard true leaving pre
        length /indx exch def                % indx is the length of pre
        pop pop                              % Discard seek and post
        /enc encs indx get def               % Get the indxth encoding
        sbs i 10 mul 10 add enc putinterval  % Put encoded digit into sbs
        txt i 1 add [barcode i 1 getinterval i 1 add 16 mul textpos textfont textsize] put
        /checksum checksum indx add def
    } for

    % Put the checksum and end characters
    includecheck {
        /checksum checksum 43 mod def
        sbs barlen 10 mul 10 add encs checksum get putinterval
        includecheckintext {
            txt barlen 1 add [barchars checksum 1 getinterval barlen 1 add 16 mul textpos textfont textsize] put
        } {
            txt barlen 1 add [() barlen 1 add 16 mul textpos textfont textsize] put
        } ifelse
        sbs barlen 10 mul 20 add encs 43 get putinterval
        txt barlen 2 add [(*) barlen 2 add 16 mul textpos textfont textsize] put
    } {
        sbs barlen 10 mul 10 add encs 43 get putinterval
        txt barlen 1 add [(*) barlen 1 add 16 mul textpos textfont textsize] put
    } ifelse
    
    % Return the arguments
    /retval 2 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/code39 load 0 1 dict put
% --END ENCODER code39--

% --BEGIN ENCODER code93--
/code93 {

    0 begin                 % Confine variables to local scope

    /options exch def       % We are given an option string
    /useropts options def
    /barcode exch def       % We are given a barcode string

    /includecheck false def  % Enable/disable checkdigit
    /includetext false def   % Enable/disable text
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    /encs
    [ (131112) (111213) (111312) (111411) (121113)
      (121212) (121311) (111114) (131211) (141111)
      (211113) (211212) (211311) (221112) (221211)
      (231111) (112113) (112212) (112311) (122112)
      (132111) (111123) (111222) (111321) (121122)
      (131121) (212112) (212211) (211122) (211221)
      (221121) (222111) (112122) (112221) (122121)
      (123111) (121131) (311112) (311211) (321111)
      (112131) (113121) (211131) (121221) (312111)
      (311121) (122211) (111141) (1111411)
    ] def

    % Create a string of the available characters
    /barchars (0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%) def

    /barlen barcode length def  % Length of the code    
    barcode {
        (^) search false eq {pop exit} if
        pop pop /barlen barlen 3 sub def
    } loop

    includecheck {
        /sbs barlen 6 mul 25 add string def
    } {
        /sbs barlen 6 mul 13 add string def
    } ifelse
    /txt barlen array def
    
    % Put the start character
    sbs 0 encs 47 get putinterval
    
    /checksum1 0 def /checksum2 0 def

    /i 0 def /j 0 def
    { % loop
        j barlen eq {exit} if
        barcode i 1 getinterval (^) eq {
            % indx is given by the next three characters
            /indx barcode i 1 add 3 getinterval cvi def
            txt j [( ) j 9 mul 9 add textpos textfont textsize] put
            /i i 4 add def
        } {
            barchars barcode i 1 getinterval search
            pop                         % Discard true leaving pre
            length /indx exch def       % indx is the length of pre
            pop pop                     % Discard seek and post
            txt j [barchars indx 1 getinterval j 9 mul 9 add textpos textfont textsize] put
            /i i 1 add def
        } ifelse
        /enc encs indx get def             % Get the indxth encoding
        sbs j 6 mul 6 add enc putinterval  % Put encoded digit into sbs
        /checksum1 checksum1 barlen j sub 1 sub 20 mod 1 add indx mul add def
        /checksum2 checksum2 barlen j sub 15 mod 1 add indx mul add def
        /j j 1 add def
    } loop
    
    includecheck {
        % Put the first checksum character
        /checksum1 checksum1 47 mod def
        /checksum2 checksum2 checksum1 add 47 mod def
        sbs j 6 mul 6 add encs checksum1 get putinterval
        sbs j 6 mul 12 add encs checksum2 get putinterval
        % Put the end character
        sbs j 6 mul 18 add encs 48 get putinterval
    } {
        % Put the end character
        sbs j 6 mul 6 add encs 48 get putinterval      
    } ifelse

    % Return the arguments
    /retval 1 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/code93 load 0 1 dict put
% --END ENCODER code93--

% --BEGIN ENCODER interleaved2of5--
/interleaved2of5 {

    0 begin         % Confine variables to local scope

    /options exch def               % We are given an option string
    /useropts options def
    /barcode exch def               % We are given a barcode string

    /includecheck false def         % Enable/disable checkdigit
    /includetext false def          % Enable/disable text
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    /barlen barcode length def      % Length of the code

    % Prefix 0 to barcode if length is even and including checkdigit
    % or length is odd and not including checkdigit
    barlen 2 mod 0 eq includecheck and          % even & includecheck
    barlen 2 mod 0 ne includecheck not and or { % odd  & !includecheck
        /pad barlen 1 add string def  % Create pad one bigger than barcode
        pad 0 48 put                  % Put ascii 0 at start of pad
        pad 1 barcode putinterval     % Add barcode to the end of pad
        /barcode pad def              % barcode=pad
        /barlen barlen 1 add def      % barlen++
    } if

    % Add checksum to end of barcode
    includecheck {
        /checksum 0 def
        0 1 barlen 1 sub {
            /i exch def
            i 2 mod 0 eq {
                /checksum checksum barcode i get 48 sub 3 mul add def
            } {
                /checksum checksum barcode i get 48 sub add def
            } ifelse
        } for
        /checksum 10 checksum 10 mod sub 10 mod def
        /pad barlen 1 add string def    % Create pad one bigger than barcode
        pad 0 barcode putinterval       % Add barcode to the start of pad
        pad barlen checksum 48 add put  % Add checksum to end of pad
        /barcode pad def                % barcode=pad
        /barlen barlen 1 add def        % barlen++
    } if

    % Create an array containing the character mappings
    /encs
    [ (11331) (31113) (13113) (33111) (11313)
      (31311) (13311) (11133) (31131) (13131)
      (1111)  (3111)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def
    /sbs barlen 5 mul 8 add string def
    /txt barlen array def

    % Put the start character
    sbs 0 encs 10 get putinterval

    0 2 barlen 1 sub {
    /i exch def
        % Lookup the encodings for two consecutive barcode characters
        barcode i 1 getinterval barchars exch search
        pop                           % Discard true leaving pre
        length /indx exch def         % indx is the length of pre
        pop pop                       % Discard seek and post
        /enca encs indx get def       % Get the indxth encoding

        barcode i 1 add 1 getinterval barchars exch search
        pop                           % Discard true leaving pre
        length /indx exch def         % indx is the length of pre
        pop pop                       % Discard seek and post
        /encb encs indx get def       % Get the indxth encoding

        % Interleave the two character encodings
        /intl enca length 2 mul string def
        0 1 enca length 1 sub {
            /j exch def
            /achar enca j get def
            /bchar encb j get def
            intl j 2 mul achar put
            intl j 2 mul 1 add bchar put
        } for

        sbs i 5 mul 4 add intl putinterval   % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 9 mul 4 add textpos textfont textsize] put
        includecheck includecheckintext not and barlen 2 sub i eq and {
            txt i 1 add [( ) i 1 add 9 mul 4 add textpos textfont textsize] put
        } {
            txt i 1 add [barcode i 1 add 1 getinterval i 1 add 9 mul 4 add textpos textfont textsize] put
        } ifelse
    } for

    % Put the end character
    sbs barlen 5 mul 4 add encs 11 get putinterval

    % Return the arguments
    /retval 1 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/interleaved2of5 load 0 1 dict put
% --END ENCODER interleaved2of5--

% --BEGIN ENCODER rss14--
/rss14 {

    0 begin            % Confine variables to local scope

    /options exch def  % We are given an option string
    /useropts options def
    /barcode exch def  % We are given a barcode string

    /height 1 def
    /linkage false def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /height height cvr def

    /getRSSwidths {     
        /mw exch def
        /nm exch def
        /val exch def
        /j 0 def /i 0 def {
            /v () def
            mw 1 ne {/v i mw 4 string cvrs def} if          
            0 v {48 sub add} forall 4 add nm eq {               
                j val eq {exit} if
                /j j 1 add def
            } if
            /i i 1 add def
        } loop
        [4 {1} repeat v {47 sub} forall] v length 4 getinterval
    } bind def

    /binval [barcode {48 sub} forall] def
    /binval [linkage {1} {0} ifelse binval 0 13 getinterval {} forall] def
    
    0 1 12 {
        /i exch def
        binval i 1 add 2 copy get binval i get 4537077 mod 10 mul add put
        binval i binval i get 4537077 idiv put
    } for
    /right binval 13 get 4537077 mod def
    binval 13 2 copy get 4537077 idiv put

    /left 0 def
    /i true def
    0 1 13 {
        /j exch def
        binval j get
        dup 0 eq i and {
            pop
        } {
            /i false def
            /left left 3 -1 roll 10 13 j sub exp cvi mul add def
        } ifelse
    } for
    
    /d1 left 1597 idiv def
    /d2 left 1597 mod def
    /d3 right 1597 idiv def
    /d4 right 1597 mod def

    /tab164 [
        160   0     12 4   8 1  161   1
        960   161   10 6   6 3  80   10
        2014  961   8  8   4 5  31   34
        2714  2015  6  10  3 6  10   70
        2840  2715  4  12  1 8  1    126
    ] def

    /tab154 [
        335   0     5  10  2 7  4   84
        1035  336   7  8   4 5  20  35
        1515  1036  9  6   6 3  48  10
        1596  1516  11 4   8 1  81  1
    ] def

    /i 0 def {
        d1 tab164 i get le {
            tab164 i 1 add 7 getinterval {} forall
            /d1te exch def /d1to exch def
            /d1mwe exch def /d1mwo exch def
            /d1ele exch def /d1elo exch def
            /d1gs exch def
            exit
        } if
        /i i 8 add def
    } loop

    /i 0 def {
        d2 tab154 i get le {
            tab154 i 1 add 7 getinterval {} forall
            /d2te exch def /d2to exch def
            /d2mwe exch def /d2mwo exch def
            /d2ele exch def /d2elo exch def
            /d2gs exch def
            exit
        } if
        /i i 8 add def
    } loop

    /i 0 def {
        d3 tab164 i get le {
            tab164 i 1 add 7 getinterval {} forall
            /d3te exch def /d3to exch def
            /d3mwe exch def /d3mwo exch def
            /d3ele exch def /d3elo exch def
            /d3gs exch def
            exit
        } if
        /i i 8 add def
    } loop

    /i 0 def {
        d4 tab154 i get le {
            tab154 i 1 add 7 getinterval {} forall
            /d4te exch def /d4to exch def
            /d4mwe exch def /d4mwo exch def
            /d4ele exch def /d4elo exch def
            /d4gs exch def
            exit
        } if
        /i i 8 add def
    } loop
    
    /d1wo d1 d1gs sub d1te idiv d1elo d1mwo getRSSwidths def
    /d1we d1 d1gs sub d1te mod d1ele d1mwe getRSSwidths def
    /d2wo d2 d2gs sub d2to mod d2elo d2mwo getRSSwidths def
    /d2we d2 d2gs sub d2to idiv d2ele d2mwe getRSSwidths def
    /d3wo d3 d3gs sub d3te idiv d3elo d3mwo getRSSwidths def
    /d3we d3 d3gs sub d3te mod d3ele d3mwe getRSSwidths def
    /d4wo d4 d4gs sub d4to mod d4elo d4mwo getRSSwidths def
    /d4we d4 d4gs sub d4to idiv d4ele d4mwe getRSSwidths def

    /d1w 8 array def
    0 1 3 {
        /i exch def
        d1w i 2 mul d1wo i get put
        d1w i 2 mul 1 add d1we i get put
    } for

    /d2w 8 array def
    0 1 3 {
        /i exch def
        d2w 7 i 2 mul sub d2wo i get put
        d2w 6 i 2 mul sub d2we i get put
    } for
    
    /d3w 8 array def
    0 1 3 {
        /i exch def
        d3w 7 i 2 mul sub d3wo i get put
        d3w 6 i 2 mul sub d3we i get put
    } for
    
    /d4w 8 array def
    0 1 3 {
        /i exch def
        d4w i 2 mul d4wo i get put
        d4w i 2 mul 1 add d4we i get put
    } for

    /widths [
        d1w {} forall
        d2w {} forall
        d3w {} forall
        d4w {} forall
    ] def
    
    /checkweights [
        1   3   9   27  2   6   18  54
        58  72  24  8   29  36  12  4
        74  51  17  32  37  65  48  16
        64  34  23  69  49  68  46  59
    ] def

    /checkwidths [
        3 8 2 1 1   3 5 5 1 1   3 3 7 1 1
        3 1 9 1 1   2 7 4 1 1   2 5 6 1 1
        2 3 8 1 1   1 5 7 1 1   1 3 9 1 1
    ] def
    
    /checksum 0 def
    0 1 31 {
        /i exch def
        /checksum checksum widths i get checkweights i get mul add def 
    } for
    /checksum checksum 79 mod def    
    checksum 8 ge {/checksum checksum 1 add def} if
    checksum 72 ge {/checksum checksum 1 add def} if
    /checklt checkwidths checksum 9 idiv 5 mul 5 getinterval def
    /checkrtrev checkwidths checksum 9 mod 5 mul 5 getinterval def
    /checkrt 5 array def
    0 1 4 {
        /i exch def
        checkrt i checkrtrev 4 i sub get put
    } for

    /sbs [
        1 d1w {} forall checklt {} forall d2w {}
        forall d4w {} forall checkrt {} forall d3w {} forall 1 1
    ] def
    
    % Return the arguments
    /retval 1 dict def
    retval (sbs) sbs put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put   
    retval (opt) useropts put
    retval

    end

} bind def
/rss14 load 0 1 dict put
% --END ENCODER rss14--

% --BEGIN ENCODER rsslimited--
/rsslimited {

    0 begin            % Confine variables to local scope

    /options exch def  % We are given an option string
    /useropts options def
    /barcode exch def  % We are given a barcode string

    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /height height cvr def

    /getRSSwidths {
        /el exch def
        /mw exch def
        /nm exch def
        /val exch def
        /j 0 def /i 0 def {
            /v () def
            mw 1 ne {/v i mw el string cvrs def} if          
            0 v {48 sub add} forall el add nm eq {               
                j val eq {exit} if
                /j j 1 add def
            } if
            /i i 1 add def
        } loop
        [el {1} repeat v {47 sub} forall] v length el getinterval
    } bind def
    
    /binval [barcode {48 sub} forall] def
    /binval [binval 0 13 getinterval {} forall] def
    
    0 1 11 {
        /i exch def
        binval i 1 add 2 copy get binval i get 2013571 mod 10 mul add put
        binval i binval i get 2013571 idiv put
    } for
    /d2 binval 12 get 2013571 mod def
    binval 12 2 copy get 2013571 idiv put

    /d1 0 def
    /i true def
    0 1 12 {
        /j exch def
        binval j get
        dup 0 eq i and {
            pop
        } {
            /i false def
            /d1 d1 3 -1 roll 10 12 j sub exp cvi mul add def
        } ifelse
    } for
    
    /tab267 [
        183063   0        17 9   6 3  6538   28
        820063   183064   13 13  5 4  875    728
        1000775  820064   9  17  3 6  28     6454
        1491020  1000776  15 11  5 4  2415   203
        1979844  1491021  11 15  4 5  203    2408
        1996938  1979845  19 7   8 1  17094  1
        2013570  1996939  7  19  1 8  1      16632
    ] def

    /i 0 def {
        d1 tab267 i get le {
            tab267 i 1 add 7 getinterval {} forall
            /d1te exch def /d1to exch def
            /d1mwe exch def /d1mwo exch def
            /d1ele exch def /d1elo exch def
            /d1gs exch def
            exit
        } if
        /i i 8 add def
    } loop

    /i 0 def {
        d2 tab267 i get le {
            tab267 i 1 add 7 getinterval {} forall
            /d2te exch def /d2to exch def
            /d2mwe exch def /d2mwo exch def
            /d2ele exch def /d2elo exch def
            /d2gs exch def
            exit
        } if
        /i i 8 add def
    } loop
    
    /d1wo d1 d1gs sub d1te idiv d1elo d1mwo 7 getRSSwidths def    
    /d1we d1 d1gs sub d1te mod d1ele d1mwe 7 getRSSwidths def
    /d2wo d2 d2gs sub d2te idiv d2elo d2mwo 7 getRSSwidths def    
    /d2we d2 d2gs sub d2te mod d2ele d2mwe 7 getRSSwidths def
    
    /d1w 14 array def
    0 1 6 {
        /i exch def
        d1w i 2 mul d1wo i get put
        d1w i 2 mul 1 add d1we i get put
    } for

    /d2w 14 array def
    0 1 6 {
        /i exch def
        d2w i 2 mul d2wo i get put
        d2w i 2 mul 1 add d2we i get put
    } for

    /widths [
        d1w {} forall
        d2w {} forall
    ] def
    
    /checkweights [
        1  3  9  27 81 65 17 51 64 14 42 37 22 66
        20 60 2  6  18 54 73 41 34 13 39 28 84 74
    ] def

    /checkseq [
        0 1 43 {} for
        45 52 57
        63 1 66 {} for
        73 1 79 {} for
        82
        126 1 130 {} for
        132
        141 1 146 {} for
        210 1 217 {} for
        220
        316 1 323 {} for
        326 337
    ] def
    
    /checksum 0 def
    0 1 27 {
        /i exch def
        /checksum checksum widths i get checkweights i get mul add def
    } for
    /checksum checksum 89 mod def
    /seq checkseq checksum get def
    /swidths seq 21 idiv 8 3 6 getRSSwidths def
    /bwidths seq 21 mod 8 3 6 getRSSwidths def

    /checkwidths [0 0 0 0 0 0 0 0 0 0 0 0 1 1] def
    0 1 5 {
        /i exch def
        checkwidths i 2 mul swidths i get put
        checkwidths i 2 mul 1 add bwidths i get put
    } for
    
    /sbs [
        1 d1w {} forall checkwidths {} forall d2w {} forall 1 1
    ] def
    
    % Return the arguments
    /retval 1 dict def
    retval (sbs) sbs put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put   
    retval (opt) useropts put
    retval

    end

} bind def
/rsslimited load 0 1 dict put
% --END ENCODER rsslimited--

% --BEGIN ENCODER rssexpanded--
/rssexpanded {

    0 begin            % Confine variables to local scope

    /options exch def  % We are given an option string
    /useropts options def
    /barcode exch def  % We are given a barcode string

    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /height height cvr def

    /getRSSwidths {     
        /mw exch def
        /nm exch def
        /val exch def
        /j 0 def /i 0 def {
            /v () def
            mw 1 ne {/v i mw 4 string cvrs def} if          
            0 v {48 sub add} forall 4 add nm eq {               
                j val eq {exit} if
                /j j 1 add def
            } if
            /i i 1 add def
        } loop
        [4 {1} repeat v {47 sub} forall] v length 4 getinterval
    } bind def

    /binval [barcode {48 sub} forall] def
    /datalen binval length 12 idiv def
    
    /tab174 [
        347   0     12 5   7 2  87  4
        1387  348   10 7   5 4  52  20
        2947  1388  8  9   4 5  30  52
        3987  2948  6  11  3 6  10  104
        4191  3988  4  13  1 8  1   204
    ] def

    /dxw datalen array def
    
    0 1 datalen 1 sub {

        /x exch def

        /d binval x 12 mul 12 getinterval def
        /d 0 0 1 11 {/j exch def 2 11 j sub exp cvi d j get mul add} for def

        /j 0 def {
            d tab174 j get le {
                tab174 j 1 add 7 getinterval {} forall
                /dte exch def /dto exch def
                /dmwe exch def /dmwo exch def
                /dele exch def /delo exch def
                /dgs exch def
                exit
            } if
            /j j 8 add def
        } loop

        /dwo d dgs sub dte idiv delo dmwo getRSSwidths def
        /dwe d dgs sub dte mod dele dmwe getRSSwidths def

        /dw 8 array def        
        x 2 mod 0 eq {                    
            0 1 3 {
                /j exch def
                dw 7 j 2 mul sub dwo j get put
                dw 6 j 2 mul sub dwe j get put
            } for
        } {           
            0 1 3 {
                /j exch def
                dw j 2 mul dwo j get put
                dw j 2 mul 1 add dwe j get put
            } for
        } ifelse

        dxw x dw put

    } for
    
    /widths [
        dxw {{} forall} forall
    ] def

    /checkweights [
        77   96   32   81   27   9    3    1
        20   60   180  118  143  7    21   63
        205  209  140  117  39   13   145  189
        193  157  49   147  19   57   171  91
        132  44   85   169  197  136  186  62
        185  133  188  142  4    12   36   108
        50   87   29   80   97   173  128  113
        150  28   84   41   123  158  52   156
        166  196  206  139  187  203  138  46
        76   17   51   153  37   111  122  155
        146  119  110  107  106  176  129  43
        16   48   144  10   30   90   59   177
        164  125  112  178  200  137  116  109
        70   210  208  202  184  130  179  115
        190  204  68   93   31   151  191  134
        148  22   66   198  172  94   71   2
        40   154  192  64   162  54   18   6
        120  149  25   75   14   42   126  167
        175  199  207  69   23   78   26   79
        103  98   83   38   114  131  182  124
        159  53   88   170  127  183  61   161
        55   165  73   8    24   72   5    15
        89   100  174  58   160  194  135  45
    ] def
    
    /checksum 0 def
    0 1 widths length 1 sub {
        /i exch def
        /checksum checksum widths i get checkweights i get mul add def 
    } for
    /checksum checksum 211 mod datalen 3 sub 211 mul add def

    /i 0 def {
        checksum tab174 i get le {
            tab174 i 1 add 7 getinterval {} forall
            /cte exch def /cto exch def
            /cmwe exch def /cmwo exch def
            /cele exch def /celo exch def
            /cgs exch def
            exit
        } if
        /i i 8 add def
    } loop

    /cwo checksum cgs sub cte idiv celo cmwo getRSSwidths def
    /cwe checksum cgs sub cte mod cele cmwe getRSSwidths def
    
    /cw 8 array def        
    0 1 3 {
        /i exch def
        cw i 2 mul cwo i get put
        cw i 2 mul 1 add cwe i get put
    } for
    
    /finderwidths [
        1 8 4 1 1    1 1 4 8 1
        3 6 4 1 1    1 1 4 6 3
        3 4 6 1 1    1 1 6 4 3
        3 2 8 1 1    1 1 8 2 3
        2 6 5 1 1    1 1 5 6 2
        2 2 9 1 1    1 1 9 2 2
    ] def

    /finderseq [
        [0 1]
        [0 3 2]
        [0 5 2 7]
        [0 9 2 7 4]
        [0 9 2 7 6 11]
        [0 9 2 7 8 11 10]
        [0 1 2 3 4 5 6 7]
        [0 1 2 3 4 5 6 9 8]
        [0 1 2 3 4 5 6 9 10 11]
        [0 1 2 3 4 7 6 9 8 11 10]
    ] def

    /seq finderseq datalen 2 add 2 idiv 2 sub get def
    /fxw seq length array def
    0 1 seq length 1 sub {
        /x exch def
        fxw x finderwidths seq x get 5 mul 5 getinterval put
    } for
    
    /sbs [
        1
        cw {} forall
        0 1 datalen 1 sub {
            /i exch def
            i 2 mod 0 eq {fxw i 2 idiv get {} forall} if
            dxw i get {} forall
        } for
        1 1
    ] def
    
    % Return the arguments
    /retval 1 dict def
    retval (sbs) sbs put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put   
    retval (opt) useropts put
    retval

    end

} bind def
/rssexpanded load 0 1 dict put
% --END ENCODER rssexpanded--

% --BEGIN ENCODER code2of5--
/code2of5 {

    % Thanks to Michael Landers

    0 begin                 % Confine variable to local scope

    /options exch def       % We are given an option string
    /useropts options def
    /barcode exch def       % We are given a barcode string

    /includecheck false def
    /includetext false def   % Enable/disable text
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (1111313111) (3111111131) (1131111131) (3131111111)
      (1111311131) (3111311111) (1131311111) (1111113131)
      (3111113111) (1131113111) (313111) (311131)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    /barlen barcode length def            % Length of the code

    includecheck {
        /sbs barlen 10 mul 22 add string def
        /txt barlen 1 add array def
    } {
        /sbs barlen 10 mul 12 add string def
        /txt barlen array def
    } ifelse
    
    % Put the start character
    sbs 0 encs 10 get putinterval

    /checksum 0 def
    
    0 1 barlen 1 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                                 % Discard true leaving pre
        length /indx exch def               % indx is the length of pre
        pop pop                             % Discard seek and post
        /enc encs indx get def              % Get the indxth encoding
        sbs i 10 mul 6 add enc putinterval  % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 14 mul 10 add textpos textfont textsize] put
        barlen i sub 2 mod 0 eq {
            /checksum checksum indx add def
        } {            
            /checksum checksum indx 3 mul add def
        } ifelse        
    } for
    
    % Put the checksum and end characters
    includecheck {
        /checksum 10 checksum 10 mod sub 10 mod def
        sbs barlen 10 mul 6 add encs checksum get putinterval
        sbs barlen 10 mul 16 add encs 11 get putinterval
        includecheckintext {
            txt barlen [barchars checksum 1 getinterval barlen 14 mul 10 add textpos textfont textsize] put
        } {            
            txt barlen [( ) barlen 14 mul 10 add textpos textfont textsize] put
        } ifelse
    } {
        sbs barlen 10 mul 6 add encs 11 get putinterval
    } ifelse
    
    % Return the arguments
    /retval 1 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/code2of5 load 0 1 dict put
% --END ENCODER code2of5--

% --BEGIN ENCODER code11--
/code11 {

    0 begin            % Confine variables to local scope

    /options exch def  % We are given an option string
    /useropts options def
    /barcode exch def  % We are given a barcode string

    /includecheck false def
    /includetext false def
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (111131) (311131) (131131) (331111) (113131)
      (313111) (133111) (111331) (311311) (311111)
      (113111) (113311)
    ] def

    % Create a string of the available characters
    /barchars (0123456789-) def

    /barlen barcode length def        % Length of the code

    includecheck {
        barlen 10 ge {
            /sbs barlen 6 mul 24 add string def
            /txt barlen 2 add array def
        } {
            /sbs barlen 6 mul 18 add string def
            /txt barlen 1 add array def
        } ifelse
    } {
        /sbs barlen 6 mul 12 add string def
        /txt barlen array def
    } ifelse

    % Put the start character
    sbs 0 encs 10 get putinterval

    /checksum1 0 def /checksum2 0 def
    
    /xpos 8 def
    0 1 barlen 1 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                                % Discard true leaving pre
        length /indx exch def              % indx is the length of pre
        pop pop                            % Discard seek and post
        /enc encs indx get def             % Get the indxth encoding
        sbs i 6 mul 6 add enc putinterval  % Put encoded digit into sbs
        txt i [barcode i 1 getinterval xpos textpos textfont textsize] put
        0 1 5 {       % xpos+=width of the character
            /xpos exch enc exch get 48 sub xpos add def
        } for
        /checksum1 checksum1 barlen i sub 1 sub 10 mod 1 add indx mul add def
        /checksum2 checksum2 barlen i sub 9 mod 1 add indx mul add def
    } for
   
    % Put the checksum and end characters
    includecheck {
        /checksum1 checksum1 11 mod def        
        barlen 10 ge {
            /checksum2 checksum2 checksum1 add 11 mod def
            sbs barlen 6 mul 6 add encs checksum1 get putinterval        
            sbs barlen 6 mul 12 add encs checksum2 get putinterval
            includecheckintext {
                txt barlen [barchars checksum1 1 getinterval xpos textpos textfont textsize] put
                /enc encs checksum1 get def   
                0 1 5 {       % xpos+=width of the character
                    /xpos exch enc exch get 48 sub xpos add def
                } for
                txt barlen 1 add [barchars checksum2 1 getinterval xpos textpos textfont textsize] put
            } {
                txt barlen [() xpos textpos textfont textsize] put
                txt barlen 1 add [() xpos textpos textfont textsize] put
            } ifelse
            sbs barlen 6 mul 18 add encs 11 get putinterval
        } {
            sbs barlen 6 mul 6 add encs checksum1 get putinterval          
            includecheckintext {
                txt barlen [barchars checksum1 1 getinterval xpos textpos textfont textsize] put
            } {
                txt barlen [() xpos textpos textfont textsize] put
            } ifelse
            sbs barlen 6 mul 12 add encs 11 get putinterval
        } ifelse
    } {
        sbs barlen 6 mul 6 add encs 11 get putinterval
    } ifelse

    % Return the arguments
    /retval 1 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/code11 load 0 1 dict put
% --END ENCODER code11--

% --BEGIN ENCODER rationalizedCodabar--
/rationalizedCodabar {

    0 begin                    % Confine variables to local scope

    /options exch def          % We are given an option string
    /useropts options def
    /barcode exch def          % We are given a barcode string

    /includecheck false def     % Enable/disable checkdigit
    /includetext false def      % Enable/disable text
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (11111331) (11113311) (11131131) (33111111) (11311311)
      (31111311) (13111131) (13113111) (13311111) (31131111)
      (11133111) (11331111) (31113131) (31311131) (31313111)
      (11313131) (11331311) (13131131) (11131331) (11133311)
    ] def

    % Create a string of the available characters
    /barchars (0123456789-$:/.+ABCD) def

    /barlen barcode length def    % Length of the code

    includecheck {
        /sbs barlen 8 mul 8 add string def
        /txt barlen 1 add array def
    } {
        /sbs barlen 8 mul string def
        /txt barlen array def
    } ifelse

    /checksum 0 def
    /xpos 0 def
    0 1 barlen 2 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                          % Discard true leaving pre
        length /indx exch def        % indx is the length of pre
        pop pop                      % Discard seek and post
        /enc encs indx get def       % Get the indxth encoding
        sbs i 8 mul enc putinterval  % Put encoded digit into sbs
        txt i [barcode i 1 getinterval xpos textpos textfont textsize] put
        0 1 7 {       % xpos+=width of the character
            /xpos exch enc exch get 48 sub xpos add def
        } for
        /checksum checksum indx add def
    } for

    % Find index of last character
    barcode barlen 1 sub 1 getinterval barchars exch search
    pop                          % Discard true leaving pre
    length /indx exch def        % indx is the length of pre
    pop pop                      % Discard seek and post

    includecheck {
        % Put the checksum character
        /checksum checksum indx add def
        /checksum 16 checksum 16 mod sub 16 mod def
        sbs barlen 8 mul 8 sub encs checksum get putinterval
        includecheckintext {
            txt barlen 1 sub [barchars checksum 1 getinterval xpos textpos textfont textsize] put
        } {
            txt barlen 1 sub [( ) xpos textpos textfont textsize] put
        } ifelse
        0 1 7 {       % xpos+=width of the character
            /xpos exch encs checksum get exch get 48 sub xpos add def
        } for
        % Put the end character
        /enc encs indx get def            % Get the indxth encoding
        sbs barlen 8 mul enc putinterval  % Put encoded digit into sbs
        txt barlen [barcode barlen 1 sub 1 getinterval xpos textpos textfont textsize] put
    } {
        % Put the end character
        /enc encs indx get def                  % Get the indxth encoding
        sbs barlen 8 mul 8 sub enc putinterval  % Put encoded digit into sbs
        txt barlen 1 sub [barcode barlen 1 sub 1 getinterval xpos textpos textfont textsize] put
    } ifelse

    % Return the arguments
    /retval 1 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/rationalizedCodabar load 0 1 dict put
% --END ENCODER rationalizedCodabar--

% --BEGIN ENCODER onecode--
/onecode {

    0 begin

    /options exch def              % We are given an option string
    /useropts options def
    /barcode exch def              % We are given a barcode string

    /height 0.175 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /height height cvr def

    /barlen barcode length def

    /normalize {
        /base exch def
        /num exch def
        num length 1 sub -1 1 {
            /i exch def        
            num i 1 sub 2 copy get num i get base idiv add put
            num i num i get base mod put
        } for
        { %loop - extend input as necessary
            num 0 get base lt {exit} if
            /num [0 num {} forall] def        
            num 0 num 0 get num 1 get base idiv add put
            num 1 num 1 get base mod put
        } loop
        % Trim leading zeros
        /num [/i true def num {dup 0 eq i and {pop} {/i false def} ifelse} forall] def   
        num length 0 eq {/num [0] def} if
        num
    } bind def

    /bigadd {
        2 copy length exch length
        2 copy sub abs /offset exch def
        lt {exch} if
        /a exch def /b exch def    
        0 1 b length 1 sub {
            dup a exch offset add 2 copy get b 5 -1 roll get add put
        } for
        a
    } bind def

    % Conversion of data fields into binary data
    barlen 20 eq {[0]} if
    barlen 25 eq {[1]} if
    barlen 29 eq {[1 0 0 0 0 1]} if
    barlen 31 eq {[1 0 0 0 1 0 0 0 0 1]} if
    /binval exch [barcode 20 barlen 20 sub getinterval {48 sub} forall] bigadd def
    /binval [binval {} forall barcode 0 get 48 sub] def
    /binval [binval {5 mul} forall] [barcode 1 get 48 sub] bigadd 10 normalize def
    /binval [binval {} forall barcode 2 18 getinterval {48 sub} forall] def

    % Conversion of binary data into byte array
    /bytes 13 array def
    /bintmp [binval {} forall] def
    12 -1 0 {
        /i exch def
        0 1 bintmp length 2 sub {
            /j exch def
            bintmp j 1 add 2 copy get bintmp j get 256 mod 10 mul add put
            bintmp j bintmp j get 256 idiv put
        } for
        bytes i bintmp bintmp length 1 sub get 256 mod put
        bintmp bintmp length 1 sub 2 copy get 256 idiv put    
    } for

    % Generation of 11-bit CRC on byte array
    /fcs 2047 def
    /dat bytes 0 get 5 bitshift def
    6 {
        fcs dat xor 1024 and 0 ne {
            /fcs fcs 1 bitshift 3893 xor def 
        } {
            /fcs fcs 1 bitshift def
        } ifelse
        /fcs fcs 2047 and def
        /dat dat 1 bitshift def
    } repeat
    1 1 12 {
        bytes exch get 3 bitshift /dat exch def    
        8 {        
            fcs dat xor 1024 and 0 ne {
                /fcs fcs 1 bitshift 3893 xor def 
            } {
                /fcs fcs 1 bitshift def
            } ifelse
            /fcs fcs 2047 and def
            /dat dat 1 bitshift def
        } repeat
    } for

    % Conversion from binary data to codewords
    /codewords 10 array def
    9 -1 0 {
        /i exch def
        i 9 eq {
            /b 636 def
        } {
            /b 1365 def
        } ifelse
        0 1 binval length 2 sub {
            /j exch def
            binval j 1 add 2 copy get binval j get b mod 10 mul add put
            binval j binval j get b idiv put
        } for   
        codewords i binval binval length 1 sub get b mod put
        binval binval length 1 sub 2 copy get b idiv put
    } for

    % Inserting additional information into codewords
    codewords 9 codewords 9 get 2 mul put
    fcs 1024 and 0 ne {
        codewords 0 codewords 0 get 659 add put
    } if

    % Conversion from codewords to characters
    /tab513 1287 dict def
    /lo 0 def
    /hi 1286 def
    0 1 8191 {   
        { % no loop - provides common exit point
            /i exch def
            /onbits 0 def
            0 1 12 {           
                i exch 1 exch bitshift and 0 ne {
                    /onbits onbits 1 add def
                } if
            } for
            onbits 5 ne {exit} if
            /j i def
            /rev 0 def
            16 {            
                /rev rev 1 bitshift j 1 and or def
                /j j -1 bitshift def                
            } repeat          
            /rev rev -3 bitshift def            
            rev i lt {exit} if
            rev i eq {
                tab513 hi i put
                /hi hi 1 sub def
            } {
                tab513 lo i put
                tab513 lo 1 add rev put
                /lo lo 2 add def                      
            } ifelse
            exit
        } loop
    } for

    /tab213 78 dict def
    /lo 0 def
    /hi 77 def
    0 1 8191 {   
        { % no loop - provides common exit point
            /i exch def
            /onbits 0 def
            0 1 12 {           
                i exch 1 exch bitshift and 0 ne {
                    /onbits onbits 1 add def
                } if
            } for
            onbits 2 ne {exit} if
            /j i def
            /rev 0 def
            16 {            
                /rev rev 1 bitshift j 1 and or def
                /j j -1 bitshift def                
            } repeat          
            /rev rev -3 bitshift def            
            rev i lt {exit} if
            rev i eq {
                tab213 hi i put
                /hi hi 1 sub def
            } {
                tab213 lo i put
                tab213 lo 1 add rev put
                /lo lo 2 add def                      
            } ifelse
            exit
        } loop
    } for

    /chars 10 array def
    0 1 9 {
        /i exch def
        codewords i get dup 1286 le {
            tab513 exch get 
        } {
            tab213 exch 1287 sub get
        } ifelse
        chars i 3 -1 roll put
    } for

    9 -1 0 {
        /i exch def
        2 i exp cvi fcs and 0 ne {
            chars i chars i get 8191 xor put
        } if
    } for

    % Conversion from characters to the OneCode encoding
    /barmap [
        7 2 4 3    1 10 0 0   9 12 2 8   5 5 6 11   8 9 3 1
        0 1 5 12   2 5 1 8    4 4 9 11   6 3 8 10   3 9 7 6
        5 11 1 4   8 5 2 12   9 10 0 2   7 1 6 7    3 6 4 9
        0 3 8 6    6 4 2 7    1 1 9 9    7 10 5 2   4 0 3 8
        6 2 0 4    8 11 1 0   9 8 3 12   2 6 7 7    5 1 4 10
        1 12 6 9   7 3 8 0    5 8 9 7    4 6 2 10   3 4 0 5
        8 4 5 7    7 11 1 9   6 0 9 6    0 6 4 8    2 1 3 2
        5 9 8 12   4 11 6 1   9 5 7 4    3 3 1 2    0 7 2 0
        1 3 4 1    6 10 3 5   8 7 9 4    2 11 5 6   0 8 7 12
        4 2 8 1    5 10 3 0   9 3 0 9    6 5 2 4    7 8 1 7
        5 0 4 5    2 3 0 10   6 12 9 2   3 11 1 6   8 8 7 9
        5 4 0 11   1 5 2 2    9 1 4 12   8 3 6 6    7 0 3 7
        4 7 7 5    0 12 1 11  2 9 9 0    6 8 5 3    3 10 8 2
    ] def

    /bbs 65 array def    
    /bhs 65 array def
    0 1 64 {
        /i exch def
        /dec chars barmap i 4 mul get get 2 barmap i 4 mul 1 add get exp cvi and 0 ne def
        /asc chars barmap i 4 mul 2 add get get 2 barmap i 4 mul 3 add get exp cvi and 0 ne def
        dec not asc not and {
            bbs i 3 height mul 8 div put
            bhs i 2 height mul 8 div put
        } if
        dec not asc and {
            bbs i 3 height mul 8 div put
            bhs i 5 height mul 8 div put        
        } if
        dec asc not and {
            bbs i 0 height mul 8 div put
            bhs i 5 height mul 8 div put        
        } if
        dec asc and {
            bbs i 0 height mul 8 div put
            bhs i 8 height mul 8 div put        
        } if
    } for
    
    /retval 4 dict def
    retval (bbs) bbs put
    retval (bhs) bhs put
    retval (sbs) [bhs length 1 sub {1.44 1.872} repeat 1.44] put    
    retval (opt) useropts put
    retval

    end

} bind def
/onecode load 0 1 dict put
% --END ENCODER onecode--

% --BEGIN ENCODER postnet--
/postnet {

    % Thanks to Ross McFarland

    0 begin

    /options exch def              % We are given an option string
    /useropts options def
    /barcode exch def              % We are given a barcode string

    /includetext false def          % Enable/disable text
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 0.125 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    /barlen barcode length def

    % Create an array containing the character mappings
    /encs
    [ (55222) (22255) (22525) (22552) (25225)
      (25252) (25522) (52225) (52252) (52522)
      (5) (5)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    /bhs barlen 5 mul 7 add array def
    /txt barlen 1 add array def

    % Put start character
    /enc encs 10 get def
    /heights enc length array def
    0 1 enc length 1 sub {
        /j exch def
        heights j enc j 1 getinterval cvi height mul 5 div put
    } for
    bhs 0 heights putinterval   % Put encoded digit into sbs

    /checksum 0 def
    0 1 barlen 1 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                                 % Discard true leaving pre
        length /indx exch def               % indx is the length of pre
        pop pop                             % Discard seek and post
        /enc encs indx get def              % Get the indxth encoding
        /heights enc length array def
        0 1 enc length 1 sub {
            /j exch def
            heights j enc j 1 getinterval cvi height mul 5 div put
        } for
        bhs i 5 mul 1 add heights putinterval   % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 5 mul 1 add 3.312 mul textpos textfont textsize] put
        /checksum checksum indx add def     % checksum+=indx
    } for

    % Put the checksum character
    /checksum 10 checksum 10 mod sub 10 mod def
    /enc encs checksum get def
    /heights enc length array def
    0 1 enc length 1 sub {
        /j exch def
        heights j enc j 1 getinterval cvi height mul 5 div put
    } for
    bhs barlen 5 mul 1 add heights putinterval  
    
    includecheckintext {
        txt barlen [barchars checksum 1 getinterval barlen 5 mul 1 add 3.312 mul textpos textfont textsize] put
    } {
        txt barlen [( ) barlen 5 mul 1 add 72 mul 25 div textpos textfont textsize] put
    } ifelse
    
    % Put end character
    /enc encs 11 get def
    /heights enc length array def
    0 1 enc length 1 sub {
        /j exch def
        heights j enc j 1 getinterval cvi height mul 5 div put
    } for
    bhs barlen 5 mul 6 add heights putinterval  

    /retval 1 dict def
    retval (bhs) bhs put
    retval (bbs) [bhs length {0} repeat] put
    retval (sbs) [bhs length 1 sub {1.44 1.872} repeat 1.44] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/postnet load 0 1 dict put
% --END ENCODER postnet--

% --BEGIN ENCODER royalmail--
/royalmail {

    0 begin

    /options exch def              % We are given an option string
    /useropts options def
    /barcode exch def              % We are given a barcode string

    /includetext false def          % Enable/disable text
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 0.175 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (3300) (2211) (2301) (2310) (3201) (3210) 
      (1122) (0033) (0123) (0132) (1023) (1032) 
      (1302) (0213) (0303) (0312) (1203) (1212) 
      (1320) (0231) (0321) (0330) (1221) (1230) 
      (3102) (2013) (2103) (2112) (3003) (3012) 
      (3120) (2031) (2121) (2130) (3021) (3030) 
      (2) (3)
    ] def

    % Create a string of the available characters
    /barchars (ZUVWXY501234B6789AHCDEFGNIJKLMTOPQRS) def

    /barlen barcode length def
    /encstr barlen 4 mul 6 add string def
    /txt barlen 1 add array def

    % Put start character
    encstr 0 encs 36 get putinterval
    
    /checksumrow 0 def
    /checksumcol 0 def
    0 1 barlen 1 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                                 % Discard true leaving pre
        length /indx exch def               % indx is the length of pre
        pop pop                             % Discard seek and post
        /enc encs indx get def              % Get the indxth encoding
        encstr i 4 mul 1 add enc putinterval
        txt i [barcode i 1 getinterval i 4 mul 1 add 3.312 mul textpos textfont textsize] put
        /checksumrow checksumrow indx 6 idiv add def
        /checksumcol checksumcol indx 6 mod add def 
    } for

    % Put the checksum character
    /checksum checksumrow 6 mod 6 mul checksumcol 6 mod add def
    /enc encs checksum get def
    encstr barlen 4 mul 1 add enc putinterval
    includecheckintext {
        txt barlen [barchars checksum 1 getinterval barlen 4 mul 1 add 3.312 mul textpos textfont textsize] put
    } {
        txt barlen [( ) barlen 4 mul 1 add 3.312 mul textpos textfont textsize] put
    } ifelse
    
    % Put end character
    encstr barlen 4 mul 5 add encs 37 get putinterval  

    /bbs encstr length array def    
    /bhs encstr length array def
    0 1 encstr length 1 sub {
        /i exch def
        /enc encstr i 1 getinterval def
        enc (0) eq {
            bbs i 3 height mul 8 div put
            bhs i 2 height mul 8 div put
        } if
        enc (1) eq {
            bbs i 0 height mul 8 div put
            bhs i 5 height mul 8 div put
        } if
        enc (2) eq {
            bbs i 3 height mul 8 div put
            bhs i 5 height mul 8 div put
        } if
        enc (3) eq {
            bbs i 0 height mul 8 div put
            bhs i 8 height mul 8 div put
        } if
    } for
    
    /retval 4 dict def
    retval (bbs) bbs put
    retval (bhs) bhs put
    retval (sbs) [bhs length 1 sub {1.44 1.872} repeat 1.44] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/royalmail load 0 1 dict put
% --END ENCODER royalmail--

% --BEGIN ENCODER auspost--
/auspost {

    0 begin

    /options exch def              % We are given an option string
    /useropts options def
    /barcode exch def              % We are given a barcode string

    /includetext false def         % Enable/disable text
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 0.175 def
    /custinfoenc (character) def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def

    % Create an array containing the character mappings
    /encs
    [ (000) (001) (002) (010) (011) (012) (020) (021)
      (022) (100) (101) (102) (110) (111) (112) (120)
      (121) (122) (200) (201) (202) (210) (211) (212)
      (220) (221) (222) (300) (301) (302) (310) (311)
      (312) (320) (321) (322) (023) (030) (031) (032)
      (033) (103) (113) (123) (130) (131) (132) (133)
      (203) (213) (223) (230) (231) (232) (233) (303)
      (313) (323) (330) (331) (332) (333) (003) (013)
      (00) (01) (02) (10) (11) (12) (20) (21) (22) (30)
      (13) (3)
    ] def

    % Create a string of the available characters
    /barchars (ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz #) def
    
    /barlen barcode length def
    barcode 0 2 getinterval (11) eq {37} if
    barcode 0 2 getinterval (59) eq {52} if
    barcode 0 2 getinterval (62) eq {67} if
    /encstr exch string def
    /txt barlen 2 sub array def

    % Put start character
    encstr 0 encs 74 get putinterval

    % Encode the FCC
    0 1 1 {
        /i exch def       
        encs barcode i 1 getinterval cvi 64 add get
        encstr i 2 mul 2 add 3 2 roll putinterval
    } for
    
    % Encode the DPID
    2 1 9 {
        /i exch def       
        encs barcode i 1 getinterval cvi 64 add get
        encstr i 2 mul 2 add 3 2 roll putinterval
        txt i 2 sub [barcode i 1 getinterval i 2 sub 2 mul 6 add 3.312 mul textpos textfont textsize] put
    } for
    
    % Encode the customer information   
    custinfoenc (numeric) eq {
        0 1 barlen 11 sub {
            /i exch def
            encs barcode i 10 add 1 getinterval cvi 64 add get
            encstr i 2 mul 22 add 3 2 roll putinterval
            txt i 8 add [barcode i 10 add 1 getinterval i 2 mul 22 add 3.312 mul textpos textfont textsize] put
        } for        
        /ciflen barlen 10 sub 2 mul def
    } {
        0 1 barlen 11 sub {
            /i exch def           
            barcode i 10 add 1 getinterval barchars exch search
            pop                                
            length /indx exch def           
            pop pop                            
            /enc encs indx get def          
            encstr i 3 mul 22 add enc putinterval
            txt i 8 add [barcode i 10 add 1 getinterval i 3 mul 22 add 3.312 mul textpos textfont textsize] put
        } for        
        /ciflen barlen 10 sub 3 mul def
    } ifelse

    % Add any filler characters
    22 ciflen add 1 encstr length 14 sub {        
        encstr exch encs 75 get putinterval
    } for
    
    % Create the 64x64 Reed-Solomon table
    /rstable 64 64 mul array def
    rstable 0 [ 64 {0} repeat ] putinterval
    rstable 64 [ 0 1 63 {} for ] putinterval
    /prev 1 def
    64 {       
        /next prev 1 bitshift def
        next 64 and 0 ne {
            /next next 67 xor def
        } if        
        0 1 63 {
            /j exch def
            /nextcell {rstable 64 next mul j add} def
            nextcell rstable 64 prev mul j add get 1 bitshift put
            nextcell get 64 and 0 ne {
                nextcell nextcell get 67 xor put
            } if
        } for
        /prev next def
    } repeat
    
    % Calculate the Reed-Solomon codes for triples
    /rscodes encstr length 16 sub 3 idiv 4 add array def
    rscodes 0 [ 4 {0} repeat ] putinterval
    2 3 encstr length 16 sub {
        /i exch def
        rscodes rscodes length i 2 sub 3 idiv sub 1 sub
        encstr i 1 getinterval cvi 16 mul
        encstr i 1 add 1 getinterval cvi 4 mul add
        encstr i 2 add 1 getinterval cvi add        
        put
    } for    
    rscodes length 5 sub -1 0 {
       /i exch def
       0 1 4 {
           /j exch def
           rscodes i j add rscodes i j add get
           rstable 64 [48 17 29 30 1] j get mul rscodes i 4 add get add get
           xor put
       } for
    } for
    /checkcode (000000000000) def
    0 1 3 {
        /i exch def
        /enc rscodes 3 i sub get 4 3 string cvrs def
        checkcode i 3 mul 3 enc length sub add enc putinterval
    } for
    
    % Put checkcode and end characters
    encstr encstr length 14 sub checkcode putinterval
    encstr encstr length 2 sub encs 74 get putinterval 

    /bbs encstr length array def    
    /bhs encstr length array def
    0 1 encstr length 1 sub {
        /i exch def
        /enc encstr i 1 getinterval def
        enc (0) eq {
            bbs i 0 height mul 8 div put
            bhs i 8 height mul 8 div put
        } if
        enc (1) eq {
            bbs i 3 height mul 8 div put
            bhs i 5 height mul 8 div put
        } if
        enc (2) eq {
            bbs i 0 height mul 8 div put
            bhs i 5 height mul 8 div put
        } if
        enc (3) eq {
            bbs i 3 height mul 8 div put
            bhs i 2 height mul 8 div put
        } if
    } for   
    
    /retval 4 dict def
    retval (bbs) bbs put
    retval (bhs) bhs put
    retval (sbs) [bhs length 1 sub {1.44 1.872} repeat 1.44] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/auspost load 0 1 dict put
% --END ENCODER auspost--

% --BEGIN ENCODER kix--
/kix {

    0 begin

    /options exch def              % We are given an option string
    /useropts options def
    /barcode exch def              % We are given a barcode string

    /includetext false def          % Enable/disable text
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 0.175 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (0033) (0123) (0132) (1023) (1032) (1122)
      (0213) (0303) (0312) (1203) (1212) (1302) 
      (0231) (0321) (0330) (1221) (1230) (1320)
      (2013) (2103) (2112) (3003) (3012) (3102)
      (2031) (2121) (2130) (3021) (3030) (3120) 
      (2211) (2301) (2310) (3201) (3210) (3300) 
    ] def

    % Create a string of the available characters
    /barchars (0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ) def

    /barlen barcode length def
    /encstr barlen 4 mul string def
    /txt barlen array def
    
    0 1 barlen 1 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                                 % Discard true leaving pre
        length /indx exch def               % indx is the length of pre
        pop pop                             % Discard seek and post
        /enc encs indx get def              % Get the indxth encoding
        encstr i 4 mul enc putinterval
        txt i [barcode i 1 getinterval i 4 mul 3.312 mul textpos textfont textsize] put
    } for

    /bbs encstr length array def    
    /bhs encstr length array def
    0 1 encstr length 1 sub {
        /i exch def
        /enc encstr i 1 getinterval def
        enc (0) eq {
            bbs i 3 height mul 8 div put
            bhs i 2 height mul 8 div put
        } if
        enc (1) eq {
            bbs i 0 height mul 8 div put
            bhs i 5 height mul 8 div put
        } if
        enc (2) eq {
            bbs i 3 height mul 8 div put
            bhs i 5 height mul 8 div put
        } if
        enc (3) eq {
            bbs i 0 height mul 8 div put
            bhs i 8 height mul 8 div put
        } if
    } for
    
    /retval 4 dict def
    retval (bbs) bbs put
    retval (bhs) bhs put
    retval (sbs) [bhs length 1 sub {1.44 1.872} repeat 1.44] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/kix load 0 1 dict put
% --END ENCODER kix--

% --BEGIN ENCODER msi--
/msi {

    0 begin                 % Confine variables to local scope

    /options exch def       % We are given an option string
    /useropts options def
    /barcode exch def       % We are given a barcode string

    /includecheck false def  % Enable/disable checkdigit
    /includetext false def   % Enable/disable text
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (13131313) (13131331) (13133113) (13133131) (13311313)
      (13311331) (13313113) (13313131) (31131313) (31131331)
      (31) (131)
    ] def

    % Create a string of the available characters
    /barchars (0123456789) def

    /barlen barcode length def     % Length of the code

    includecheck {
        /sbs barlen 8 mul 13 add string def
        /txt barlen 1 add array def
    } {
        /sbs barlen 8 mul 5 add string def
        /txt barlen array def
    } ifelse


    % Put start character
    sbs 0 encs 10 get putinterval
    /checksum 0 def

    0 1 barlen 1 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                                % Discard true leaving pre
        length /indx exch def              % indx is the length of pre
        pop pop                            % Discard seek and post
        /enc encs indx get def             % Get the indxth encoding
        sbs i 8 mul 2 add enc putinterval  % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 16 mul 4 add textpos textfont textsize] put
        barlen i sub 2 mod 0 eq {
            /checksum indx checksum add def
        } {
            /checksum indx 2 mul dup 10 idiv add checksum add def
        } ifelse
    } for

    % Put the checksum and end characters
    includecheck {
        /checksum 10 checksum 10 mod sub 10 mod def
        sbs barlen 8 mul 2 add encs checksum get putinterval
        includecheckintext {
            txt barlen [barchars checksum 1 getinterval barlen 16 mul 4 add textpos textfont textsize] put
        } {
            txt barlen [( ) barlen 16 mul 4 add textpos textfont textsize] put
        } ifelse
        sbs barlen 8 mul 10 add encs 11 get putinterval
    } {
        sbs barlen 8 mul 2 add encs 11 get putinterval
    } ifelse

    % Return the arguments
    /retval 1 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/msi load 0 1 dict put
% --END ENCODER msi--

% --BEGIN ENCODER plessey--
/plessey {

    0 begin                  % Confine variables to local scope

    /options exch def        % We are given an option string
    /useropts options def
    /barcode exch def        % We are given a barcode string

    /includetext false def    % Enable/disable text
    /includecheckintext false def
    /textfont /Courier def
    /textsize 10 def
    /textpos -7 def
    /height 1 def
    
    % Parse the input options
    options {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop
    
    /textfont textfont cvlit def
    /textsize textsize cvr def
    /textpos textpos cvr def
    /height height cvr def
    
    % Create an array containing the character mappings
    /encs
    [ (13131313) (31131313) (13311313) (31311313)
      (13133113) (31133113) (13313113) (31313113)
      (13131331) (31131331) (13311331) (31311331)
      (13133131) (31133131) (13313131) (31313131)
      (31311331) (331311313)
    ] def

    % Create a string of the available characters
    /barchars (0123456789ABCDEF) def

    /barlen barcode length def     % Length of the code
    /sbs barlen 8 mul 33 add string def
    /txt barlen 2 add array def
    /checkbits barlen 4 mul 8 add array def
    checkbits barlen 4 mul [ 0 0 0 0 0 0 0 0 ] putinterval

    % Put start character
    sbs 0 encs 16 get putinterval

    0 1 barlen 1 sub {
        /i exch def
        % Lookup the encoding for the each barcode character
        barcode i 1 getinterval barchars exch search
        pop                                % Discard true leaving pre
        length /indx exch def              % indx is the length of pre
        pop pop                            % Discard seek and post
        /enc encs indx get def             % Get the indxth encoding
        sbs i 8 mul 8 add enc putinterval  % Put encoded digit into sbs
        txt i [barcode i 1 getinterval i 16 mul 16 add textpos textfont textsize] put
        checkbits i 4 mul [
                indx 1 and
                indx -1 bitshift 1 and
                indx -2 bitshift 1 and
                indx -3 bitshift
        ] putinterval
    } for

    % Checksum is last 8 bits of a CRC using a salt
    /checksalt [ 1 1 1 1 0 1 0 0 1 ] def
    0 1 barlen 4 mul 1 sub {
        /i exch def
        checkbits i get 1 eq {
            0 1 8 {
                /j exch def
                checkbits i j add checkbits i j add get checksalt j get xor put
            } for
        } if
    } for

    % Calculate the value of the checksum digits
    /checkval 0 def
    0 1 7 {
        /i exch def
        /checkval checkval 2 7 i sub exp cvi checkbits barlen 4 mul i add get mul add def
    } for

    % Put the checksum characters
    /checksum1 checkval -4 bitshift def
    /checksum2 checkval 15 and def
    sbs barlen 8 mul 8 add encs checksum1 get putinterval
    sbs barlen 8 mul 16 add encs checksum2 get putinterval
    includecheckintext {
        txt barlen [barchars checksum1 1 getinterval barlen 16 mul 16 add textpos textfont textsize] put
        txt barlen 1 add [barchars checksum2 1 getinterval barlen 1 add 16 mul 16 add textpos textfont textsize] put
    } {
        txt barlen [( ) barlen 16 mul 16 add textpos textfont textsize] put
        txt barlen 1 add [( ) barlen 1 add 16 mul 16 add textpos textfont textsize] put
    } ifelse

    % Put end character
    sbs barlen 8 mul 24 add encs 17 get putinterval

    % Return the arguments
    /retval 1 dict def
    retval (sbs) [sbs {48 sub} forall] put
    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put
    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put
    includetext {
        retval (txt) txt put
    } if
    retval (opt) useropts put
    retval

    end

} bind def
/plessey load 0 1 dict put
% --END ENCODER plessey--

% --BEGIN ENCODER symbol--
/symbol {

    0 begin            % Confine variables to local scope

    /options exch def  % We are given an option string
    /barcode exch def  % We are given a barcode string

    barcode (fima) eq {
        /sbs [2.25 2.25 2.25 11.25 2.25 11.25 2.25 2.25 2.25] def
        /bhs [.625 .625 .625 .625 .625] def
        /bbs [0 0 0 0 0] def
    } if

    barcode (fimb) eq {
        /sbs [2.25 6.75 2.25 2.25 2.25 6.25 2.25 2.25 2.25 6.75 2.25] def
        /bhs [.625 .625 .625 .625 .625 .625] def
        /bbs [0 0 0 0 0 0] def
    } if

    barcode (fimc) eq {
        /sbs [2.25 2.25 2.25 6.75 2.25 6.75 2.25 6.75 2.25 2.25 2.25] def
        /bhs [.625 .625 .625 .625 .625 .625] def
        /bbs [0 0 0 0 0 0] def
    } if
    
    barcode (fimd) eq {
        /sbs [2.25 2.25 2.25 2.25 2.25 6.75 2.25 6.75 2.25 2.25 2.25 2.25 2.25] def
        /bhs [.625 .625 .625 .625 .625 .625 .625] def
        /bbs [0 0 0 0 0 0 0] def
    } if
    
    % Return the arguments
    /retval 4 dict def
    retval (sbs) sbs put
    retval (bhs) bhs put
    retval (bbs) bbs put
    retval (opt) options put
    retval

    end

} bind def
/symbol load 0 1 dict put
% --END ENCODER symbol--

% --BEGIN RENDERER--
/barcode {

    0 begin          % Confine variables to local scope

    /args exch def   % We are given some arguments

    % Default options
    /sbs [] def
    /bhs [] def
    /bbs [] def
    /txt [] def
    /barcolor (unset) def
    /textcolor (unset) def
    /bordercolor (unset) def
    /backgroundcolor (unset) def
    /inkspread 0.15 def
    /width 0 def
    /barratio 1 def
    /spaceratio 1 def
    /showborder false def
    /borderleft 10 def
    /borderright 10 def
    /bordertop 1 def
    /borderbottom 1 def
    /borderwidth 0.5 def
    /guardwhitespace false def
    /guardleftpos 0 def
    /guardleftypos 0 def
    /guardrightpos 0 def
    /guardrightypos 0 def
    /guardwidth 6 def
    /guardheight 7 def
    
    % Apply the renderer options
    args {exch cvlit exch def} forall
       
    % Parse the user options   
    opt {
        token false eq {exit} if dup length string cvs (=) search
        true eq {cvlit exch pop exch def} {cvlit true def} ifelse
    } loop

    /barcolor barcolor cvlit def
    /textcolor textcolor cvlit def
    /bordercolor bordercolor cvlit def
    /backgroundcolor backgroundcolor cvlit def
    /inkspread inkspread cvr def
    /width width cvr def
    /barratio barratio cvr def
    /spaceratio spaceratio cvr def
    /borderleft borderleft cvr def
    /borderright borderright cvr def
    /bordertop bordertop cvr def
    /borderbottom borderbottom cvr def
    /borderwidth borderwidth cvr def
    /guardleftpos guardleftpos cvr def
    /guardleftypos guardleftypos cvr def
    /guardrightpos guardrightpos cvr def
    /guardrightypos guardrightypos cvr def
    /guardwidth guardwidth cvr def
    /guardheight guardheight cvr def
    
    % Create bar elements and put them into the bars array
    /bars sbs length 1 add 2 idiv array def
    /x 0.00 def /maxh 0 def
    0 1 sbs length 1 add 2 idiv 2 mul 2 sub {
        /i exch def
        i 2 mod 0 eq {           % i is even
            /d sbs i get barratio mul barratio sub 1 add def  % d=digit*r-r+1 
            /h bhs i 2 idiv get 72 mul def  % Height from bhs
            /c d 2 div x add def            % Centre of the bar = x + d/2
            /y bbs i 2 idiv get 72 mul def  % Baseline from bbs
            /w d inkspread sub def          % bar width = digit - inkspread
            bars i 2 idiv [h c y w] put     % Add the bar entry
            h maxh gt {/maxh h def} if
        } {
            /d sbs i get spaceratio mul spaceratio sub 1 add def  % d=digit*r-r+1 
        } ifelse
        /x x d add def  % x+=d
    } for

    gsave

    currentpoint translate

    % Force symbol to given width
    width 0 ne {
        width 72 mul x div 1 scale
    } if

    % Display the border and background
    newpath
    borderleft neg borderbottom neg moveto
    x borderleft add borderright add 0 rlineto
    0 maxh borderbottom add bordertop add rlineto
    x borderleft add borderright add neg 0 rlineto
    0 maxh borderbottom add bordertop add neg rlineto    
    closepath
    backgroundcolor (unset) ne {
        gsave
        (<      >) dup 1 backgroundcolor putinterval cvx exec {255 div} forall setrgbcolor
        fill
        grestore  
    } if     
    showborder {
        gsave
        bordercolor (unset) ne {
            (<      >) dup 1 bordercolor putinterval cvx exec {255 div} forall setrgbcolor
        } if
        borderwidth setlinewidth stroke
        grestore
    } if    
   
    % Display the bars for elements in the bars array
    gsave
    barcolor (unset) ne {
        (<      >) dup 1 barcolor putinterval cvx exec {255 div} forall setrgbcolor
    } if
    bars {
        {} forall
        newpath setlinewidth moveto 0 exch rlineto stroke
    } forall
    grestore
    
    % Display the text for elements in the text array
    textcolor (unset) ne {
        (<      >) dup 1 textcolor putinterval cvx exec {255 div} forall setrgbcolor
    } if
    /s 0 def /f () def
    txt {
        {} forall
        2 copy s ne exch f ne or {
            2 copy /s exch def /f exch def            
            exch findfont exch scalefont setfont          
        } {
            pop pop
        } ifelse
        moveto show
    } forall

    % Display the guard elements
    guardwhitespace {
        0.75 setlinewidth
        guardleftpos 0 ne {
            newpath
            guardleftpos neg guardwidth add guardleftypos guardwidth 2 div add moveto
            guardwidth neg guardheight -2 div rlineto
            guardwidth guardheight -2 div rlineto
            stroke            
        } if
        guardrightpos 0 ne {
            newpath
            guardrightpos x add guardwidth sub guardrightypos guardheight 2 div add moveto
            guardwidth guardheight -2 div rlineto
            guardwidth neg guardheight -2 div rlineto
            stroke            
        } if
    } if
    
    grestore
    
    end

} bind def
/barcode load 0 1 dict put
% --END RENDERER--

% --END TEMPLATE--
