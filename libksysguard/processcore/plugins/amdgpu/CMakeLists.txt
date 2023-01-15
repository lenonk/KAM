add_library(ksysguard_plugin_amdgpu MODULE amdgpu.cpp)
target_link_libraries(ksysguard_plugin_amdgpu Qt::Core KSysGuard::ProcessCore KF5::I18n KF5::CoreAddons)
install(TARGETS ksysguard_plugin_amdgpu DESTINATION ${KDE_INSTALL_PLUGINDIR}/ksysguard/process)
