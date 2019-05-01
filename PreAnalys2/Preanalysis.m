function varargout = Preanalysis(varargin)
% PREANALYSIS MATLAB code for Preanalysis.fig
%      PREANALYSIS, by itself, creates a new PREANALYSIS or raises the existing
%      singleton*.
%
%      H = PREANALYSIS returns the handle to a new PREANALYSIS or the handle to
%      the existing singleton*.
%
%      PREANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREANALYSIS.M with the given input arguments.
%
%      PREANALYSIS('Property','Value',...) creates a new PREANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Preanalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Preanalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Preanalysis

% Last Modified by GUIDE v2.5 02-Jun-2018 18:33:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Preanalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @Preanalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Preanalysis is made visible.
function Preanalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Preanalysis (see VARARGIN)

% Choose default command line output for Preanalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Preanalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Preanalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function directory_Callback(hObject, eventdata, handles)
% делаем доступной кнопку pushbutton1(обработка)
set(handles.pushbutton1, 'Enable', 'on')
% передаем фокус кнопке pushbutton1(обработка)
uicontrol(handles.pushbutton1)

function directory_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton1_Callback(hObject, eventdata, handles)
set(handles.pushbutton1, 'Enable', 'off')
set(handles.text2,'String','ИДЕТ ОБРАБОТКА','ForegroundColor','r','FontSize',16)
directory = get(handles.directory, 'String');

% получение информации о файлах в данной директории
files = dir(directory);

j = 1;
for i = 1:size(files,1)
    name = files(i).name;
    JPG = findstr(name,'JPG');
    jpg = findstr(name,'jpg');
    pre = findstr(name,'pre');
    if (~isempty(JPG) || ~isempty(jpg)) && isempty(pre)
        N(j) = i;
        j = j+1;
    end
end

for i = 1:length(N)
    Pre_analysis([directory, '/', files(N(i)).name])
end

set(handles.text2,'String','ОБРАБОТКА ЗАВЕРШЕНА','ForegroundColor','g','FontSize',16)