if (%WXBUILD_3RD_PARTY%) == () goto END

cd ..\bakefiles
set BAKE_LIB_SUFFIX=%COMPILER_ARCH%
if (%COMPILER_ARCH%) == (32) set BAKE_LIB_SUFFIX=

echo baking new makefiles for external 3rd party libs...

bakefile -f %BAKE_FORMAT% ^
-DwxUSE_LIBJPEG=sys -DLIB_JPEG="%WXBUILD_3RD_PARTY%\lib%BAKE_LIB_SUFFIX%\%COMPILER_NAME%\link-static\runtime-dynamic\%1\jpeg-static" -DINC_JPEG="%WXBUILD_3RD_PARTY%\include\jpeg-turbo\%COMPILER_NAME%\%1\runtime-static\x%COMPILER_ARCH%" ^
-DwxUSE_LIBPNG=sys -DLIB_PNG="%WXBUILD_3RD_PARTY%\lib%BAKE_LIB_SUFFIX%\%COMPILER_NAME%\link-static\runtime-dynamic\%1\png" -DINC_PNG="%WXBUILD_3RD_PARTY%\include\png" ^
-DwxUSE_LIBTIFF=sys -DLIB_TIFF="%WXBUILD_3RD_PARTY%\lib%BAKE_LIB_SUFFIX%\%COMPILER_NAME%\link-static\runtime-dynamic\%1\tiff" -DINC_TIFF="%WXBUILD_3RD_PARTY%\include\tiff" ^
-DwxUSE_LIBZ=sys -DLIB_Z="%WXBUILD_3RD_PARTY%\lib%BAKE_LIB_SUFFIX%\%COMPILER_NAME%\link-static\runtime-dynamic\%1\z" -DINC_Z="%WXBUILD_3RD_PARTY%\include\zlib" ^
-o../msw/%MAKEFILE% -DOPTIONS_FILE=%BAKE_OPTIONS_FILE% wx_no_3rd_party.bkl


echo baked

cd ..\msw

:END