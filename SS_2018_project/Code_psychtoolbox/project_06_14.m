% HWANG ONYU
%{
1. struct 만들기
2. subject name 넣기
3. test1 시작&rt 넣고(function 만들기) : 그림 다섯 개
4. 문자 3개씩 배열 -> 거리 넓이기
4. 마지막으로 text 파일에 저장하기

다음에 실험 전체 다 코드 만들기(반복되는 것을 function으로 따로 빼기)
%}
%%


%1. make a struct 
%project.name = [];
%project.t1_1_corres = []; %답 일치하는지 확인(늘어나면 더 하면 된다. 
%project.t1_1_rt = []; %실행 시간 저장



%%

%2.knowing subject name & open the screen
PsychDefaultSetup(2);

KbName('UnifyKeyNames');
FlushEvents;
Screen('Preference', 'SkipSyncTests', 2);

WaitSecs(.5);
keyIsDown = 0;

[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]);
bgColor = 255;

%priority
whichScreen = max(Screen('Screens'));
maxPriorityLevel = MaxPriority(whichScreen);
Priority(maxPriorityLevel);

% knowign (changing screen) velocity
ifi = Screen('GetFlipInterval', wPtr);
waitframes = round(1/ifi);

myText = 'Write down your number';

Screen('TextFont', wPtr,'Times');
Screen('TextSize', wPtr, 48);
%Screen('TextStyle' wPtr, 2);

[xs, ys] = RectCenter(rect);


DrawFormattedText(wPtr, myText, 'Center', ys/2, 0); %text 화면에 넣기

%WaitSecs(1);
newtext = [];%이름 저장할 공간이다.

pretime = GetSecs(); %현재 시간 얻기

yesKeys = KbName('return') % enter mean
bspace = KbName('backspace');
fspace = KbName('space');



while ~keyIsDown %keyisdown은 항상 0이므로 눌러지기 전까지는 계속 실행된다.
   [secs, keyCode, deltaSecs] = KbWait(-1,2); %release(2)
   if secs-pretime > 0.02 %중복 인식을 막기 위해 일정시간 차를 두었다.
       if any(keyCode(yesKeys))
           break; %enter 치면 빠져나옴
       end
       if any(keyCode(bspace)) % backspace function
           newtext = newtext(1:end-1);
       elseif any(keyCode(fspace)) %space function
           newtext = [newtext ' '];
       else
           nt = KbName(find(keyCode));
           newtext = [newtext nt];
       end
       DrawFormattedText(wPtr, newtext,'center', ys*3/2,0);
       Screen('Flip',wPtr);
       pretime = GetSecs; %다시 여기서부터 다시 루프 시작 시간 씀
   end
end


i = str2num(newtext)
numofsub = sprintf('Subject %d', i);
project(i).name = numofsub

DrawFormattedText(wPtr, [myText '\n\n\n' newtext],'center', 'center', [0 255 0]);
vbl = 0;
vbl = Screen('Flip', wPtr,vbl+0.5*ifi);
WaitSecs(2)




%%
%3. test1 시작&rt 넣고   
% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', wPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA')

%주의사항 : a는 왼쪽, l은 오른쪽
caution = 'Push ''a'' : when left, Push ''b'' when right.';

Screen('TextFont', wPtr, 'Times')
Screen('TextSize', wPtr, 48);
Screen('DrawText', wPtr, caution, xs-400,ys,[0 0 0])
vbl = Screen('Flip', wPtr,vbl+0.5*ifi);
WaitSecs(5);

% 가운데 집중 +넣음
Screen('TextSize', wPtr,50);
Screen('DrawText', wPtr , '+',xs , ys,[0,0,0]);
vbl = Screen('Flip', wPtr,vbl+0.5*ifi);
WaitSecs(2);


%%
%개념
%사진 넣기(maketexture,drawtexture)
leftarr = imread('left_arrow_back.png');
rightarr = imread('right_arrow_back.PNG');

[rheight, rwidth, rcolor] = size(rightarr);
[lheight, lwidth, lcolor] = size(leftarr);

image_l = [1/5*xs ys-lheight*1/2 lwidth+1/5*xs ys+lheight/2];
image_r = [4/5*xs ys-rheight/2 rwidth+4/5*xs rheight+rheight/2];

l_image= Screen('MakeTexture', wPtr, leftarr);
%r_image = Screen('MakeTexture', wPtr, rightarr);

Screen('DrawTexture', wPtr, l_image, [],image_l);
%Screen('DrawTexture', wPtr, r_image, [], image_r);

vbl = Screen('Flip', wPtr,vbl+0.5*ifi);

WaitSecs(2);    
sca;

%%
% 5개짜리 만들기






