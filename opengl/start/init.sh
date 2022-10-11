#!/bin/bash
#
# Help to compile glfw: https://www.glfw.org/docs/latest/compile.html
#
# X11: xorg-dev
# Wayland: libwayland-dev libxkbcommon-dev wayland-protocol extra-cmake-modules
# Some output when make install
# -- Installing: /usr/local/lib/libglfw3.a
# -- Installing: /usr/local/include/GLFW
# -- Installing: /usr/local/include/GLFW/glfw3native.h
# -- Installing: /usr/local/include/GLFW/glfw3.h
# -- Installing: /usr/local/lib/cmake/glfw3/glfw3Config.cmake
# -- Installing: /usr/local/lib/cmake/glfw3/glfw3ConfigVersion.cmake
# -- Installing: /usr/local/lib/cmake/glfw3/glfw3Targets.cmake
# -- Installing: /usr/local/lib/cmake/glfw3/glfw3Targets-noconfig.cmake
# -- Installing: /usr/local/lib/pkgconfig/glfw3.pc
#

VERSION="3.3.8"
DISPLAY_PROTOCOL=$(loginctl show-session $(loginctl | grep $USER | awk '{print $1}') -p Type | cut -d'=' -f2)
DEPENDENCIES="wget cmake make g++ libx11-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxrandr-dev libxext-dev libxcursor-dev libxinerama-dev libxi-dev"
CMAKE_VAR=""
# Note: You need to go to this page and select generate. Take the link of the glad.zip file and write it down in the GLAD_ZIP variable
# https://glad.dav1d.de/#language=c&specification=gl&api=gl%3D3.3&api=gles1%3Dnone&api=gles2%3Dnone&api=glsc2%3Dnone&profile=core&loader=on
GLAD_ZIP="https://glad.dav1d.de/generated/tmpz8vge9vrglad/glad.zip"
FOLDERS="external lib lib/glad bin include"

for folder in $FOLDERS; do
  test -d $folder && rm -rf $folder
  mkdir --parent $folder
done

echo "We are going to install dependencies related to the display protocol $DISPLAY_PROTOCOL"
if [[ "$DISPLAY_PROTOCOL" = 'x11' ]]; then 
  DEPENDENCIES+=" xorg-dev"
else
  DEPENDENCIES+=" libwayland-dev libxkbcommon-dev wayland-protocols extra-cmake-modules"
  CMAKE_VAR+="-D GLFW_USE_WAYLAND=1"
fi

echo "Using the following options for CMAKE: ${CMAKE_VAR}"

sudo apt-get install --yes ${DEPENDENCIES}

wget https://github.com/glfw/glfw/releases/download/${VERSION}/glfw-${VERSION}.zip -O /tmp/glw.zip && \
  unzip /tmp/glw.zip -d ./external/ && \
  mkdir ./external/glfw/ && \
  cmake -G "Unix Makefiles" -S ./external/glfw-${VERSION} -B ./external/glfw/ ${CMAKE_VAR} && \
  cmake --build ./external/glfw/ && cd ./external/glfw/ && \
  sudo make install && \
  cd ../../

wget ${GLAD_ZIP} -O /tmp/glad.zip && \
  unzip /tmp/glad.zip -d . && \
  mv ./src/glad.c ./lib/glad/ && rm -rf src && \
  g++ ./lib/glad/glad.c -c -I./include -o ./bin/glad.o

