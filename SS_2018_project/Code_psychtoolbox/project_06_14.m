% HWANG ONYU
%{
1. struct �����
2. subject name �ֱ�
3. test1 ����&rt �ְ�(function �����) : �׸� �ټ� ��
4. ���� 3���� �迭 -> �Ÿ� ���̱�
4. ���������� text ���Ͽ� �����ϱ�

������ ���� ��ü �� �ڵ� �����(�ݺ��Ǵ� ���� function���� ���� ����)
%}
%%


%1. make a struct 
%project.name = [];
%project.t1_1_corres = []; %�� ��ġ�ϴ��� Ȯ��(�þ�� �� �ϸ� �ȴ�. 
%project.t1_1_rt = []; %���� �ð� ����



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


DrawFormattedText(wPtr, myText, 'Center', ys/2, 0); %text ȭ�鿡 �ֱ�

%WaitSecs(1);
newtext = [];%�̸� ������ �����̴�.

pretime = GetSecs(); %���� �ð� ���

yesKeys = KbName('return') % enter mean
bspace = KbName('backspace');
fspace = KbName('space');



while ~keyIsDown %keyisdown�� �׻� 0�̹Ƿ� �������� �������� ��� ����ȴ�.
   [secs, keyCode, deltaSecs] = KbWait(-1,2); %release(2)
   if secs-pretime > 0.02 %�ߺ� �ν��� ���� ���� �����ð� ���� �ξ���.
       if any(keyCode(yesKeys))
           break; %enter ġ�� ��������
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
       pretime = GetSecs; %�ٽ� ���⼭���� �ٽ� ���� ���� �ð� ��
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
%3. test1 ����&rt �ְ�   
% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', wPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA')

%���ǻ��� : a�� ����, l�� ������
caution = 'Push ''a'' : when left, Push ''b'' when right.';

Screen('TextFont', wPtr, 'Times')
Screen('TextSize', wPtr, 48);
Screen('DrawText', wPtr, caution, xs-400,ys,[0 0 0])
vbl = Screen('Flip', wPtr,vbl+0.5*ifi);
WaitSecs(5);

% ��� ���� +����
Screen('TextSize', wPtr,50);
Screen('DrawText', wPtr , '+',xs , ys,[0,0,0]);
vbl = Screen('Flip', wPtr,vbl+0.5*ifi);
WaitSecs(2);


%%
%����
%���� �ֱ�(maketexture,drawtexture)
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
% 5��¥�� �����






