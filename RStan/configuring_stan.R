
## Configuring stan

#remove.packages("rstan")
#remove.packages("StanHeaders")

## Step 1
remove.packages(c("rstan","StanHeaders"))
if (file.exists(".RData")) file.remove(".RData")

## Step 2
#Now, restart R
Sys.setenv(MAKEFLAGS = "-j4")


## Step 3
cat("SHLIB_CXX14LD = /usr/local/clang7/bin/clang++ -L/usr/local/clang7/lib/",
    file = "~/.R/Makevars", sep = "\n", append = TRUE)
install.packages(c("StanHeaders", "rstan"), type = "source")

## Step 4
#rerun C++ tool chain installer after updating R version

#install.packages("StanHeaders")
#install.packages("rstan")
#install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies = TRUE)


## Step 5
pkgbuild::has_build_tools(debug = TRUE) #rerun C++ tool chain installer after updating R version


#xcode-select --install          #use  in the terminal

## XCode headers not installed since OSX 10.14

#sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

## step 6
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


##############################################################################################################

# HPC setting


You can use 
#SBATCH --nodes=2 to request 2 nodes - for a single node, multiprocessor job this should not be needed, 
                            #instead tasks and cpus can be requested like so:
#SBATCH --ntasks=1 # Run a single task
#SBATCH --cpus-per-task=8 # Number of CPU cores per task

Links on HPC parallel run,

1. https://hpcc.usc.edu/support/documentation/r/parallel/
  
2. https://stackoverflow.com/questions/51139711/hpc-cluster-select-the-number-of-cpus-and-threads-in-slurm-sbatch




