add_custom_command(
    OUTPUT ${SRC_ROOT}/helper/paramsize.cpp
    COMMAND ${PYTHON_EXECUTABLE} ${SRC_ROOT}/helper/paramsize.py
    DEPENDS
	${SPECS_SCRIPTS}
        ${SRC_ROOT}/specs/glesparams.py
        ${SRC_ROOT}/helper/paramsize.py
    WORKING_DIRECTORY ${SRC_ROOT}/helper
)

add_custom_command(
    OUTPUT ${SRC_ROOT}/specs/pa_func_to_version.cpp
    COMMAND ${PYTHON_EXECUTABLE} ${SRC_ROOT}/specs/glxml_to_extensions.py
    DEPENDS
    ${SPECS_SCRIPTS}
    ${SRC_ROOT}/specs/glxml_to_extensions.py
    ${THIRDPARTY_INCLUDE_DIRS}/opengl-registry/xml/gl.xml
    WORKING_DIRECTORY ${SRC_ROOT}/specs
)

add_custom_command(
        OUTPUT ${SRC_ROOT}/common/call_parser.cpp
        COMMAND ${PYTHON_EXECUTABLE} ${SRC_ROOT}/common/call_parser.py
        DEPENDS
            ${SPECS_SCRIPTS}
            ${SRC_ROOT}/common/call_parser.py
        WORKING_DIRECTORY ${SRC_ROOT}/common
)

set(SRC_FASTFORWARD
    ${SRC_ROOT}/dispatch/eglproc_auto.hpp
    ${SRC_ROOT}/dispatch/eglproc_auto.cpp
    ${SRC_ROOT}/dispatch/eglproc_retrace.cpp
    ${SRC_ROOT}/fastforwarder/fastforwarder.cpp
    ${SRC_ROOT}/retracer/retracer.cpp
    ${SRC_ROOT}/retracer/retrace_api.cpp
    ${SRC_ROOT}/retracer/retrace_gles_auto.cpp
    ${SRC_ROOT}/retracer/retrace_egl.cpp
    ${SRC_ROOT}/retracer/eglconfiginfo.cpp
    ${SRC_ROOT}/retracer/glws.cpp
    ${SRC_ROOT}/retracer/glws_egl.cpp
    ${SRC_ROOT}/retracer/glws_egl_${WINDOWSYSTEM}.cpp
    ${SRC_ROOT}/retracer/state.cpp
    ${SRC_ROOT}/retracer/forceoffscreen/offscrmgr.cpp
    ${SRC_ROOT}/retracer/forceoffscreen/quad.cpp
    ${SRC_ROOT}/retracer/glstate_images.cpp
    ${SRC_ROOT}/retracer/trace_executor.cpp
    ${SRC_ROOT}/retracer/dma_buffer/dma_buffer.cpp
    ${SRC_ROOT}/helper/states.cpp
    ${SRC_ROOT}/helper/paramsize.cpp
    ${SRC_ROOT}/helper/shadermod.cpp
    ${SRC_ROOT}/helper/shaderutility.cpp
    ${SRC_ROOT}/helper/depth_dumper.cpp
    ${SRC_ROOT}/tool/utils.cpp
    ${SRC_ROOT}/tool/parse_interface.cpp
    ${SRC_ROOT}/tool/parse_interface_retracing.cpp
    ${SRC_ROOT}/common/trace_model.cpp
    ${SRC_ROOT}/common/trace_model_utility.cpp
    ${SRC_ROOT}/common/call_parser.cpp
    ${SRC_ROOT}/tool/glsl_utils.cpp
    ${SRC_ROOT}/tool/glsl_parser.cpp
    ${SRC_ROOT}/tool/glsl_lookup.cpp
    ${SRC_ROOT}/specs/pa_func_to_version.cpp
)

set_source_files_properties(
    ${SRC_ROOT}/dispatch/eglproc_auto.hpp
    ${SRC_ROOT}/dispatch/eglproc_auto.cpp
    ${SRC_ROOT}/retracer/retrace_gles_auto.cpp
    ${SRC_ROOT}/specs/pa_func_to_version.cpp
    PROPERTIES
        GENERATED True
)

configure_file(
    "${SRC_ROOT}/retracer/config.hpp.in"
    "${SRC_ROOT}/retracer/config.hpp"
)

configure_file (
    "${COMMON_INCLUDE_DIRS}/tool/config.hpp.in"
    "${COMMON_INCLUDE_DIRS}/tool/config.hpp"
)
