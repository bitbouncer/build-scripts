REM need separate installation of git, nasm, active perl & visual studio
REM make sure that active perl is before any other perl - git's for example in PATH

set VISUALSTUDIO_VERSION=12.0
set VISUALSTUDIO_VERSION_MAJOR=12
set BOOST_VERSION=1_59_0
set BOOST_VERSION_DOTTED=1.59.0
set OPEN_SSL_VERSION=openssl-1.0.2g

set C_ARES_VERSION=1.11.0
set CARES_DIR=c-ares-%C_ARES_VERSION%
set CURL_VERSION=7.47.1
set ZLIB_VERSION=1.2.8
set SNAPPY_VERSION=1.1.3
REM set AVRO_VERSION=1.7.7
REM set AVRO_DIR=avro-cpp-%AVRO_VERSION%
set AVRO_DIR=avro\lang\c++ 
set JOYENT_HTTP_VERSION=2.3

call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" amd64


SET INCLUDE=%INCLUDE%;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include;

REM wget --no-check-certificate ftp://ftp.sunet.se/pub/www/servers/apache/dist/avro/avro-%AVRO_VERSION%/cpp/avro-cpp-%AVRO_VERSION%.tar.gz
REM tar xvf avro-cpp-%AVRO_VERSION%.tar.gz
REM del avro-cpp-%AVRO_VERSION%.tar.gz
REM until avro changes gets merged

wget --no-check-certificate http://sourceforge.net/projects/boost/files/boost/%BOOST_VERSION_DOTTED%/boost_%BOOST_VERSION%.tar.gz/download -Oboost_%BOOST_VERSION%.tar.gz
gzip -d boost_%BOOST_VERSION%.tar.gz
tar xf boost_%BOOST_VERSION%.tar
del boost_%BOOST_VERSION%.tar
move boost_%BOOST_VERSION% boost

REM wget --no-check-certificate https://github.com/bagder/c-ares/archive/master.zip -Oc-ares.zip
wget --no-check-certificate http://c-ares.haxx.se/download/c-ares-%C_ARES_VERSION%.tar.gz -Oc-ares.tar.gz
gzip -d c-ares.tar.gz
tar xf c-ares.tar
del c-ares.tar

wget --no-check-certificate https://github.com/google/snappy/releases/download/%SNAPPY_VERSION%/snappy-%SNAPPY_VERSION%.tar.gz  -Osnappy.tar.gz
gzip -d snappy.tar.gz
tar xf snappy.tar
del snappy.tar

wget --no-check-certificate https://curl.haxx.se/download/curl-%CURL_VERSION%.tar.gz -Ocurl.tar.gz
gzip -d curl.tar.gz
tar xf curl.tar
del curl.tar

wget --no-check-certificate https://github.com/nodejs/http-parser/archive/v%JOYENT_HTTP_VERSION%.tar.gz -Ohttp_parser.tar.gz
gzip -d http_parser.tar.gz
tar xf http_parser.tar
del http_parser.tar

wget --no-check-certificate https://openssl.org/source/%OPEN_SSL_VERSION%.tar.gz -Oopenssl.tar.gz
gzip -d openssl.tar.gz
tar xf openssl.tar
del openssl.tar
rmdir /s /q %OPEN_SSL_VERSION%\include

wget http://zlib.net/zlib-%ZLIB_VERSION%.tar.gz -Ozlib.tar.gz
gzip -d zlib.tar.gz
tar xf zlib.tar
del zlib.tar

@ECHO BUILDING OPEN_SSL
cd %OPEN_SSL_VERSION%
start /WAIT perl Configure VC-WIN64A --prefix=/OpenSSL-Win64
call ms\do_win64a
nmake -f ms\nt.mak
mkdir include
xcopy /e /s inc32\* include
cd ..


@ECHO BUILDING C-ARES
cd %CARES_DIR%
rmdir /s /q mscv120
rmdir /s /q libs

mkdir libs
mkdir libs\x64
mkdir libs\x64\Debug
mkdir libs\x64\Release

REM needed for git master
call buildconf.bat
nmake -f Makefile.msvc

REM copy static libs to more convenient location for CMake
copy msvc120\cares\lib-debug\libcaresd.lib libs\x64\Debug\libcares.lib
copy msvc120\cares\lib-release\libcares.lib libs\x64\Release\libcares.lib

cd ..
@ECHO DONE WITH C-ARES

@ECHO BUILDING LIBCURL
cd curl-%CURL_VERSION%

