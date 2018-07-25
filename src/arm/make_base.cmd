@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsamd64_arm.bat"
::@call "%~dp0..\..\VC-LTL helper for nmake.cmd"

set libfileroot=%~dp0..\..\lib\arm

set libfile=%libfileroot%\msvcrt.lib


lib /def:"%~dp0msvcrt.def" /out:"%libfile%" /MACHINE:%Platform%



"D:\�û�����\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" CreateWeaks  /MACHINE:%Platform% /def:"%~dp0..\msvcrt_forward.def"  /out:"%libfileroot%\objs\msvcrt_forward"

::�������ģʽ
"D:\�û�����\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" CreateWeaks  /MACHINE:%Platform% /def:"%~dp0..\msvcrt_light.def"  /out:"%libfileroot%\objs\msvcrt_light"

::�����ǿģʽ
"D:\�û�����\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" CreateWeaks  /MACHINE:%Platform% /def:"%~dp0..\msvcrt_advanced.def"  /out:"%libfileroot%\objs\msvcrt_advanced"


set libfiletmp=%libfile%

::copy "%libfile%" "%libfiletmp%" /y

::ɾ�����ⲿ��ǵĵ������
::lib "%libfile%" /remove:msvcrt2.dll
::ɾ������msvcrt.dll����
::lib "%libfiletmp%" /remove:msvcrt.dll

::ɾ������obj�ļ�
::"D:\�û�����\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" RemoveAllObj "%libfiletmp%"

::"D:\�û�����\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%libfiletmp%" x64 all msvcrt2.dll msvcrt.dll



pushd "%libfileroot%"

md "%libfileroot%\Vista"
md "%libfileroot%\Vista\Advanced"
md "%libfileroot%\Vista\Light"


"D:\�û�����\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%libfile%" %Platform% "%~dp0..\msvcrt_forward.def" msvcrt.dll msvcrt3.dll
lib "%libfile%" /remove:msvcrt3.dll

::����ͨ��ת����
lib "%libfile%" objs\msvcrt_forward\*



::����msvcrt_light.lib for vista
set tagetlibfile=%libfileroot%\Vista\Light\msvcrt_Platform.lib
copy "%libfiletmp%" "%tagetlibfile%" /y
lib "%tagetlibfile%" objs\msvcrt_light\*

"D:\�û�����\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%tagetlibfile%" %Platform% "%~dp0..\msvcrt_light.def" msvcrt.dll msvcrt2.dll
lib "%tagetlibfile%" /remove:msvcrt2.dll

::����msvcrt_advanced.lib for vista
set tagetlibfile=%libfileroot%\Vista\Advanced\msvcrt_Platform.lib
copy "%libfiletmp%" "%tagetlibfile%" /y
lib "%tagetlibfile%" objs\msvcrt_advanced\*

"D:\�û�����\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%tagetlibfile%" %Platform% "%~dp0..\msvcrt_advanced.def" msvcrt.dll msvcrt2.dll
lib "%tagetlibfile%" /remove:msvcrt2.dll


::lib "%libfile%" "%~dp0ntdlllite.lib"

popd

pause