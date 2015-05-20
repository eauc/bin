#!/usr/bin/awk -f
BEGIN {

    PROG_TAG = "@prog@"
    PROGRAM_TAG = "@program@"
    AM_PROGRAM_TAG = "@am_program@"
    MODULE_TAG = "@module@"
    UPPER_MODULE_TAG = toupper(MODULE_TAG)
    SUBMODULE_TAG = "@submodule@"
    TEST_SUBMODULE_TAG = "@test_submodule@"
    MODE_TAG = "@mode@"

    BIN_IF_TAG = "^@bin:"
    BIN_FI_TAG = ":bin@$"
    LIB_IF_TAG = "^@lib:"
    LIB_FI_TAG = ":lib@$"
    SUBMODULE_IF_TAG = "^@submodule:"
    SUBMODULE_FI_TAG = ":submodule@$"
    TEST_SUBMODULE_IF_TAG = "^@test_submodule:"
    TEST_SUBMODULE_FI_TAG = ":test_submodule@$"
    C_MODE_IF_TAG = "^@c-mode:"
    C_MODE_FI_TAG = ":c-mode@$"
    CXX_MODE_IF_TAG = "^@cxx-mode:"
    CXX_MODE_FI_TAG = ":cxx-mode@$"

    SUBMODULE_FOR_TAG = "^@for-submodule:"
    SUBMODULE_ROF_TAG = ":for-submodule@$"
    TEST_SUBMODULE_FOR_TAG = "^@for-test_submodule:"
    TEST_SUBMODULE_ROF_TAG = ":for-test_submodule@"

    BIN_PROGRAM = "^bin$"
    LIB_PROGRAM = "^lib$"

    C_MODE = "^C$"
    CXX_MODE = "^CXX$"

    if(0 == length(MODULE)) {

	print "Please define MODULE name"
	exit 1

    }
    if(0 == length(PROGRAM) ||
       (PROGRAM !~ BIN_PROGRAM &&
	PROGRAM !~ LIB_PROGRAM)) {

	print "Please define PROGRAM type (bin|lib)"
	exit 1

    }

    if(PROGRAM ~ BIN_PROGRAM) {

	PROGRAM_NAME = MODULE

    }
    else if(PROGRAM ~ LIB_PROGRAM) {

	PROGRAM_NAME = "lib" MODULE ".a"

    }
    AM_PROGRAM_NAME = PROGRAM_NAME
    gsub(/[.]/, "_", AM_PROGRAM_NAME)
    UPPER_MODULE = toupper(MODULE)
    NB_SUBMODULE = split(SUBMODULE, SUBMODULE_LIST)
    NB_TEST_SUBMODULE = split(TEST_SUBMODULE, TEST_SUBMODULE_LIST)
}

function for_tag(start_tag, stop_tag, index_tag, index_list, lines, buf) {

    lines = $0
    buff = ""
    while(buff !~ stop_tag) {

    	lines = lines "\n"
    	getline buff
	lines = lines buff

    }

    gsub(start_tag "\n?", "", lines)
    gsub(stop_tag, "", lines)

    gsub(MODULE_TAG, MODULE, lines)
    gsub(UPPER_MODULE_TAG, UPPER_MODULE, lines)

    for(i in index_list) {

    	buff = lines
    	gsub(index_tag, index_list[i], buff)
    	printf(buff)

    }

}

$0 ~ SUBMODULE_FOR_TAG {

    for_tag(SUBMODULE_FOR_TAG, SUBMODULE_ROF_TAG, SUBMODULE_TAG, SUBMODULE_LIST)
    next
}

$0 ~ TEST_SUBMODULE_FOR_TAG {

    for_tag(TEST_SUBMODULE_FOR_TAG, TEST_SUBMODULE_ROF_TAG, TEST_SUBMODULE_TAG, TEST_SUBMODULE_LIST)
    next
}

$0 ~ SUBMODULE_IF_TAG, $0 ~ SUBMODULE_FI_TAG {
    gsub(SUBMODULE_IF_TAG,"")
    gsub(SUBMODULE_FI_TAG,"")
    if(0 == length($0) ||
       0 == NB_SUBMODULE) {

	next

    }
}

$0 ~ TEST_SUBMODULE_IF_TAG, $0 ~ TEST_SUBMODULE_FI_TAG {
    gsub(TEST_SUBMODULE_IF_TAG,"")
    gsub(TEST_SUBMODULE_FI_TAG,"")
    if(0 == length($0) ||
       0 == NB_TEST_SUBMODULE) {

	next

    }
}

$0 ~ C_MODE_IF_TAG, $0 ~ C_MODE_FI_TAG {
    gsub(C_MODE_IF_TAG,"")
    gsub(C_MODE_FI_TAG,"")
    if(0 == length($0) ||
       MODE !~ C_MODE) {

	next

    }
}

$0 ~ CXX_MODE_IF_TAG, $0 ~ CXX_MODE_FI_TAG {
    gsub(CXX_MODE_IF_TAG,"")
    gsub(CXX_MODE_FI_TAG,"")
    if(0 == length($0) ||
       MODE !~ CXX_MODE) {

	next

    }
}

$0 ~ BIN_IF_TAG, $0 ~ BIN_FI_TAG {
    gsub(BIN_IF_TAG,"")
    gsub(BIN_FI_TAG,"")
    if(0 == length($0) ||
       PROGRAM !~ BIN_PROGRAM) {

	next

    }
}

$0 ~ LIB_IF_TAG, $0 ~ LIB_FI_TAG {
    gsub(LIB_IF_TAG,"")
    gsub(LIB_FI_TAG,"")
    if(0 == length($0) ||
       PROGRAM !~ LIB_PROGRAM) {

	next

    }
}

{
    gsub(PROG_TAG, PROGRAM)
    gsub(PROGRAM_TAG, PROGRAM_NAME)
    gsub(AM_PROGRAM_TAG, AM_PROGRAM_NAME)
    gsub(MODULE_TAG, MODULE)
    gsub(UPPER_MODULE_TAG, UPPER_MODULE)
    gsub(SUBMODULE_TAG, SUBMODULE)
    gsub(TEST_SUBMODULE_TAG, TEST_SUBMODULE)
    gsub(MODE_TAG, MODE)
    print
}

END{
}
