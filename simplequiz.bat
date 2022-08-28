@echo off
if not exist score.1 (echo 0) >score.1
set _lives=3
set _score=0
set _count=0

echo.>temp.1
set _max=0
for /f %%g in (index.1) do set /a _max+=1

set /a _over=%_max%-%_lives%

:loop
title Q %_count%/%_over% LIVES: %_lives% SCORE: %_score%
if %_lives% equ 0 echo YOU LOOSE&goto :loop_out
if %_count% equ %_over% echo YOU WIN&goto :loop_out

set /a _rand=(%RANDOM%%%(%_max))+1

findstr /b /c:"%_rand%#" temp.1 >nul
if %errorlevel%==0 goto :loop
echo %_rand%#>>temp.1

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
	echo thats correct!!
	set /a _score+=1
)else (
	echo thats wrong& color 4f
	set /a _lives-=1
)
	
timeout 1 >nul
cls & color 0f
set /a _count+=1

goto :loop

:loop_out

for /f "delims=" %%g in (score.1) do set _old=%%g
if %_score% gtr %_old% (
	echo YOU GOT THE HISCORE!!
	echo.
	set _old=%_score%
	(echo %_score%) >score.1
)
 
title GAME OVER - Hi SCORE: %_old% 

del temp.1
pause&exit