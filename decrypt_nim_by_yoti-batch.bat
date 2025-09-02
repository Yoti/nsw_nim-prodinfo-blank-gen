@echo off
setlocal EnableDelayedExpansion
title Decrypt NIM module script by Yoti (v20250901)
echo Decrypt NIM module script by Yoti (v20250901)

if not exist hactool.exe goto hactoolexe
if not exist hexfind.exe goto hexfindexe
if not exist makeips.exe goto makeipsexe
if not exist prod.keys goto prodkeys

echo Wait...
set "bid=EMPTYBIDEMPTYBIDEMPTYBIDEMPTYBIDEMPTYBID"
for /d %%d in (??.?.?) do (
	echo %%d
	cd %%d

	for %%f in (????????????????????????????????.nca) do (
		..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%f | find "Title Name:                     nim" >nul && (
			echo 0_%%~nf [NIM]

			if exist 0_%%~nf rd /s /q 0_%%~nf

			..\hactool.exe -x -k ..\prod.keys --disablekeywarns -t nca --exefsdir=0_%%~nf %%f >nul
			..\hactool.exe -x -k ..\prod.keys --disablekeywarns -t nso0 --uncompressed 0_%%~nf\uncp 0_%%~nf\main | find "Build Id:" > 0_%%~nf\bid.txt

			if exist 0_%%~nf\bid.txt (
				set /p bid=<0_%%~nf\bid.txt
				echo !bid:~36,40!
rem				echo !bid:~36,40!>0_%%~nf\bid.txt
				del /q 0_%%~nf\bid.txt
			)

			if exist 0_%%~nf\uncp (
				..\hexfind.exe 0_%%~nf\uncp C215001081D18952 > 0_%%~nf\off.txt
				set /p off=<0_%%~nf\off.txt
				del /q 0_%%~nf\off.txt
				..\makeips.exe 0_%%~nf\!bid:~36,40! !off! E2031FAA
				copy /b 0_%%~nf\!bid:~36,40!.ips ..\>nul
			)

			echo @nsobid-!bid:~36,40!>..\%%d.pchtxt
			echo.>>..\%%d.pchtxt
			echo // PRODINFO blanking crash fix - %%d>>..\%%d.pchtxt
			echo.>>..\%%d.pchtxt
			echo @flag print_values>>..\%%d.pchtxt
rem			echo @flag offset_shift 0x100>>..\%%d.pchtxt
			echo @flag offset_shift 0x0>>..\%%d.pchtxt
			echo.>>..\%%d.pchtxt
			echo // null out function pointer for abort>>..\%%d.pchtxt
			echo @enabled>>..\%%d.pchtxt
rem			set /a "offtxt=0x!off!-0x100"
rem			Does not works because of CMD decimal output
rem			echo 00!offtxt! E2031FAA>>..\%%d.pchtxt
			echo 00!off! E2031FAA>>..\%%d.pchtxt
		)
	)

	cd ..
)
goto thisistheend

:hactoolexe
echo Error: hactool.exe is missing!
goto thisistheend
:hexfindexe
echo Error: hexfind.exe is missing!
goto thisistheend
:makeipsexe
echo Error: makeips.exe is missing!
goto thisistheend
:prodkeys
echo Error: prod.keys is missing!
goto thisistheend

:thisistheend
endlocal
echo Done!!!
pause