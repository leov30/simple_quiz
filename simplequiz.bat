@echo off
SETLOCAL EnableDelayedExpansion

if not exist index.1 (
REM //example of index.1 file, columns need to be separeted by a TAB, choices by a comma, also can be used with open questions	
	(echo 1	Question_1	choice_a,choice_b,choice_c	a
	echo 2	Question_2	choice_a,choice_b,choice_c	b
	echo 3	Question_3	choice_a,choice_b,choice_c	c
	echo 4	Question_4	-,-,-	answer4
	echo 5	Question_5	-,-,-	answer5
	echo 6	Question_6	-,-,-	answer6
	echo 7	Question_7	-,-,-	7
	echo 8	Question_8	-,-,-	8) >index.1

)

for /l %%g in (1,1,5) do (
		set _score[%%g]=0
		set _time[%%g]=0:0
		set _init[%%g]=NO_NAME
)

:start_game
cls
title Quiz Game, Build: 08-30-22
echo.
echo.
(echo "                     /$$                                                            ";
echo "                    |__/                                                            ";
echo "  /$$$$$$  /$$   /$$ /$$ /$$$$$$$$        /$$$$$$   /$$$$$$  /$$$$$$/$$$$   /$$$$$$ ";
echo " /$$__  $$| $$  | $$| $$|____ /$$/       /$$__  $$ |____  $$| $$_  $$_  $$ /$$__  $$";
echo "| $$  \ $$| $$  | $$| $$   /$$$$/       | $$  \ $$  /$$$$$$$| $$ \ $$ \ $$| $$$$$$$$";
echo "| $$  | $$| $$  | $$| $$  /$$__/        | $$  | $$ /$$__  $$| $$ | $$ | $$| $$_____/";
echo "|  $$$$$$$|  $$$$$$/| $$ /$$$$$$$$      |  $$$$$$$|  $$$$$$$| $$ | $$ | $$|  $$$$$$$";
echo " \____  $$ \______/ |__/|________/       \____  $$ \_______/|__/ |__/ |__/ \_______/";
echo "      | $$                               /$$  \ $$                                  ";
echo "      | $$                              |  $$$$$$/                                  ";
echo "      |__/                               \______/                                   ";) >"%temp%\temp.1"

for /f "usebackq delims=" %%g in ("%temp%\temp.1") do (
	echo %%g
	timeout 1 >nul
)
echo.
echo.
choice /t 10 /d n /m "play?"

if %errorlevel%==2 goto :score_board

cls
set _lives=3
set _score=0
set _count=0

echo.>"%temp%\temp.1"
set /a _max=0
for /f %%g in (index.1) do set /a _max+=1

set /a _over=%_max%-%_lives%

set /a "_time0=%time:~0,2%*3600+%time:~3,1%*600+%time:~4,1%*60+%time:~6,1%*10+%time:~7,1%"


:loop
title Q %_count%/%_over% * Lives: %_lives% * Score: %_score%
if %_lives% equ 0 echo YOU LOOSE&goto :loop_out
if %_count% equ %_over% echo YOU WIN&goto :loop_out

set /a "_rand=(%RANDOM%%%%_max%)+1"

findstr /r /c:"^%_rand%$" "%temp%\temp.1" >nul
if %errorlevel% equ 0 goto :loop
(echo %_rand%)>>"%temp%\temp.1"

for /f "tokens=2,3,4 delims=	" %%g in ('findstr /b /c:"%_rand%	" index.1') do (
	set _ans=%%i
	echo %%g?
	echo ------------------------------
	for /f "tokens=1,2,3 delims=," %%G in ("%%h") do (
		echo a. %%G
		echo b. %%H
		echo c. %%I
	)
)
echo.
set /p _ans1="type your answer: " || set "_ans1="
if /i "%_ans1%"=="%_ans%" (
	echo That's correct^^!^^!
	set /a _score+=1
)else (
	echo That's wrong
	color 4f
	set /a _lives-=1
)
	
timeout 1 >nul
cls & color 0f
set /a _count+=1

goto :loop

:loop_out

set /a "_time=%time:~0,2%*3600+%time:~3,1%*600+%time:~4,1%*60+%time:~6,1%*10+%time:~7,1%"
set /a "_time=%_time%-%_time0%"
set /a "_hour=%_time%/(3600)"
set /a "_min=%_time%/60"
set /a "_sec=%_time%%%60"

for /l %%g in (1,1,5) do (
	if !_score! gtr !_score[%%g]! (
		echo YOU GOT %%gst PLACE IN THE HI SCORE BOARD
		echo.
		set /p _init="Enter your name: "
		set /a _score[%%g]=%_score%
		set "_init[%%g]=!_init!"
		set "_time[%%g]=%_min%:%_sec%"
		cls
		goto :next_0
	)

)

:next_0
 
title GAME OVER

(echo "  ______                                                                                  ";
echo " /      \                                                                                 ";
echo "/$$$$$$  |  ______   _____  ____    ______          ______   __     __  ______    ______  ";
echo "$$ | _$$/  /      \ /     \/    \  /      \        /      \ /  \   /  |/      \  /      \ ";
echo "$$ |/    | $$$$$$  |$$$$$$ $$$$  |/$$$$$$  |      /$$$$$$  |$$  \ /$$//$$$$$$  |/$$$$$$  |";
echo "$$ |$$$$ | /    $$ |$$ | $$ | $$ |$$    $$ |      $$ |  $$ | $$  /$$/ $$    $$ |$$ |  $$/ ";
echo "$$ \__$$ |/$$$$$$$ |$$ | $$ | $$ |$$$$$$$$/       $$ \__$$ |  $$ $$/  $$$$$$$$/ $$ |      ";
echo "$$    $$/ $$    $$ |$$ | $$ | $$ |$$       |      $$    $$/    $$$/   $$       |$$ |      ";
echo " $$$$$$/   $$$$$$$/ $$/  $$/  $$/  $$$$$$$/        $$$$$$/      $/     $$$$$$$/ $$/       ";
echo "                                                                                          ";
echo "                                                                                          ";
echo "                                                                                          ";
echo "                                                                                          ";) >"%temp%\temp.1"

for /f "usebackq delims=" %%g in ("%temp%\temp.1") do (
	echo %%g
	timeout 1 >nul
)
timeout 3 >nul

:score_board
cls
for /l %%g in (1,1,10) do (
	for /l %%h in (1,1,%%g) do echo.
	echo                 --------------------------------------
	echo                           * TOP 5 SCORE BOARD *
	echo                 ---------------------------------------
	echo                             1st %_score[1]% %_init[1]% %_time[1]%
	echo                             2nd %_score[2]% %_init[2]% %_time[2]%
	echo                             3rd %_score[3]% %_init[3]% %_time[3]%
	echo                             4th %_score[4]% %_init[4]% %_time[4]%
	echo                             5th %_score[5]% %_init[5]% %_time[5]%
	if %%g equ 10 (timeout 10 >nul)else (timeout 1 >nul)
	cls
)

goto :start_game


REM https://ss64.com/nt/syntax-random.html
REM http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20