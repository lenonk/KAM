set (kam_SRCS
    main.cpp
    radialbar.cpp
    backend.cpp
    backend_cpu.cpp
    backend_nvidia.cpp
    backend_other.cpp
    storagemodel.cpp
    processmodel.cpp
)

set (moc_SRCS
    ${CMAKE_SOURCE_DIR}/include/radialbar.h
    ${CMAKE_SOURCE_DIR}/include/backend.h
    ${CMAKE_SOURCE_DIR}/include/storagemodel.h
    ${CMAKE_SOURCE_DIR}/include/processmodel.h
)

qt5_add_resources(kam_RSRCS 
    resources.qrc
)

add_executable(kam ${kam_SRCS} ${moc_SRCS} ${kam_RSRCS})

target_link_libraries(kam 
    Qt5::Core 
    Qt5::Gui 
    Qt5::Qml 
    Qt5::Quick 
    Qt5::QuickControls2 
    Qt5::Svg 
    KF5::I18n
    ${Boost_LIBRARIES}
    ${X11_LIBRARIES}
    procps
    pthread
    sensors
    XNVCtrl
    nvidia-ml
    Xext
)

install(TARGETS kam ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
