function varargout = Manualanalysis(varargin)
% MANUALANALYSIS MATLAB code for Manualanalysis.fig
%      MANUALANALYSIS, by itself, creates a new MANUALANALYSIS or raises the existing
%      singleton*.
%
%      H = MANUALANALYSIS returns the handle to a new MANUALANALYSIS or the handle to
%      the existing singleton*.
%
%      MANUALANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALANALYSIS.M with the given input arguments.
%
%      MANUALANALYSIS('Property','Value',...) creates a new MANUALANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Manualanalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Manualanalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Manualanalysis

% Last Modified by GUIDE v2.5 20-Dec-2018 18:08:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Manualanalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @Manualanalysis_OutputFcn, ...
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


% --- Executes just before Manualanalysis is made visible.
function Manualanalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Manualanalysis (see VARARGIN)

% Choose default command line output for Manualanalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Manualanalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Manualanalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Diredit_Callback(hObject, eventdata, handles)
% hObject    handle to Diredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diredit as text
%        str2double(get(hObject,'String')) returns contents of Diredit as a
%        double

% --- Executes during object creation, after setting all properties.
function Diredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Diredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Exceledit_Callback(hObject, eventdata, handles)
% hObject    handle to Exceledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Exceledit as text
%        str2double(get(hObject,'String')) returns contents of Exceledit as a double

set(handles.Dateedit, 'Enable', 'on')
set(handles.Exceledit, 'Enable', 'off')
uicontrol(handles.Dateedit)


% --- Executes during object creation, after setting all properties.
function Exceledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Exceledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Dateedit_Callback(hObject, eventdata, handles)
% hObject    handle to Dateedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Dateedit as text
%        str2double(get(hObject,'String')) returns contents of Dateedit as a double

set(handles.Guibtn, 'Enable', 'on')
set(handles.Savebtn, 'Enable', 'on')
uicontrol(handles.Guibtn)

% --- Executes during object creation, after setting all properties.
function Dateedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dateedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Guibtn.
function Guibtn_Callback(hObject, eventdata, handles)
% hObject    handle to Guibtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y] = ginput(1);

dir1 = get(handles.Diredit, 'String');
popUpMenuValue = get(handles.popupmenu1, 'Value');
dir1Files = dir(dir1);
j = 1;
for i = 1 : length(dir1Files)
    if length(dir1Files(i).name) > 6 && dir1Files(i).name(7) == '_'
        name{j} = dir1Files(i).name;
        j = j + 1;
    end
end

