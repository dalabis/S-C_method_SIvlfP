function varargout = Analyse(varargin)
% ANALYSE MATLAB code for Analyse.fig
%      ANALYSE, by itself, creates a new ANALYSE or raises the existing
%      singleton*.
%
%      H = ANALYSE returns the handle to a new ANALYSE or the handle to
%      the existing singleton*.
%
%      ANALYSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSE.M with the given input arguments.
%
%      ANALYSE('Property','Value',...) creates a new ANALYSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Analyse_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Analyse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Analyse

% Last Modified by GUIDE v2.5 24-Jan-2019 19:47:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Analyse_OpeningFcn, ...
                   'gui_OutputFcn',  @Analyse_OutputFcn, ...
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


% --- Executes just before Analyse is made visible.
function Analyse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Analyse (see VARARGIN)

% Choose default command line output for Analyse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Analyse wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Analyse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in begin.
function begin_Callback(hObject, eventdata, handles)

set(handles.discrepancy_funcion,'Visible','On')
dir1 = get(handles.Diredit, 'String');
popUpMenuValue = get(handles.fileNames, 'Value');
dir1Files = dir(dir1);
j = 1;
for i = 1 : length(dir1Files)
    if length(dir1Files(i).name) > 6 && dir1Files(i).name(7) == '_'
        name{j} = dir1Files(i).name;
        j = j + 1;
    end
