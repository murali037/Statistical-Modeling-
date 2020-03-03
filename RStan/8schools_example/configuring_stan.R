
## Configuring stan

remove.packages("rstan")
remove.packages("StanHeaders")
if (file.exists(".RData")) file.remove(".RData")

#Now, restart R
Sys.setenv(MAKEFLAGS = "-j4")
install.packages("rstan", type = "source")


install.packages("StanHeaders")
install.packages("rstan")

install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies = TRUE)
pkgbuild::has_build_tools(debug = TRUE) #rerun C++ tool chain installer after updating R version


#xcode-select --install          #use  in the terminal

## XCode headers not installed since OSX 10.14

#sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /


## Configuration of the C++ Toolchain
dotR <- file.path(Sys.getenv("HOME"), ".R")
if (!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, ifelse(.Platform$OS.type == "windows", "Makevars.win", "Makevars"))
if (!file.exists(M)) file.create(M)
cat("\nCXX14FLAGS=-O3 -march=native -mtune=native",
    if( grepl("^darwin", R.version$os)) "CXX14FLAGS += -arch x86_64 -ftemplate-depth-256" else 
      if (.Platform$OS.type == "windows") "CXX11FLAGS=-O3 -march=corei7 -mtune=corei7" else
        "CXX14FLAGS += -fPIC",
    file = M, sep = "\n", append = TRUE)

##
M <- file.path(Sys.getenv("HOME"), ".R", ifelse(.Platform$OS.type == "windows", "Makevars.win", "Makevars"))
file.edit(M)

# clang: start
# CFLAGS=-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
# CCFLAGS=-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
# CXXFLAGS=-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
# CPPFLAGS=-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include
# 
# SHLIB_CXXLDFLAGS+=-Wl,-rpath,${R_HOME}/lib ${R_HOME}/lib/libc++abi.1.dylib
# SHLIB_CXX14LDFLAGS+=-Wl,-rpath,${R_HOME}/lib ${R_HOME}/lib/libc++abi.1.dylib
# # clang: end
# 
# CXX14FLAGS=-O3 -march=native -mtune=native
# CXX14FLAGS += -arch x86_64 -ftemplate-depth-256


##
install.packages("Rcpp")
install.packages("inline")
install.packages("RcppParallel")

library("Rcpp")
library("inline")
library("RcppParallel")


##
install.packages("devtools")
library(devtools)

