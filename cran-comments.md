## Version V 0.1.5
In this version I have:
* Updated the code of the vascr_import_instrument data so it passes on the Github MacM1 checks.

## Version V 0.1.5
In this version I have:
* Updated the description to remove the duplicate reference to testthat which was cuaing notes in the macos check
* Removed some example import files to reduce the macos installed size below 5mb

The current build has been tested against macos, windows and linux, current, old and devel using the GitHub builders.

## Resubmission V 0.1.4
This is a re submission. In this version I have:

* Removed the references to print in vascr_combine

* Removed references to the global environment in vascr_save

## Resubmission 0.1.3
This is a re submission. In this version I have:

* Updated the description to put the specialist pieces of equipment ECIS, xCELLigence and cellZscope in quotes

## Resubmission 0.1.2
This is a re submission. In this version I have:

* Proofread the DESCRIPTION, thank you for catching this error

* Reduced the number of spaces in the description, somehow indents as spaces became baked into the previous version

* Missing return tags incorporated to functions re-exported from other packages

* Examples removed from vascr_find_level RD file

* Commented out examples made active or removed

* Dontrun replaced with donttest

* Shiny packages wrapped in if(interactive())

* Fixed checks failing in 80 01 2026 build


## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