end
filename = [dir1, '\', name{popUpMenuValue}, '\', name{popUpMenuValue}, '_DATA', '.xls'];

% get extreme values of the parameters
t = get(handles.table_begin,'Data');
R1_minimize = str2double(get(handles.R1_minimize,'String'));
R2_minimize = str2double(get(handles.R2_minimize,'String'));
h1_minimize = str2double(get(handles.h1_minimize,'String'));
h2_minimize = str2double(get(handles.h2_minimize,'String'));
dR_minimize = str2double(get(handles.dR_txt,'String'));
dh_minimize = str2double(get(handles.dh_txt,'String'));

% correct the data
in_data = Correct(xlsread(filename));

% averaging over 3, 7, 9 points with step 100 sec
average = get(handles.popupmenu_average,'Value');
in_data = Awaraging(in_data, average);

%лишние отсчеты убираются, чтобы обеспечить выбранный временной шаг
step = get(handles.popupmenu_step,'Value');
switch step
    case 1
        in_data_step1(1:2*size(in_data,1)-1, 7) = 0;
        for i = 1:size(in_data,1)
            in_data_step1(2*i-1, :) = in_data(i, :);
        end
        for i = 1 : size(in_data, 1) - 1
            in_data_step1(2*i, :) = (in_data(i, :) + in_data(i+1, :)) ./ 2;
        end
        in_data = in_data_step1;
        stepStr = '50 sec';
    case 2
        stepStr = '100 sec';
    case 3
        for i = 1:2:size(in_data,1)
            in_data_step3(fix(i/2)+1,:) = in_data(i,:);
        end
        in_data = in_data_step3;
        stepStr = '200 sec';
    case 4
        for i = 1:3:size(in_data,1)
            in_data_step4(fix(i/3)+1,:) = in_data(i,:);
        end
        in_data = in_data_step4;
        stepStr = '5 min';
    case 5
        for i = 1:6:size(in_data,1)
            in_data_step5(fix(i/6)+1,:) = in_data(i,:);
        end
        in_data = in_data_step5;
        stepStr = '10 min';
    case 6
        for i = 1:12:size(in_data,1)
            in_data_step6(fix(i/12)+1,:) = in_data(i,:);
        end
        in_data = in_data_step6;
        stepStr = '15 min';
    case 7
        for i = 1:18:size(in_data,1)
            in_data_step7(fix(i/18)+1,:) = in_data(i,:);
        end
        in_data = in_data_step7;
        stepStr = '30 min';
end

for ii = 1:length(t)-1
    
    x = fix((R2_minimize - R1_minimize)/dR_minimize+1);
    y = fix((h2_minimize - h1_minimize)/dh_minimize+1);

    G1(1:x, 1:y) = 0;
    
    [~,T1] = min(abs(in_data(:,1)-t(ii)));
    [~,T2] = min(abs(in_data(:,1)-t(ii+1)));
    B = in_data(T1:T2,2:7);
    
    for jj = 1:2
        
        if jj == 2
            B = B(end:-1:1,:);
        end
        
        Algorithm = get(handles.graph_menu,'Value');
        
        if Algorithm == 1
        
            for k = 1:x
                for m = 1:y
                    R0 = R1_minimize + dR_minimize*(k-1);
                    h0 = h1_minimize + dh_minimize*(m-1);
                    [~, ~, S] = Z(R0, h0, B, 0);
                    G1(k,m) = sum(S);
                end
            end
            
        elseif Algorithm == 2
            
            for k = 1:x
                for m = 1:y
                    R0 = R1_minimize + dR_minimize*(k-1);
                    h0 = h1_minimize + dh_minimize*(m-1);
                    [~, ~, S] = Z_leastsquare(R0, h0, B, 0);
                    G1(k,m) = sum(S);
                end
            end
            
        elseif Algorithm == 3
            
            for k = 1:x
                for m = 1:y
                    R0 = R1_minimize + dR_minimize*(k-1);
                    h0 = h1_minimize + dh_minimize*(m-1);
                    [~, ~, S] = Z_Algorithm_2(R0, h0, B, 0);
                    G1(k,m) = sum(S);
                end
            end
            
        end
    
        axes(handles.discrepancy_funcion)
        imagesc(G1, [min(G1(:)) min(G1(:))*20])
        set(gca,'XTickLabel',arrayfun(@num2str, h1_minimize+(get(gca,'XTick')-1)*dh_minimize,'UniformOutput',false))
        set(gca,'YTickLabel',arrayfun(@num2str, R1_minimize+(get(gca,'YTick')-1)*dR_minimize,'UniformOutput',false))
    
        %число точек
        RND = 50;

        I=randi([1,x],RND,1);
        J=randi([1,y],RND,1);

        H(1:9) = 0;

        for n = 1:RND
            for l = 1:50
                for i = 1:3
                    for j = 1:3
                        if I(n)+i-2==0 || I(n)+i-2==x+1 || J(n)+j-2==0 || J(n)+j-2==y+1
                            H((i-1)*3 + j) = 10^(10);
                        else
                            H((i-1)*3 + j) = G1(I(n)+i-2,J(n)+j-2);
                        end
                    end
                end
            [~, ind] = min(H);
        
            i = fix((ind-1) / 3) + 1;
            j = ind - (i-1)*3;

            I(n) = I(n)+i-2;
            J(n) = J(n)+j-2;
            end
            HH(n) = G1(I(n), J(n));
        end

        MN(1:3, 1:3) = 10^(10);

        for i = 1:RND
            if HH(i) <= MN(1, 1)
                MN(1, :) = [HH(i), I(i), J(i)];
            elseif HH(i) <= MN(2, 1)
                MN(2, :) = [HH(i), I(i), J(i)];
            elseif HH(i) <= MN(3, 1)
                 MN(3, :) = [HH(i), I(i), J(i)];
            end
        end
        text(MN(1, 3), MN(1, 2), ['G = ', int2str(MN(1, 1))]);
        text(MN(2, 3), MN(2, 2), ['G = ', int2str(MN(2, 1))]);
        text(MN(3, 3), MN(3, 2), ['G = ', int2str(MN(3, 1))]);
    
        [j,i] = ginput(1);
        j = round(j);
        i = round(i);
    
        R0 = R1_minimize + dR_minimize*(i-1);
        h0 = h1_minimize + dh_minimize*(j-1);
        
        if Algorithm == 1
        
            if jj == 1
                [R1, h1, ~] = Z(R0, h0, B, 0);
            else
                [R2, h2, ~] = Z(R0, h0, B, 0);
            end
            
        elseif Algorithm == 2
            
            if jj == 1
                [R1, h1, ~] = Z_leastsquare(R0, h0, B, 0);
            else
                [R2, h2, ~] = Z_leastsquare(R0, h0, B, 0);
            end
            
        elseif Algorithm == 3
            
            if jj == 1
                [R1, h1, ~] = Z_Algorithm_2(R0, h0, B, 0);
            else
                [R2, h2, ~] = Z_Algorithm_2(R0, h0, B, 0);
            end
            
        end
        
        % This variable is needed to transfer the value of the penalty...
        % function to the function that builds the graph
        GG(jj) = G1(i,j);
    end
    
    R2 = R2(end:-1:1);
    h2 = h2(end:-1:1);
    
    Data_out = get(handles.result_table,'Data');
    Data_out(T1:T2,1:5) = [in_data(T1:T2,1),R1',h1',R2',h2'];
    
    set(handles.result_table,'Data',Data_out)
end

data_out = get(handles.result_table,'Data');



i = 1;
while data_out(i,2:5) == [0,0,0,0]
    i = i+1;
end

data_out = data_out(i:size(data_out,1),:);

[~,T1] = min(abs(in_data(:,1)-t(1)));
[~,T2] = min(abs(in_data(:,1)-t(length(t))));
%data_out(:,6:11) = in_data(T1:T2,2:7);

set(handles.result_table,'Data',data_out)

%предложить имя файла для сохранения, идентичное исходному
newfilename = strrep(filename, '_DATA.xls', '_RESULT.xls');
set(handles.save_txt,'String',newfilename)

GraphsResult(T1, T2, data_out, stepStr)
GraphsComparison(T1, T2, in_data, data_out, GG, stepStr)

function R1_minimize_Callback(hObject, eventdata, handles)
% hObject    handle to R1_minimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R1_minimize as text
%        str2double(get(hObject,'String')) returns contents of R1_minimize as a double


% --- Executes during object creation, after setting all properties.
function R1_minimize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1_minimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h2_minimize_Callback(hObject, eventdata, handles)
% hObject    handle to h2_minimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h2_minimize as text
%        str2double(get(hObject,'String')) returns contents of h2_minimize as a double


% --- Executes during object creation, after setting all properties.
function h2_minimize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h2_minimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h1_minimize_Callback(hObject, eventdata, handles)
% hObject    handle to h1_minimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h1_minimize as text
%        str2double(get(hObject,'String')) returns contents of h1_minimize as a double


% --- Executes during object creation, after setting all properties.
function h1_minimize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h1_minimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R2_minimize_Callback(hObject, eventdata, handles)
% hObject    handle to R2_minimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R2_minimize as text
%        str2double(get(hObject,'String')) returns contents of R2_minimize as a double


% --- Executes during object creation, after setting all properties.
function R2_minimize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2_minimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in limits_change.
function limits_change_Callback(hObject, eventdata, handles)
% hObject    handle to limits_change (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in graph_menu.
function graph_menu_Callback(hObject, eventdata, handles)
% hObject    handle to graph_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns graph_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from graph_menu


% --- Executes during object creation, after setting all properties.
function graph_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function File_name_Callback(hObject, eventdata, handles)

set(handles.Num_begin,'Enable','on')

% --- Executes during object creation, after setting all properties.
function File_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Num_begin_Callback(hObject, eventdata, handles)

        


% --- Executes during object creation, after setting all properties.
function Num_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Num_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_step.
function popupmenu_step_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_step contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_step


% --- Executes during object creation, after setting all properties.
function popupmenu_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_average.
function popupmenu_average_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_average contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_average


% --- Executes during object creation, after setting all properties.
function popupmenu_average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dh_txt_Callback(hObject, eventdata, handles)
% hObject    handle to dh_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dh_txt as text
%        str2double(get(hObject,'String')) returns contents of dh_txt as a double


% --- Executes during object creation, after setting all properties.
function dh_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dh_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dR_txt_Callback(hObject, eventdata, handles)
% hObject    handle to dR_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dR_txt as text
%        str2double(get(hObject,'String')) returns contents of dR_txt as a double


% --- Executes during object creation, after setting all properties.
function dR_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dR_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function save_txt_Callback(hObject, eventdata, handles)
% hObject    handle to save_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_txt as text
%        str2double(get(hObject,'String')) returns contents of save_txt as a double


% --- Executes during object creation, after setting all properties.
function save_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_btn.
function save_btn_Callback(hObject, eventdata, handles)
filename = get(handles.save_txt,'String');
out_data = get(handles.result_table,'Data');
delete(filename);
xlswrite(filename,out_data(:,1:5))


% --- Executes on button press in search.
function search_Callback(hObject, eventdata, handles)
% hObject    handle to search (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
set(handles.fileNames, 'String', name');

% --- Executes on button press in tickBtn.
function tickBtn_Callback(hObject, eventdata, handles)
% hObject    handle to tickBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir1 = get(handles.Diredit, 'String');
popUpMenuValue = get(handles.fileNames, 'Value');
dir1Files = dir(dir1);
j = 1;
for i = 1 : length(dir1Files)
    if length(dir1Files(i).name) > 6 && dir1Files(i).name(7) == '_'
        name{j} = dir1Files(i).name;
        j = j + 1;
    end
end
filename = [dir1, '\', name{popUpMenuValue}, '\', name{popUpMenuValue}, '_DATA', '.xls'];

in_data = Correct(xlsread(filename));
%Поскольку формат номера серийных номеров между Excel и Matlab отличается,
%вы должны добавить смещение 693960 к полученным номерам от xlsread.
%in_data(:,1) = in_data(:,1)+693960;

%фильтрация с окном (усреднение по соседним ячейкам)
%ячейки в начале и конце нужно исключить
average = get(handles.popupmenu_average,'Value');
switch average
    case 2
        in_data_case2 = in_data; 
        for i = 2:size(in_data,1)-1
            in_data_case2(i,2:7) = (in_data(i-1,2:7)+in_data(i,2:7)+in_data(i+1,2:7))/3;
        end
        in_data = in_data_case2(2:size(in_data,1)-1,:);
    case 3
        in_data_case3 = in_data;
        for i = 3:size(in_data,1)-2
            in_data_case3(i,2:7) = (in_data(i-2,2:7)+in_data(i-1,2:7)+in_data(i,2:7)+in_data(i+1,2:7)+in_data(i+2,2:7))/5;
        end
        in_data = in_data_case3(3:size(in_data,1)-2,:);
    case 4
        in_data_case4 = in_data;
        for i = 4:size(in_data,1)-3
            in_data_case4(i,2:7) = (in_data(i-3,2:7)+in_data(i-2,2:7)+in_data(i-1,2:7)+in_data(i,2:7)+in_data(i+1,2:7)+in_data(i+2,2:7)+in_data(i+3,2:7))/7;
        end
        in_data = in_data_case4(4:size(in_data,1)-3,:);
end

%лишние отсчеты убираются, чтобы обеспечить выбранный временной шаг
step = get(handles.popupmenu_step,'Value');
switch step
    case 2
        for i = 1:2:size(in_data,1)
            in_data_step2(fix(i/2)+1,:) = in_data(i,:);
        end
        in_data = in_data_step2;
    case 3
        for i = 1:3:size(in_data,1)
            in_data_step3(fix(i/3)+1,:) = in_data(i,:);
        end
        in_data = in_data_step3;
    case 4
        for i = 1:6:size(in_data,1)
            in_data_step4(fix(i/6)+1,:) = in_data(i,:);
        end
        in_data = in_data_step4;
    case 5
        for i = 1:12:size(in_data,1)
            in_data_step5(fix(i/12)+1,:) = in_data(i,:);
        end
        in_data = in_data_step5;
    case 6
        for i = 1:18:size(in_data,1)
            in_data_step6(fix(i/18)+1,:) = in_data(i,:);
        end
        in_data = in_data_step6;
end            

axes(handles.graph_amplitude)
plot(in_data(:,1),in_data(:,2:4))
xlim([in_data(1,1) in_data(size(in_data,1),1)])
ylim([0 100])
yLimAmp = get(gca,'YLim');
XTick = fix(in_data(1,1)*24):1:fix(in_data(end,1)*24);
set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
grid on

axes(handles.graph_phase)
plot(in_data(:,1),in_data(:,5:7))
xlim([in_data(1,1) in_data(size(in_data,1),1)])
%ylim([0 20])
yLimPhase = get(gca,'YLim');
XTick = fix(in_data(1,1)*24):1:fix(in_data(end,1)*24);
set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
grid on

%запись крайних значений промежутков обработки
N = str2double(get(handles.Num_begin,'String'));
[t,~] = ginput(N+1);
set(handles.table_begin,'Data',t)

axes(handles.graph_amplitude)
for i = 1:length(t)
    line([t(i);t(i)], yLimAmp)
end

axes(handles.graph_phase)
for i = 1:length(t)
    line([t(i);t(i)], yLimPhase)
end

% --- Executes on selection change in fileNames.
function fileNames_Callback(hObject, eventdata, handles)
% hObject    handle to fileNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fileNames contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileNames


% --- Executes during object creation, after setting all properties.
function fileNames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Diredit_Callback(hObject, eventdata, handles)
% hObject    handle to Diredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diredit as text
%        str2double(get(hObject,'String')) returns contents of Diredit as a double


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
