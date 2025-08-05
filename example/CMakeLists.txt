#[[
@copyright © 2025 s3mat3
This code is licensed under the MIT License, see the LICENSE file for details
]]
cmake_minimum_required(VERSION 3.24)
# document version (maybe inherit upper level)
if(NOT DEFINED DOC_CHUNK_VERSION)
  set(DOC_CHUNK_VERSION "0.0.0")
endif()
##
# set DOC_CHUNK_TARGET
#
set(DOC_CHUNK_TARGET "example")
project(document_${DOC_CHUNK_TARGET}
  VERSION ${DOC_CHUNK_VERSION}
  LANGUAGES NONE)
##
# set custom targets name
set(DOC_CHUNK_MKDIR_TARGET ${DOC_CHUNK_TARGET}-mkdir)
set(DOC_CHUNK_TARGET_HTML ${DOC_CHUNK_TARGET}-html)
set(DOC_CHUNK_TARGET_PDF ${DOC_CHUNK_TARGET}-pdf)
set(DOC_CHUNK_TARGET_BOOK5 ${DOC_CHUNK_TARGET}-docbook)
set(DOC_CHUNK_TARGET_WORD ${DOC_CHUNK_TARGET}-word)
set(DOC_CHUNK_TARGET_ODT ${DOC_CHUNK_TARGET}-odt)
set(DOC_CHUNK_TARGET_ALL ${DOC_CHUNK_TARGET}-all)
set(DOC_CHUNK_TARGET_CHECK ${DOC_CHUNK_TARGET}-check)
##
# document name
set(DOC_CHUNK_NAME_BASE "EXAMPLE")
set(DOC_CHUNK_NAME ${DOC_CHUNK_NAME_BASE}-${DOC_CHUNK_VERSION})
#################################
# document name and description #
# !!!!!!!!!!!!!!!!!!!!!         #
# !!!! MUST CHANGE !!!!         #
# !!!!!!!!!!!!!!!!!!!!!         #
#################################
##
# Titel of the document
set(DOC_CHUNK_TITLE "EXAMPLE開発")
set(DOC_CHUNK_SUB_TITLE "仕様書")
##
# document description
set(DOC_CHUNK_DESCRIPTION "EXAMPLE開発仕様書のつもりのtemplate")
##
# AUTHOR
if(NOT DEFINED DOC_CHUNK_AUTHOR)
  set(DOC_CHUNK_AUTHOR "私の名前は著作者")
endif()
#########################
# document style        #
# !!!!!!!!!!!!!!!!!!!!! #
# !!!! MUST CHANGE !!!! #
# !!!!!!!!!!!!!!!!!!!!! #
#########################
##
# document type for PDF. This property select only "article" or "book"
set(DOC_CHUNK_TYPE "book")
##
# PDF document themesheet name
set(DOC_CHUNK_PDF_THEME_NAME "default-theme.yml")
##
# HTML document style sheet name
set(DOC_CHUNK_HTML_THEME_NAME "base-style-theme.css")
##
# LOGO image name
set(DOC_CHUNK_LOGO_IMG_NAME "sample-logo.svg")
##
# title page for PDF converter image name
set(DOC_CHUNK_TITLE_IMG_NAME "sample-cover.svg")
########
# misc #
########
##
# toc levels
set(DOC_CHUNK_TOC_LEVELS "3")
###################################################
# Directories on global scope of the Main PROJECT #
###################################################
##
# build base directory
if(NOT (DEFINED ${BUILD_DOC_BUILD_DIR}))
  set(BUILD_DOC_BUILD_DIR ${PROJECT_BINARY_DIR})
endif()
##
# outputdir
if(NOT (DEFINED BUILD_DOC_OUT_DIR))
  set(BUILD_DOC_OUT_DIR ${BUILD_DOC_BUILD_DIR}/output)
endif()
###############
# Directories #
###############
##
# document base directory
set(DOC_CHUNK_ROOT ${PROJECT_SOURCE_DIR})
set(DOC_CHUNK_BASE ${BUILD_DOC_BASE})

##
# document output directory
if (NOT (DEFINED BUILD_DOC_OUTPUT_BASE))
   set(BUILD_DOC_OUTPUT_BASE ${PROJECT_BINARY_DIR}/doc)
endif()

set(DOC_CHUNK_OUT_DIR ${BUILD_DOC_OUTPUT_BASE}/${DOC_CHUNK_TARGET})
message(${DOC_CHUNK_OUT_DIR})
##
# document source directory
set(DOC_CHUNK_SRC_DIR ${DOC_CHUNK_ROOT}/sections)
##
# document image directory
set(DOC_CHUNK_IMAGE_DIR "${DOC_CHUNK_ROOT}/images")
##
# document image directory
set(DOC_CHUNK_UML_DIR "${DOC_CHUNK_ROOT}/uml")
##
# document theme directory
set(DOC_CHUNK_TITLE_PAGE_DIR "${BUILD_DOC_THEME_DIR}/title-page")
##
# document logo directory
set(DOC_CHUNK_LOGO_DIR ${BUILD_DOC_THEME_IMAGES_DIR})
##
# document fonts directory for PDF
set(DOC_CHUNK_PDF_FONTS_DIR "/usr/local/share/fonts")
#
# genarate main.adoc
#
configure_file(
  "${DOC_CHUNK_ROOT}/main.adoc.in"
  "${DOC_CHUNK_SRC_DIR}/main.adoc"
  @ONLY)

