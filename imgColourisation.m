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

% Last Modified by GUIDE v2.5 15-Feb-2017 13:53:37

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

% Hide the axes
axes(handles.axes1)
set(gca,'xtick',[],'ytick',[])
% set(gca,'visible','off')

axes(handles.axes2)
set(gca,'xtick',[],'ytick',[])

% Choose default command line output for imgColourisation
handles.output = hObject;

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


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, filepath]=uigetfile({'*.*','All Files'}, 'Select input image');
% disp([filepath, filename]);
handles.img = imread([filepath, filename]);

[l,m,~] = size(handles.img);
handles.total_pixels = l*m;
handles.color_pixels = 0;

% Show the picture
axes(handles.axes1); 
imshow(handles.img);

guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fake_image.
function fake_image_Callback(hObject, eventdata, handles)
% hObject    handle to fake_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.fake = fakeImage(handles.img, handles.color_pixels, 1); % For the moment fixed seed
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

handles.input_style = 'number';

guidata(hObject, handles)
