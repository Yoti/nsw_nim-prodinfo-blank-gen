@echo off
setlocal EnableDelayedExpansion
title Decrypt USB module script by Yoti (v20250729)
echo Decrypt USB module script by Yoti (v20250729)

if not exist hactool.exe goto hactoolexe
if not exist prod.keys goto prodkeys

echo Wait...
set "bid=EMPTYBIDEMPTYBIDEMPTYBIDEMPTYBIDEMPTYBID"
for /d %%d in (??.?.?) do (
	echo %%d
	cd %%d

	for %%f in (????????????????????????????????.nca) do (
		..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%f | find "Title Name:                     usb" >nul && (
			echo 9_%%~nf [USB]

			if exist 9_%%~nf rd /s /q 9_%%~nf

			..\hactool.exe -x -k ..\prod.keys --disablekeywarns -t nca --exefsdir=9_%%~nf %%f >nul
			..\hactool.exe -x -k ..\prod.keys --disablekeywarns -t nso0 --uncompressed 9_%%~nf\uncp 9_%%~nf\main | find "Build Id:" > 9_%%~nf\bid.txt

			if exist 9_%%~nf\bid.txt (
				set /p bid=<9_%%~nf\bid.txt
				echo !bid:~36,40!
rem				echo !bid:~36,40!>9_%%~nf\bid.txt
				del /q 9_%%~nf\bid.txt
			)
		)
	)

	cd ..
)
goto thisistheend

:hactoolexe
echo Error: hactool.exe is missing!
goto thisistheend
:prodkeys
echo Error: prod.keys is missing!
goto thisistheend

:thisistheend
endlocal
echo Done!!!
pause