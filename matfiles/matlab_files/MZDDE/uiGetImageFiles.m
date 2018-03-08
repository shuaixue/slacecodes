function [fullfilenames PathName] = uiGetImageFiles(StartDirectory, DialogTitle)
% uiGetImageFilenames : Uses uigetfile to get a list of filenames 
%
% Allows multiple selection of image files and returns names in a cell
% array.
%
% Usage :
%  fullfilenames = uiGetImageFiles(StartDirectory, DialogTitle)
%  fullfilenames = uiGetImageFiles
%
% Returns the complete filenames of the image files selected by the user with
% the file selection dialog. If the optional StartDirectory is given the dialog will
% open initially in that directory. The Nikon Electronic File Format (NEF)
% has been added to the list. You will need the Stanford NEF reader to read
% NEF files directly (see NEFReadIm.m and rawCamFileRead.dll). If not
% included with your distribution, look at
% http://scien.stanford.edu/class/psych221/projects/05/joanmoh/appendixI.html
%
% Returns 0 if the user cancelled the dialog.
%
% See also : uigetfile, imread, imformats, imfinfo, uiGetImageFile


%% BSD Licence
% This file is subject to the terms and conditions of the BSD licence.
% For further details, see the file BSDlicence.txt
%%


% $Revision: 221 $
% $Author: DGriffith $
if ~exist('DialogTitle', 'var') || isempty(DialogTitle)
    DialogTitle = 'Select one or more Image Files';
end

fmts = imformats; % Get the available image formats that will be read by imread
% Cook up a string to give to uigetfile
allimagefmts = '';
for i = 1:length(fmts)
    if length(fmts(i).ext) == 1
      extensions = ['*.' char(fmts(i).ext)];
    else 
      extensions = ['*.' char(fmts(i).ext(1)) ';*.' char(fmts(i).ext(2))];
    end
    uigetstring{i,1} = extensions;
    uigetstring{i,2} = fmts(i).description;
    allimagefmts = [allimagefmts ';' extensions];
end
uigetstring{end+1,1} = ['*.nef;*.NEF' allimagefmts];
uigetstring{end,2} = 'All Known Image File Formats';
uigetstring{end+1,1} = '*.nef;*.NEF'; % need the NEF file reader from stanford 
uigetstring{end,2} = 'Nikon Electronic Format (NEF)';
uigetstring = circshift(uigetstring, 2); % Put all formats at top of list
uigetstring{end+1,1} = '*.*';
uigetstring{end,2} = 'All Files (*.*)';

if exist('StartDirectory', 'var')
    if exist(StartDirectory, 'dir')
      if StartDirectory(end) ~= '\' && StartDirectory(end) ~= '/'
          StartDirectory = [StartDirectory '/'];
      end
      [ImageFiles, PathName] = uigetfile(uigetstring, DialogTitle, StartDirectory, 'MultiSelect', 'on');
  
    else
        error(['Directory ' StartDirectory ' does not exist.']);
    end
else % starts in the current directory
   [ImageFiles, PathName] = uigetfile(uigetstring, DialogTitle, 'MultiSelect', 'on');    
end
if iscellstr(ImageFiles)
  for iFile = 1:length(ImageFiles)
    fullfilenames{iFile} = [PathName ImageFiles{iFile}];
  end
else
    fullfilenames = 0;
end
 