rmdir /s /q builds
rmdir /s /q libs

mkdir libs
mkdir libs\x64
mkdir libs\x64\Debug
mkdir libs\x64\Release
mkdir libs\win32
mkdir libs\win32\Debug
mkdir libs\win32\Release

#this is for cares build
#cd winbuild
#SET INCLUDE=%INCLUDE%;..\..\%OPEN_SSL_VERSION%\include;..\include;..\..\%CARES_DIR%;..\..\%OPEN_SSL_VERSION%\include\openssl
#SET LIB=%LIB%;..\..\%OPEN_SSL_VERSION%\out32;..\..\%CARES_DIR%\msvc120\cares\lib-debug;..\..\%CARES_DIR%\msvc120\cares\lib-release
#nmake /f makefile.vc mode=static VC=%VISUALSTUDIO_VERSION_MAJOR% WITH_CARES=static WITH_SSL=static ENABLE_SSPI=no ENABLE_WINSSL=no ENABLE_IDN=no DEBUG=yes MACHINE=x64
#nmake /f makefile.vc mode=static VC=%VISUALSTUDIO_VERSION_MAJOR% WITH_CARES=static WITH_SSL=static ENABLE_SSPI=no ENABLE_WINSSL=no ENABLE_IDN=no DEBUG=no MACHINE=x64
#cd ..

#this is without c-ares
cd winbuild
SET INCLUDE=%INCLUDE%;..\..\%OPEN_SSL_VERSION%\include;..\include;..\..\%OPEN_SSL_VERSION%\include\openssl
SET LIB=%LIB%;..\..\%OPEN_SSL_VERSION%\out32;
nmake /f makefile.vc mode=static VC=%VISUALSTUDIO_VERSION_MAJOR% WITH_SSL=static ENABLE_SSPI=no ENABLE_WINSSL=no ENABLE_IDN=no DEBUG=yes MACHINE=x64
nmake /f makefile.vc mode=static VC=%VISUALSTUDIO_VERSION_MAJOR% WITH_SSL=static ENABLE_SSPI=no ENABLE_WINSSL=no ENABLE_IDN=no DEBUG=no MACHINE=x64
cd ..

#non ssl builds
#copy builds\libcurl-vc%VISUALSTUDIO_VERSION_MAJOR%-x64-debug-static-ipv6\lib\libcurl_a_debug.lib libs\x64\Debug\libcurl.lib 
#copy builds\libcurl-vc%VISUALSTUDIO_VERSION_MAJOR%-x64-release-static-ipv6\lib\libcurl_a.lib libs\x64\Release\libcurl.lib 

#ssl static libs
copy builds\libcurl-vc%VISUALSTUDIO_VERSION_MAJOR%-x64-debug-static-ssl-static-ipv6\lib\libcurl_a_debug.lib libs\x64\Debug\libcurl.lib 
copy builds\libcurl-vc%VISUALSTUDIO_VERSION_MAJOR%-x64-release-static-ssl-static-ipv6\lib\libcurl_a.lib libs\x64\Release\libcurl.lib 

#ssl + cares static libs
#copy builds\libcurl-vc%VISUALSTUDIO_VERSION_MAJOR%-x64-debug-static-ssl-static-cares-static-ipv6\lib\libcurl_a_debug.lib libs\x64\Debug\libcurl.lib 
#copy builds\libcurl-vc%VISUALSTUDIO_VERSION_MAJOR%-x64-release-static-ssl-static-cares-static-ipv6\lib\libcurl_a.lib libs\x64\Release\libcurl.lib 

cd ..
@ECHO DONE WITH CURL

@ECHO BUILDING ZLIB
cd zlib-%ZLIB_VERSION%
nmake -f win32/Makefile.msc
cd ..

@ECHO BUILDING BOOST
cd boost
rmdir /s /q bin.v2
call bootstrap.bat
#b2 -j 4 -toolset=msvc-%VISUALSTUDIO_VERSION% include="C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include" address-model=64 --build-type=complete link=static --stagedir=lib\x64 stage -s ZLIB_SOURCE=%CD%\..\zlib-%ZLIB_VERSION%
b2 -j 4 -toolset=msvc-%VISUALSTUDIO_VERSION% include="C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include" address-model=64 --build-type=complete --abbreviate-paths --stagedir=lib\x64 stage -s ZLIB_SOURCE=%CD%\..\zlib-%ZLIB_VERSION%
rmdir /s /q bin.v2
cd ..

