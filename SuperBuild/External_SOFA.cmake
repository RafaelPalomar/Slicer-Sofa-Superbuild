set(proj SOFA)

# Set dependency list
set(${proj}_DEPENDS
  ""
  )

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj)

if(${SUPERBUILD_TOPLEVEL_PROJECT}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${SUPERBUILD_TOPLEVEL_PROJECT}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED SOFA_DIR AND NOT EXISTS ${SOFA_DIR})
  message(FATAL_ERROR "SOFA_DIR [${SOFA_DIR}] variable is defined but corresponds to nonexistent directory")
endif()

if(NOT DEFINED ${proj}_DIR AND NOT ${SUPERBUILD_TOPLEVEL_PROJECT}_USE_SYSTEM_${proj})

  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj})
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    # Note: Update the repository URL and tag to match the correct SOFA version
    GIT_REPOSITORY "https://github.com/sofa-framework/sofa.git"
    GIT_TAG "v23.06.00"
    SOURCE_DIR ${EP_SOURCE_DIR}
    BINARY_DIR ${EP_BINARY_DIR}
    CMAKE_CACHE_ARGS
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}
      -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=${CMAKE_CXX_STANDARD_REQUIRED}
      -DCMAKE_CXX_EXTENSIONS:BOOL=${CMAKE_CXX_EXTENSIONS}
      -DAPPLICATION_RUNSOFA:BOOL=OFF
      -DAPPLICATION_SCENECHECKING:BOOL=OFF
      -DCOLLECTION_SOFACONSTRAINT:BOOL=OFF
      -DCOLLECTION_SOFAGENERAL:BOOL=OFF
      -DCOLLECTION_SOFAGRAPHCOMPONENT:BOOL=OFF
      -DCOLLECTION_SOFAGUI:BOOL=OFF
      -DCOLLECTION_SOFAGUICOMMON:BOOL=OFF
      -DCOLLECTION_SOFAGUIQT:BOOL=OFF
      -DCOLLECTION_SOFAMISCCOLLISION:BOOL=OFF
      -DCOLLECTION_SOFAUSERINTERACTION:BOOL=OFF
      -DLIBRARY_SOFA_GUI:BOOL=OFF
      -DLIBRARY_SOFA_GUI_COMMON:BOOL=OFF
      -DMODULE_SOFA_GUI_COMPONENT:BOOL=OFF
      -DPLUGIN_SOFA_GUI_BATCH:BOOL=OFF
      -DPLUGIN_SOFA_GUI_QT:BOOL=OFF
      -DSOFA_ROOT:PATH=${EP_SOURCE_DIR}
      -DSOFA_WITH_OPENGL:BOOL=OFF
    INSTALL_COMMAND ""
    DEPENDS
      ${${proj}_DEPENDS}
    )
  set(${proj}_DIR ${EP_BINARY_DIR})

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDS})
endif()

mark_as_superbuild(${proj}_DIR:PATH)
