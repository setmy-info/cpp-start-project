# PLACEHOLDER-BEGIN #
MESSAGE("-- javah targets.cmake")

ADD_CUSTOM_TARGET(javah echo javac -h ${MAIN_INCLUDES_PATH} ${MAIN_JAVA_SOURCES_PATH}/info/setmy/jni/example/Example.java && rm -rf ${MAIN_JAVA_SOURCES_PATH}/info/setmy/jni/example/*.class)

# PLACEHOLDER-END #