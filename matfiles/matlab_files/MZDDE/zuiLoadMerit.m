function MeritData = zuiLoadMerit()
% zuiLoadMerit - Load a merit function file into the ZEMAX DDE server using File Open dialog box.
%
% Usage : MeritData = zuiLoadMerit
%
% Identical to zLoadMerit, except that the file name is obtained from the user via a File Open dialog box.
% Loads a ZEMAX .MF or .ZMX file and extracts the merit function and places it in the lens loaded in the server.
% Note that loading a merit function file does not change the data displayed in the LDE; the server process has a
% separate copy of the lens data. The file name must
% include the full path. For example: zLoadMerit('C:\ZEMAX\SAMPLES\MyMerit.MF'). The returned numeric vector is formatted
% as follows:
% number, merit
% where number is the number of operands in the merit function and merit is the value of the merit function. If
% the merit function value is 9.00e+009, the merit function cannot be evaluated.
%
% zuiLoadMerit returns -1 if the user presses cancel or selects a bad file.
%
% See also zOptimize
%

%% Copyright 2002-2009, DPSS, CSIR
% This file is subject to the terms and conditions of the BSD Licence.
% For further details, see the file BSDlicence.txt
%
% Contact : dgriffith@csir.co.za
% 
% 
%
%
%


% $Revision: 221 $

global ZemaxDDEChannel ZemaxDDETimeout
[fn, pn] = uigetfile('*.mf;*.zmx', 'Open ZEMAX Merit Function');
if (pn == 0)
   MeritData = -1;
   return;
end
FileName = [pn fn];
DDECommand = sprintf('LoadMerit,%s',FileName);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f');
MeritData = col';