directory = [dir1, '\', name{popUpMenuValue}];
files = dir(directory);

N = get(handles.uitable3, 'Data');
i = str2num(get(handles.edit4, 'String'));
im = imread([directory, '\', files(N(i)).name]);
imshow(im)
coord(size(im,1), size(im,2))

A = get(handles.uitable1, 'Data');
P = get(handles.uitable2, 'Data');

i = fix(y/(size(im,1)/32*33/3))+1;
j = fix(x/(size(im,2)/72))+1;

if fix(j/2)~=(j/2)
    A(i,fix(j/2)+1) = ((i*size(im,1)/32*33/3 -y) /(size(im,1)/32*33/3)*110 -5 -5);
elseif fix(j/2)==(j/2)
    P(i,fix(j/2)) = ((i*size(im,1)/32*33/3 -y) /(size(im,1)/32*33/3)*110 -5 -5);
end

value(A, P, size(im,1), size(im,2))

set(handles.uitable1, 'Data', A)
set(handles.uitable2, 'Data', P)

set( handles.A1_begin, 'String', num2str(A(1, 1)) )
set( handles.A2_begin, 'String', num2str(A(2, 1)) )
set( handles.A3_begin, 'String', num2str(A(3, 1)) )
set( handles.P1_begin, 'String', num2str(P(1, 1)) )
set( handles.P2_begin, 'String', num2str(P(2, 1)) )
set( handles.P3_begin, 'String', num2str(P(3, 1)) )
set( handles.A1_end, 'String', num2str(A(1, end)) )
set( handles.A2_end, 'String', num2str(A(2, end)) )
set( handles.A3_end, 'String', num2str(A(3, end)) )
set( handles.P1_end, 'String', num2str(P(1, end)) )
set( handles.P2_end, 'String', num2str(P(2, end)) )
set( handles.P3_end, 'String', num2str(P(3, end)) )

% --- Executes on button press in Savebtn.
function Savebtn_Callback(hObject, eventdata, handles)
% hObject    handle to Savebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

date_init = get(handles.Dateedit, 'String');
date_init = datenum(date_init);
date_term = date_init+1/24;
set(handles.Dateedit, 'String', datestr(date_term, 31))

date = 0:35;
% 693960 это разница в календарях matlab и excel
date = date/36*(date_term-date_init)+date_init - 693960;

A = get(handles.uitable1, 'Data');
P = get(handles.uitable2, 'Data');
DATA = [date',A',P'];

i = str2num(get(handles.edit4, 'String'));
filename = get(handles.Exceledit, 'String');
dir1 = get(handles.Diredit, 'String');
popUpMenustring = get(handles.popupmenu1, 'String');
popUpMenuValue = get(handles.popupmenu1, 'Value');
excelDir = [dir1, '/', popUpMenustring{popUpMenuValue}, '/', filename];

xlswrite(excelDir,DATA,1,['A',num2str(1+(i-1)*36),':G',num2str(36+(i-1)*36)])

set(handles.edit4, 'String', num2str(i+1))

dir1Files = dir(dir1);
j = 1;
for i = 1 : length(dir1Files)
    if length(dir1Files(i).name) > 6 && dir1Files(i).name(7) == '_'
        name{j} = dir1Files(i).name;
        j = j + 1;
    end
end

directory = [dir1, '/', name{popUpMenuValue}];
files = dir(directory);

N = get(handles.uitable3, 'Data');
i = str2num(get(handles.edit4, 'String'));
im = imread([directory, '/', files(N(i)).name]);
imshow(im)
coord(size(im,1), size(im,2))

trashhold = get(handles.Trashslider, 'Value');
[ A, P ] = Analysis( [directory, '/', files(N(i)).name], trashhold );
value(A, P, size(im,1), size(im,2))

set(handles.uitable1, 'Data', A)
set(handles.uitable2, 'Data', P)

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Trashslider_Callback(hObject, eventdata, handles)
% hObject    handle to Trashslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Trashslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trashslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Trashbtn.
function Trashbtn_Callback(hObject, eventdata, handles)
% hObject    handle to Trashbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir1 = get(handles.Diredit, 'String');
popUpMenuValue = get(handles.popupmenu1, 'Value');
dir1Files = dir(dir1);
j = 1;
for i = 1 : length(dir1Files)
    if length(dir1Files(i).name) > 6 && dir1Files(i).name(7) == '_'
        name{j} = dir1Files(i).name;
        j = j + 1;
    end
end

directory = [dir1, '\', name{popUpMenuValue}];
files = dir(directory);

N = get(handles.uitable3, 'Data');
i = str2num(get(handles.edit4, 'String'));
im = imread(files(N(i)).name);
imshow(im)
coord(size(im,1), size(im,2))

trashhold = get(handles.Trashslider, 'Value');
[ A, P ] = Analysis( files(N(i)).name, trashhold );
value(A, P, size(im,1), size(im,2))

set(handles.uitable1, 'Data', A)
set(handles.uitable2, 'Data', P)


% --- Executes on button press in correct.
function correct_Callback(hObject, eventdata, handles)
% hObject    handle to correct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir1 = get(handles.Diredit, 'String');
popUpMenuValue = get(handles.popupmenu1, 'Value');
dir1Files = dir(dir1);
j = 1;
for i = 1 : length(dir1Files)
    if length(dir1Files(i).name) > 6 && dir1Files(i).name(7) == '_'
        name{j} = dir1Files(i).name;
        j = j + 1;
    end
end

directory = [dir1, '\', name{popUpMenuValue}];
files = dir(directory);

N = get(handles.uitable3, 'Data');
i = str2num(get(handles.edit4, 'String'));
im = imread([directory, '\', files(N(i)).name]);
imshow(im)

A = get(handles.uitable1, 'Data');
P = get(handles.uitable2, 'Data');

C(1, 1) = str2num( get( handles.A1_begin, 'String' ) );
C(1, 2) = str2num( get( handles.A2_begin, 'String' ) );
C(1, 3) = str2num( get( handles.A3_begin, 'String' ) );
C(1, 4) = str2num( get( handles.P1_begin, 'String' ) );
C(1, 5) = str2num( get( handles.P2_begin, 'String' ) );
C(1, 6) = str2num( get( handles.P3_begin, 'String' ) );
C(2, 1) = str2num( get( handles.A1_end, 'String' ) );
C(2, 2) = str2num( get( handles.A2_end, 'String' ) );
C(2, 3) = str2num( get( handles.A3_end, 'String' ) );
C(2, 4) = str2num( get( handles.P1_end, 'String' ) );
C(2, 5) = str2num( get( handles.P2_end, 'String' ) );
C(2, 6) = str2num( get( handles.P3_end, 'String' ) );

[A, P] = CorrectFun(A, P, C);

value(A, P, size(im,1), size(im,2))

set(handles.uitable1, 'Data', A)
set(handles.uitable2, 'Data', P)



function A1_begin_Callback(hObject, eventdata, handles)
% hObject    handle to A1_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A1_begin as text
%        str2double(get(hObject,'String')) returns contents of A1_begin as a double


% --- Executes during object creation, after setting all properties.
function A1_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A2_begin_Callback(hObject, eventdata, handles)
% hObject    handle to A2_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A2_begin as text
%        str2double(get(hObject,'String')) returns contents of A2_begin as a double


% --- Executes during object creation, after setting all properties.
function A2_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A3_begin_Callback(hObject, eventdata, handles)
% hObject    handle to A3_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A3_begin as text
%        str2double(get(hObject,'String')) returns contents of A3_begin as a double


% --- Executes during object creation, after setting all properties.
function A3_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A3_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P1_begin_Callback(hObject, eventdata, handles)
% hObject    handle to P1_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P1_begin as text
%        str2double(get(hObject,'String')) returns contents of P1_begin as a double


% --- Executes during object creation, after setting all properties.
function P1_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P1_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P2_begin_Callback(hObject, eventdata, handles)
% hObject    handle to P2_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P2_begin as text
%        str2double(get(hObject,'String')) returns contents of P2_begin as a double


% --- Executes during object creation, after setting all properties.
function P2_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P2_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P3_begin_Callback(hObject, eventdata, handles)
% hObject    handle to P3_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P3_begin as text
%        str2double(get(hObject,'String')) returns contents of P3_begin as a double


% --- Executes during object creation, after setting all properties.
function P3_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P3_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A1_end_Callback(hObject, eventdata, handles)
% hObject    handle to A1_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A1_end as text
%        str2double(get(hObject,'String')) returns contents of A1_end as a double


% --- Executes during object creation, after setting all properties.
function A1_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P1_end_Callback(hObject, eventdata, handles)
% hObject    handle to P1_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P1_end as text
%        str2double(get(hObject,'String')) returns contents of P1_end as a double


% --- Executes during object creation, after setting all properties.
function P1_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P1_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A2_end_Callback(hObject, eventdata, handles)
% hObject    handle to A2_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A2_end as text
%        str2double(get(hObject,'String')) returns contents of A2_end as a double


% --- Executes during object creation, after setting all properties.
function A2_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P2_end_Callback(hObject, eventdata, handles)
% hObject    handle to P2_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P2_end as text
%        str2double(get(hObject,'String')) returns contents of P2_end as a double


% --- Executes during object creation, after setting all properties.
function P2_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P2_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A3_end_Callback(hObject, eventdata, handles)
% hObject    handle to A3_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A3_end as text
%        str2double(get(hObject,'String')) returns contents of A3_end as a double


% --- Executes during object creation, after setting all properties.
function A3_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A3_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P3_end_Callback(hObject, eventdata, handles)
% hObject    handle to P3_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P3_end as text
%        str2double(get(hObject,'String')) returns contents of P3_end as a double


% --- Executes during object creation, after setting all properties.
function P3_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P3_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in begin.
function begin_Callback(hObject, eventdata, handles)
% hObject    handle to begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir1 = get(handles.Diredit, 'String');
popUpMenuValue = get(handles.popupmenu1, 'Value');
dir1Files = dir(dir1);
j = 1;
for i = 1 : length(dir1Files)
    if length(dir1Files(i).name) > 6 && dir1Files(i).name(7) == '_'
        name{j} = dir1Files(i).name;
        j = j + 1;
    end
end

directory = [dir1, '\', name{popUpMenuValue}];

files = dir(directory);
j = 1;
for i = 1:size(files,1)
    name = files(i).name;
    JPG = findstr(name,'JPG');
    jpg = findstr(name,'jpg');
    pre = findstr(name,'pre');
    if (~isempty(JPG) || ~isempty(jpg)) && ~isempty(pre)
        N(j) = i;
        j = j+1;
    end
end
im = imread([directory, '\', files(N(1)).name]);
imshow(im)
coord(size(im,1), size(im,2))
set(handles.edit4, 'String', '1')

trashhold = get(handles.Trashslider, 'Value');
[ A, P ] = Analysis( [directory, '\', files(N(1)).name], trashhold );
value(A, P, size(im,1), size(im,2));

set(handles.uitable1, 'Data', A)
set(handles.uitable2, 'Data', P)
set(handles.uitable3, 'Data', N)

set(handles.Exceledit, 'Enable', 'on')
set(handles.Diredit, 'Enable', 'off')
uicontrol(handles.Exceledit)

set( handles.A1_begin, 'String', num2str(A(1, 1)) )
set( handles.A2_begin, 'String', num2str(A(2, 1)) )
set( handles.A3_begin, 'String', num2str(A(3, 1)) )
set( handles.P1_begin, 'String', num2str(P(1, 1)) )
set( handles.P2_begin, 'String', num2str(P(2, 1)) )
set( handles.P3_begin, 'String', num2str(P(3, 1)) )
set( handles.A1_end, 'String', num2str(A(1, end)) )
set( handles.A2_end, 'String', num2str(A(2, end)) )
set( handles.A3_end, 'String', num2str(A(3, end)) )
set( handles.P1_end, 'String', num2str(P(1, end)) )
set( handles.P2_end, 'String', num2str(P(2, end)) )
set( handles.P3_end, 'String', num2str(P(3, end)) )

excelNames = get(handles.popupmenu1, 'String');
excelNameNum = get(handles.popupmenu1, 'Value');
excelName = [excelNames{excelNameNum}, '_DATA'];
set(handles.Exceledit, 'String', excelName)
set(handles.Dateedit, 'String', ['19', excelName(1:2), '-', excelName(3:4), '-', excelName(5:6), ' ', '00:00:00'])

function search_Callback(hObject, eventdata, handles)
directory = get(handles.Diredit, 'String');
dirData = dir(directory);
j = 1;
for i = 1 : length(dirData)
    if length(dirData(i).name) > 6 && dirData(i).name(7) == '_'
        name{j} = dirData(i).name;
        popUpMenuValue(j) = i;
        j = j + 1;
    end
end
set(handles.popupmenu1, 'String', name');
