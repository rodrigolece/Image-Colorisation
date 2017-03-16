function varargout = imgColourisation(varargin)
% IMGCOLOURISATION MATLAB code for imgColourisation.fig
%      IMGCOLOURISATION, by itself, creates a new IMGCOLOURISATION or raises the existing
%      singleton*.
%
%      H = IMGCOLOURISATION returns the handle to a new IMGCOLOURISATION or the handle to
%      the existing singleton*.
%
%      IMGCOLOURISATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMGCOLOURISATION.M with the given input arguments.
%
%      IMGCOLOURISATION('Property','Value',...) creates a new IMGCOLOURISATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imgColourisation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imgColourisation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imgColourisation

% Last Modified by GUIDE v2.5 15-Mar-2017 15:06:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imgColourisation_OpeningFcn, ...
                   'gui_OutputFcn',  @imgColourisation_OutputFcn, ...
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


% --- Executes just before imgColourisation is made visible.
function imgColourisation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imgColourisation (see VARARGIN)

% Choose default command line output for imgColourisation
handles.output = hObject;

handles.sigma1 = 100;
handles.sigma2 = 100;
handles.p = 0.5;
handles.delta = 2e-6;

handles.errors = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imgColourisation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imgColourisation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in mouse_btn.
function mouse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to mouse_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1)

[k, l, ~] = size(handles.img);

[x, y] = ginput(100); 
% We choose an arbitrarily big number, the user will escape before reaching it
x = round(x); y = round(y);

px = sub2ind([k, l], y, x);
handles.color_pixels = px;


handles.fake = fakeImage(handles.img, px);

axes(handles.axes2)
imshow(handles.fake)

guidata(hObject, handles)


% --- Executes on button press in fake_image.
function fake_image_Callback(hObject, eventdata, handles)
% hObject    handle to fake_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

px = nColourNodes(handles.img, handles.color_pixels, 1); % For the moment fixed seed
handles.color_pixels = px;

handles.fake = fakeImage(handles.img, px);

axes(handles.axes2)
imshow(handles.fake)

guidata(hObject, handles)



function pixel_input_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_input as text
%        str2double(get(hObject,'String')) returns contents of pixel_input as a double

input = str2double(get(handles.pixel_input,'String'));

switch handles.input_style
    case 'number'
        disp('number')
        handles.color_pixels = input;
    case 'percentage'
        disp('percentage')
        handles.color_pixels = round(input * handles.total_pixels/100);
end

guidata(hObject, handles)
        

% --- Executes during object creation, after setting all properties.
function pixel_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in input_style.
function input_style_Callback(hObject, eventdata, handles)
% hObject    handle to input_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns input_style contents as cell array
%        contents{get(hObject,'Value')} returns selected item from input_style

% The two options
contents = cellstr(get(hObject,'String'));

switch contents{get(hObject,'Value')}
    case contents{2}
        handles.input_style = 'number';
    case contents{3}
        handles.input_style = 'percentage';
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function input_style_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% handles.input_style = 'number';

guidata(hObject, handles)



function edit_sigma1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigma1 as text
%        str2double(get(hObject,'String')) returns contents of edit_sigma1 as a double

disp('Run again to see results')
handles.sigma1 = str2double(get(handles.edit_sigma1,'String'));
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit_sigma1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sigma2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigma2 as text
%        str2double(get(hObject,'String')) returns contents of edit_sigma2 as a double

disp('Run again to see results')
handles.sigma2 = str2double(get(handles.edit_sigma2,'String'));
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit_sigma2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_p_Callback(hObject, eventdata, handles)
% hObject    handle to edit_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_p as text
%        str2double(get(hObject,'String')) returns contents of edit_p as a double

disp('Run again to see results')
handles.p = str2double(get(handles.edit_p,'String'));
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_delta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delta as text
%        str2double(get(hObject,'String')) returns contents of edit_delta as a double


disp('Run again to see results')
handles.delta = str2double(get(handles.edit_delta,'String'));
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function edit_delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_gauss.
function btn_gauss_Callback(hObject, eventdata, handles)
% hObject    handle to btn_gauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btn_gauss

if get(hObject,'Value')
    handles.func = 'gauss';
    disp('gauss')
    guidata(hObject, handles);
end


% --- Executes on button press in btn_compact.
function btn_compact_Callback(hObject, eventdata, handles)
% hObject    handle to btn_compact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btn_compact

if get(hObject,'Value')
    handles.func = 'compact';
    disp('compact')
    guidata(hObject, handles);
end


% --- Executes on button press in recolour.
function recolour_img_Callback(hObject, eventdata, handles)
% hObject    handle to recolour_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('recolour')

tic;
handles.reconstructed = recolourFake(handles.fake, handles.color_pixels, ...
    handles.func, handles.sigma1, handles.sigma2, handles.p, handles.delta);
time = toc;

error = squareError(handles.img, handles.reconstructed);
handles.errors = [handles.errors; error];

axes(handles.axes2)
imshow(handles.reconstructed)
% set(handles.main_text, 'String', ['Time: ', str2double(time), '\n', ...
%     'Error: ', str2double(error)] );

axes(handles.axes3)
% hold on
set(gca, 'ColorOrderIndex', 1)
plot(handles.errors)
% hold off

guidata(hObject, handles)



% --------------------------------------------------------------------
function load_image_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, filepath]=uigetfile({'*.*','All Files'}, 'Select input image');
% disp([filepath, filename]);
handles.img = imread([filepath, filename]);

[k, l, ~] = size(handles.img);
handles.total_pixels = k*l;
handles.color_pixels = 0;

% Show the picture
axes(handles.axes1); 
imshow(handles.img);

guidata(hObject, handles);


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