set(DOC_CHUNK_PAGE_DIR ${DOC_CHUNK_ROOT}/sections)
#
add_custom_target(${DOC_CHUNK_MKDIR_TARGET}
  COMMAND if [ ! -d ${DOC_CHUNK_OUT_DIR} ] \; then mkdir -p ${DOC_CHUNK_OUT_DIR} \; fi
)
##
# create html document
add_custom_target(${DOC_CHUNK_TARGET_HTML}
  COMMAND asciidoctor
  -r asciidoctor-diagram
  -r asciidoctor-mathematical
  -b html5
  -o ${DOC_CHUNK_OUT_DIR}/${DOC_CHUNK_TARGET}.html
  ${DOC_CHUNK_SRC_DIR}/main.adoc
  DEPENDS ${DOC_CHUNK_MKDIR_TARGET}
  COMMENT "Building HTML documentation with asciidoctor")
##
# create pdf document
add_custom_target(${DOC_CHUNK_TARGET_PDF}
  COMMAND asciidoctor-pdf
  -r asciidoctor-diagram
  -r asciidoctor-mathematical
  -r ${BUILD_DOC_SCRIPTS_DIR}/config.rb
  -a scripts=cjk
  -o ${DOC_CHUNK_OUT_DIR}/${DOC_CHUNK_TARGET}.pdf
  ${DOC_CHUNK_SRC_DIR}/main.adoc
  DEPENDS ${DOC_CHUNK_MKDIR_TARGET}
  COMMENT "Building PDF documentation with asciidoctor")
##
# create docbook5
add_custom_target(${DOC_CHUNK_TARGET_BOOK5}
  DEPENDS ${DOC_CHUNK_MKDIR_TARGET}
  COMMAND asciidoctor
  -r asciidoctor-diagram
  -r asciidoctor-mathematical
  -b docbook
  -o ${DOC_CHUNK_OUT_DIR}/${DOC_CHUNK_TARGET}.xml
  ${DOC_CHUNK_SRC_DIR}/main.adoc
  COMMENT "Convert asciidoc to docbook"
)
##
# create word .docx from docbook5
add_custom_target(${DOC_CHUNK_TARGET_ODT}
  DEPENDS ${DOC_CHUNK_TARGET_BOOK5}
  COMMAND pandoc
  --reference-doc=${BUILD_DOC_THEME_ODT_DIR}/reference.odt
  --from=docbook
  --to=odt
  --output=${DOC_CHUNK_OUT_DIR}/${DOC_CHUNK_TARGET}.odt
  ${DOC_CHUNK_OUT_DIR}/${DOC_CHUNK_TARGET}.xml
  COMMENT "Convert docbook to open documet")
##
# create word .docx from docbook5
add_custom_target(${DOC_CHUNK_TARGET_WORD}
  DEPENDS ${DOC_CHUNK_TARGET_BOOK5}
  COMMAND pandoc
  --reference-doc=${BUILD_DOC_THEME_WORD_DIR}/reference.docx
  --from=docbook
  --to=docx
  --output=${DOC_CHUNK_OUT_DIR}/${DOC_CHUNK_TARGET}.docx
  ${DOC_CHUNK_OUT_DIR}/${DOC_CHUNK_TARGET}.xml
  # COMMAND mv ${DOC_CHUNK_SRC_DIR}/${DOC_CHUNK_TARGET}.xml ${DOC_CHUNK_OUT_DIR}
  # COMMAND mv ${DOC_CHUNK_SRC_DIR}/${DOC_CHUNK_TARGET}.docx ${DOC_CHUNK_OUT_DIR}
  # WORKING_DIRECTORY ${DOC_CHUNK_SRC_DIR}
  COMMENT "Convert docbook to word docx")
##
# create all formats
add_custom_target(${DOC_CHUNK_TARGET_ALL}
  DEPENDS ${DOC_CHUNK_TARGET_HTML} ${DOC_CHUNK_TARGET_PDF} ${DOC_CHUNK_TARGET_ODT} ${DOC_CHUNK_TARGET_WORD}
)
##
# lint
add_custom_target(${DOC_CHUNK_TARGET_CHECK}
  COMMAND npx textlint
  -f unix
  # --no-color
  ${DOC_CHUNK_SRC_DIR}/*.adoc
  # -o ${DOC_CHUNK_OUT_DIR}/error.result
  COMMENT "Linting source documents")
