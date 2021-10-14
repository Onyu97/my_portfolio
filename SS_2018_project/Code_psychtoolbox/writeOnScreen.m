function writeOnScreen
	KbName('UnifyKeyNames');
	FlushEvents;
	Screen('Preference', 'SkipSyncTests', 1);
	WaitSecs(.5);
	keyIsDown = 0;
	
	[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]);
	bgColor = 255;
	
	myText = 'Press any key when you are ready';
	Screen('TextFont', wPtr, 'Times');
	Screen('TextSize',wPtr, 48);
	Screen('TextStyle', wPtr, 2);
	DrawFormattedText(wPtr,myText,'center','center',0);
	Screen('Flip', wPtr);
	WaitSecs(1);
	Screen('Flip', wPtr);
	newText = [];
	preTime = GetSecs();
	yesKeys = KbName('return');
	bspace = KbName('backspace');
	fspace = KbName('space');
	while ~keyIsDown
		[secs, keyCode, deltaSecs] = KbWait(-1, 2);
		if secs - preTime > 0.02
			if any(keyCode(yesKeys))
				break;
			end
			if any(keyCode(bspace))
				newText = newText(1:end-1);
			elseif any(keyCode(fspace))
				newText = [newText ' '];
			else
				nt = KbName(find(keyCode));
				newText = [newText nt];
			end
			DrawFormattedText(wPtr,newText,'center','center',0);
			Screen('Flip', wPtr);
			preTime = GetSecs();
		end
	end
	DrawFormattedText(wPtr,newText,'center','center',[255 0 0]);
	Screen('Flip', wPtr);
	WaitSecs(2)
	sca;
end