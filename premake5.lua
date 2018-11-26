workspace "euler-test"
  configurations { "dbg", "dist" }

  language "C"

  flags { "fatalwarnings", "linktimeoptimization" }

  buildoptions {
    "-xc", "-std=c11", "-Wmissing-parameter-type",
    "-Wmissing-prototypes",
    "-Wnested-externs", "-Wold-style-declaration",
    "-Wold-style-definition", "-Wstrict-prototypes", "-Wpointer-sign"
  }
  filter { "action:gmake*", "toolset:gcc"}
    buildoptions {
      "-Wall", "-Wextra", "-Wfloat-equal", "-Winline", "-Wundef", "-Werror",
      "-fverbose-asm", "-Wint-to-pointer-cast", "-Wshadow", "-Wpointer-arith",
      "-Wcast-align", "-Wcast-qual", "-Wunreachable-code", "-Wstrict-overflow=5",
      "-Wwrite-strings", "-Wconversion", "--pedantic-errors",
      "-Wredundant-decls", "-Werror=maybe-uninitialized",
      "-Wmissing-declarations",
    }

  filter "configurations:dbg"
    optimize "off"
    symbols "on"
    buildoptions { "-ggdb3", "-O0", "-DDEBUG" }

  filter "configurations:dist"
    optimize "full"
    symbols "off"

  project "e3"
    kind "consoleapp"

    files { "e3main.c", "e3.h" }
    links { "m" }

    targetdir "bin/%{cfg.buildcfg}/"

    filter "configurations:dist"
      buildoptions { "-O3", "-fomit-frame-pointer" }

  project "e3test"
    kind "consoleapp"

    files { "test_e3.c", "e3.h" }

    links { "criterion", "m" }

    targetdir "bin/%{cfg.buildcfg}/"

    filter "configurations:dist"
      buildoptions { "-O3", "-fomit-frame-pointer" }

  project "clobber"
    kind "makefile"

    local dirs = " bin obj "

    -- on windows, clean like this
    filter "system:not windows"
      cleancommands {
        "({RMDIR}" .. dirs .."*.make Makefile *.o -r 2>/dev/null; echo)"
      }

    -- otherwise, clean like this
    filter "system:windows"
      cleancommands {
        "{DELETE} *.make Makefile *.o",
        "{RMDIR}" .. dirs
      }
