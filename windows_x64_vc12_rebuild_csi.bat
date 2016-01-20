set VISUALSTUDIO_VERSION=12.0
set VISUALSTUDIO_VERSION_MAJOR=12

call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" amd64

cd json-spirit
git pull
call rebuild_win64_vc12.bat
cd ..

cd csi-http-common
git pull
call rebuild_win64_vc12.bat
cd ..

cd csi-http-client
git pull
call rebuild_win64_vc12.bat
cd ..

cd csi-http-server
git pull
call rebuild_win64_vc12.bat
cd ..

cd csi-avro-utils
git pull
call rebuild_win64_vc12.bat
cd ..

cd postgres-asio
git pull
call rebuild_win64_vc12.bat
cd ..

cd csi-kafka
git pull
call rebuild_win64_vc12.bat
cd ..

cd csi-samples
git pull
call rebuild_win64_vc12.bat
cd ..

cd kafka2influx
git pull
call rebuild_win64_vc12.bat
cd ..

cd phoebe
git pull
call rebuild_win64_vc12.bat
cd ..
