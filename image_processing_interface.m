function varargout = image_processing_interface(varargin)
% IMAGE_PROCESSING_INTERFACE MATLAB code for image_processing_interface.fig
%      IMAGE_PROCESSING_INTERFACE, by itself, creates a new IMAGE_PROCESSING_INTERFACE or raises the existing
%      singleton*.
%
%      H = IMAGE_PROCESSING_INTERFACE returns the handle to a new IMAGE_PROCESSING_INTERFACE or the handle to
%      the existing singleton*.
%
%      IMAGE_PROCESSING_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_PROCESSING_INTERFACE.M with the given input arguments.
%
%      IMAGE_PROCESSING_INTERFACE('Property','Value',...) creates a new IMAGE_PROCESSING_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before image_processing_interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to image_processing_interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help image_processing_interface

% Last Modified by GUIDE v2.5 19-Mar-2021 15:10:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @image_processing_interface_OpeningFcn, ...
                   'gui_OutputFcn',  @image_processing_interface_OutputFcn, ...
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


% --- Executes just before image_processing_interface is made visible.
function image_processing_interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to image_processing_interface (see VARARGIN)

% Choose default command line output for image_processing_interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
h = handles.output; %返回其句柄
% UIWAIT makes image_processing_interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = image_processing_interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_loadpic.
function pushbutton_loadpic_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadpic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Raw_image
 [filename, pathname]=uigetfile({'*.bmp;*.jpg;*.png','ALL FILES(*.*)'},'选择图片文件');
if isequal([filename pathname],[0,0])
    return;
end
str=[pathname filename];%选择的图片文件路径和文件名
Raw_image=imread(str);
axes(handles.axes1);
imshow(Raw_image);
title('宿主图像');

[M,N] = size(rgb2gray(Raw_image));%显示加载的(转化为灰度图后的)图片尺寸信息
set(handles.text1, 'String','宿主图片');
temp = get(handles.text1, 'String');
tep = [num2str(M) '*' num2str(N)];
temp = strcat(temp, tep);
set(handles.text1, 'String',temp);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Watermark_image
 [filename, pathname]=uigetfile({'*.bmp;*.jpg;*.png','ALL FILES(*.*)'},'选择图片文件');
if isequal([filename pathname],[0,0])
    return;
end
str=[pathname filename];%选择的图片文件路径和文件名
Watermark_image=imread(str);
% handles.origil=Raw_imgae;
% guidata(hObject,handles);
axes(handles.axes2);
imshow(Watermark_image);
title('水印图像');

[M,N] = size(rgb2gray(Watermark_image));%显示加载的(转化为灰度图后的)图片尺寸信息
set(handles.text1, 'String','水印图像');
temp = get(handles.text1, 'String');
tep = [num2str(M) '*' num2str(N)];
temp = strcat(temp, tep);
set(handles.text1, 'String',temp);

function pushbutton_3_Callback(hObject, eventdata, handles)
global Watermark_image Raw_image WatermarketImg m n
[M,N] = size(rgb2gray(Raw_image));
[m,n] = size(rgb2gray(Watermark_image));
if m>M || n>N
    Watermark_image = imresize(Watermark_image,[M,N]);
    set(handles.text1, 'String','水印图像太大！无法嵌入！已将其调整为和宿主图片一样大');
end
Watermark_image = im2double(Watermark_image);
Watermark_image = imbinarize(Watermark_image,0.90);
% axes(handles.axes3);
% imshow(im2uint8(Watermark_image));
% title('二值化后的水印图像');
WatermarketImg = LSB_Encode(Raw_image,Watermark_image,M,N,m,n);%嵌入水印信息
axes(handles.axes3);
imshow(im2uint8(WatermarketImg));
title('嵌入水印后的宿主图像');
set(handles.text1, 'String','嵌入水印后的宿主图像');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m n WatermarketImg
Image = LSB_Decode(WatermarketImg, m, n);
axes(handles.axes3);
imshow(im2uint8(Image));
title('提取到的水印图像');
set(handles.text1, 'String','提取到的水印图像');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Watermark_image
Watermark_image = im2double(Watermark_image);
Watermark_image = imbinarize(Watermark_image,0.90);
axes(handles.axes2);
imshow(im2uint8(Watermark_image));
title('二值化后的水印图像');

