@echo off
for /d %%d in (??.?.*) do (
	rd /s /q %%d
)
del /q *.ips
del /q *.pchtxt
del /q *.zip