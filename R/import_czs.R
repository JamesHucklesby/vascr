# install.packages("XML")
# 
# 
# 
# library(XML)
# 
# xmlfile <- xmlParse("excluded/demo.cZsx")
# class(xmlfile)
# 
# xmltop = xmlRoot(xmlfile) #gives content of root
# class(xmltop)#"XMLInternalElementNode" "XMLInternalNode" "XMLAbstractNode"
# xmlName(xmltop) #give name of node, PubmedArticleSet
# xmlSize(xmltop) #how many children in node, 19
# xmlName(xmltop[[1]]) #name of root's children
# 
# xmlName(xmltop[[1]])
# xmlName(xmltop[[2]])
# xmlName(xmltop[[3]])
# xmlName(xmltop[[4]])
# xmlName(xmltop[[5]])
# xmlName(xmltop[[6]])
# xmlName(xmltop[[7]])
# xmlName(xmltop[[8]])
# xmlName(xmltop[[9]])
# 
# xmlName(data[["Results"]])
# 
# data = xmltop[[9]]
# xmlName(data[[2]])
# xmlName(data[[3]])
# xmlName(data[[4]])
# xmlName(data[[5]])
# 
# 
# biglist = xmlToDataFrame(spectra)
# 
# 
# # Extract the raw spectrum data
# spectra = xmltop[["AllSpectra"]]
# 
# 
# #For the first well, find out how many time points there are
# 
# numwells = xmlSize(spectra)
# numtimes = xmlSize(spectra[[1]])
# 
# wellarray = c(1:numwells)
# timearray = c(1:numtimes)
# 
# datachunk = grabdatafromxml(1,1)
# datachunk <- datachunk[0,]
# 
# for(well in wellarray)
# {
#   for (time in timearray)
#   {
#     
#     datachunk = rbind(datachunk, grabdatafromxml(well, time))
# 
#   }
# }
# 
# datachunk$Sample = "Yes"
# datachunk$Experiment = "One"
# 
# datachunk$Time = ymd_hms(datachunk$Time)
# datachunk$Time = as.POSIXct(datachunk$Time)
# datachunk$Time = as.numeric(datachunk$Time)
# datachunk$Time = (datachunk$Time - min(datachunk$Time))/60
# 
# unique(datachunk$Time)
# 
# minidata = subset(datachunk, Time<10000)
# minidata = subset(minidata, Unit == "TER.text")
# 
# plot(minidata$Time, minidata$Value)
# 
# 
# 
# grabdatafromxml = function(well, time)
# {
# 
# wellatt = xmlAttrs(spectra[[well]][[timepoint]])
# wellid = wellatt["WellID"]
# runid = wellatt["RunID"]
# time = wellatt["CreatedAt"]
# 
# # # ignore this as I think it's fitted data
# # 
# # # First we grab out the raw spectral data
# # currentwelldata = spectra[[well]][[timepoint]][[1]]
# # raw <- xmlSApply(currentwelldata,function(x) xmlSApply(x, xmlValue))
# # raw = t(raw)
# # raw = as.data.frame(raw)
# # 
# # names(raw)[names(raw) == "F"] <- "Frequency"
# # names(raw)[names(raw) == "P"] <- "P"
# # names(raw)[names(raw) == "A"] <- "X"
# # 
# # raw$Well = wellid
# # raw$RunID = runid
# # raw$Time = time
# 
# 
# # Then we isolate the modeled data
# currentwelldata = spectra[[timepoint]][[well]][[2]]
# model <- xmlSApply(currentwelldata,function(x) xmlSApply(x, xmlValue))
# model = as.data.frame(model)
# 
# model$Unit = row.names(model)
# model$Well = wellid
# model$RunID = runid
# model$Time = time
# names(model)[names(model) == "model"] <- "Value"
# model$Frequency = 0
# 
# return(model)
# 
# }
# 
# 
# ##########################################################################
# ## Attempt 2                       #######################################
# ##########################################################################
# 
# install.packages("xml2")
# library("xml2")
# 
# xmldoc = xmlParse("excluded/demo.cZsx")
# 
# dump = xmlToList(xmldoc)
# 
# rootNode <- xmlRoot(xmldoc)
# 
# miniroot = rootNode[[8]][[1]]
# 
# xmlName(miniroot)
# data <- xmlSApply(miniroot,function(x) xmlSApply(x, xmlValue))
# 
# cd.catalog <- as.data.frame(data)
# 
# 
# print(xml)
# 
# xmlToDataFrame("xml")
# 
