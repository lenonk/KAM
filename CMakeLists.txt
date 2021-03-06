cmake_minimum_required(VERSION 3.0)

project(kam)

include(FeatureSummary)

################# set KDE specific information #################
find_package(ECM 0.0.8 REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(ECMPoQmTools)

################# Find dependencies #################
find_package(Qt5 REQUIRED COMPONENTS Core Gui Qml QuickControls2 Svg)
find_package(KF5Kirigami2)
find_package(KF5I18n)
find_package(Boost COMPONENTS system filesystem exception REQUIRED)
find_package(X11 REQUIRED)

set(Boost_USE_MULTITHREADED ON) 
set(Boost_USE_STATIC_RUNTIME OFF)
set(Boost_USE_STATIC_LIBS OFF) 

include_directories(
    ${CMAKE_SOURCE_DIR}/include
    ${Boost_INCLUDE_DIRS}
    ${X11_INCLUDE_DIR}
)

if (CMAKE_CXX_FLAGS MATCHES "-fno-exceptions")
    string (REGEX REPLACE "-fno-exceptions" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
endif()

################# Enable C++17 features for clang and gcc #################
set(CMAKE_CXX_STANDARD 17)

################# build and install #################
add_subdirectory(src)

install(PROGRAMS org.kde.kam.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES org.kde.kam.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
