-- Logging API
-- Created by Doctor Internet / jonjon1234
-- Dated: 1/8/14
-- Version: 1.00.0000
-- Description: The Logging API is a API that attempts to make it easier to integrate a logging system
-- into computercraft programs. The API is based on the Python Logging Library, since I have experience
-- using that API.
-- Contact: Computercraft Forums - jonjon1234. Computercraft Wiki - jonjon1234 (if my account is still active)

--[ API Variables ]--
local rotateSizeBytes
rotateSizeBytes = 1500

-- Localisation Variables
localisation = {normal = {
					screen = "displayOnScreen", 
					printer = "printHardCopy",
					file = {
						static = {flushed = "outputFileStaticFlushed", append = "outputFileStaticAppend"},
						restart = "outputFileRotateOnRestart",
						size = "outputFileRotateSize",
						manual = "outputFileRotateManual"}
					},
				friendly = {
					screen = "Display Logs on Terminal Screen",
					printer = "Print Logs to a Printer",
					file = {
						static = {flushed = "Output Logs to a Static File - File Flushed Upon Restarting Logging", append = "Output Logs to a Static File - File Appended Upon Restarting Logging"},
						restart = "Output Logs to a File - File Number Suffix Increases Every Restart",
						size = "Output Logs to a File - File Number Suffix Increases When File Size Passes "..tostring(rotateSizeBytes).." bytes.",
						manual = "Output Logs to a File - File Number Suffix Increases Upon Function Call."
						}
					}
				}

constant = {
			seperator = "--------------------------------------------------"
			}

-- API Use Variables
logData = {
			loggingActive = false,
			printToScreen = false,
			printToPaper = false,
			printToFile = false,
			printToFileType = 4,
			configLocation = "logging/data/loggingConfig",
			logLocation = "logging/logs/log",
			idLocation = "logging/data/idFile"
			}

local logTypeData = {
					{id = 1,
					title = localisation.normal.screen,
					friendlyName = localisation.friendly.screen},
					
					{id = 2,
					title = localisation.normal.printer,
					friendlyName = localisation.friendly.printer,
					printerSide = "top"},
					
					{id = 4,  
					title = localisation.normal.file.static.flushed, 
					friendlyName = localisation.friendly.file.static.flushed, 
					fileLoc = logData.logLocation},
					
					{id = 8,  
					title = localisation.normal.file.static.append,  
					friendlyName = localisation.friendly.file.static.append,  
					fileLoc = logData.logLocation},
					
					{id = 16, 
					title = localisation.normal.file.restart,        
					friendlyName = localisation.friendly.file.restart,        
					fileLoc = logData.logLocation,  
					idLoc = logData.idLocation},
					
					{id = 32, 
					title = localisation.normal.file.size,           
					friendlyName = localisation.friendly.file.size,
					fileLoc = logData.logLocation,  
					idLoc = logData.idLocation, 
					rotateSizeBytes = 1500},
					
					{id = 64, 
					title = localisation.normal.file.manual,         
					friendlyName = localisation.friendly.file.manual,
					fileLoc = logData.logLocation,  
					idLoc = logData.idLocation}}
					
local typeIDs = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16, 17, 18, 19, 32, 33, 34, 35, 64, 65, 66, 67}
local typeIDRef = {[1] = 1, [2] = 2, [4] = 3, [8] = 5, [16] = 6, [32] = 7, [64] = 8}
local compoundID = {5, 6, 7, 9, 10, 11, 17, 18, 19, 33, 34, 35, 65, 66, 67}
local fileIDs = {4, 8, 16, 32, 64}
local rotateFileIDs = {16, 32, 64}
rotateSizeBytes = logTypeData[5]["rotateSizeBytes"]

--[ API Utility Functions - SHOULD NOT BE CALLED DIRECTLY ]--
function checkTableMembership(tbl, chk)
  for _, val in pairs(tbl) do
    if val == chk then
	  return true
	end
  end
  return false
end

function twoTonePrint(col, str, colTwo, strTwo)
  if not colors and not colours then
    error("Two Colour Printing Error - Colour API Not Available")
  elseif not term.isColor() then
	error("Two Colour Printing Error - Terminal Reported As Non Color")
  else
    term.setTextColor(col)
	term.write(str)
	term.setTextColor(colTwo)
	print(strTwo)
	term.setTextColor(colors.white)
  end
end

--[ API Functions ]--
function getLogTypes()
  local x
  local printID
  local printName
  x = #logTypeData
  print(tostring(x))
  for i = 1, x do
	printID = "ID "..logTypeData[i]["id"]..": "
	printName = logTypeData[i]["friendlyName"].."\n"
	twoTonePrint(colors.yellow, printID, colors.lightGray, printName)
	end
  print("Note that a printer / monitor printing may be used as well as a file based log system.")
  print("However, only one file based log may be used at once.")
end

function setActiveStatus(bool)
  if type(bool) ~= boolean then
    error("API Activation Call Error: Input Not Boolean")
  else
    loggingActive = bool
  end
end

function getActiveStatus()
  return logdata.loggingActive
end

function isLoggingType(logtype)
  local name
  local nameTwo
  local nameThree
  local searchID
  searchID = logtype
  if not checkTableMembership(typeIDs, logtype) then
    return false
  elseif searchID == 3 then
    name = tostring(localisation.normal.screen)
	nameTwo = tostring(localisation.normal.printer)
    return true, name, nameTwo
  elseif not checkTableMembership(compoundID, logtype) then
	searchID = typeIDRef[logtype]
	name = tostring(logTypeData[searchID].title)
    return true, name
  else
    searchID = logtype - 1
	if not checkTableMembership(compoundID, searchID) then
	  searchID = typeIDRef[logtype-1]
	  name = tostring(logTypeData[searchID].title)
	  nameTwo = tostring(localisation.normal.screen)
	  return true, name, nameTwo
	else
	  searchID = logtype - 2
	  if not checkTableMembership(compoundID, searchID) then
	    searchID = typeIDRef[logtype-2]
	    name = tostring(logTypeData[searchID].title)
		nameTwo = tostring(localisation.normal.printer)
		return true, name, nameTwo
	  else
	    searchID = logtype - 3
		if not checkTableMembership(compoundID, searchID) then
		  searchID = typeIDRef[logtype-3]
		  name = tostring(logTypeData[searchID].title)
		  nameTwo = tostring(localisation.normal.screen)
		  nameThree = tostring(localisation.normal.printer)
		  return true, name, nameTwo, nameThree
		else
		  return false
		end
	  end
    end
  end
end

function loadConfig(location)
  local location
  local option
  local data
  local path
  if not location then
	location = logData.configLocation
  else
    logData.configLocation = location
  end
  if not fs.exists(logData.configLocation) then
	path = fs.getDir(logData.configLocation)
	fs.makeDir(path)
    fileCfg = fs.open(logData.configLocation, "w")
	fileCfg.writeLine("CfgLocation = "..logData.configLocation)
	fileCfg.writeLine("LogLocation = "..logData.logLocation)
	fileCfg.writeLine("IDLocation = "..logData.idLocation)
	fileCfg.close()
  end
  fileCfg = fs.open(logData.configLocation, "r")
  data = fileCfg.readAll()
  fileCfg.close()
  option = {}
  for k, v in string.gmatch(data, "(%w+) = (%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*%w*/*)") do
    option[k] = v
  end
  logData.configLocation = option["CfgLocation"]
  logData.logLocation = option["logLocation"]
  logData.IDLocation = option["idLocation"]
end

function startLog(logtype)
	local lastID
	local newId
	local oldLog
	local newLog
	local size
	local searchID
	if type(logtype) ~= integer and type(logtype) ~= number then
		error("Log Starting Error - Attempted To Use Non Numerical Log Type")
		return
	elseif not checkTableMembership(typeIDs, logtype) then
		error("Log Starting Error - Log Type Not Recognised")
		return
	elseif logtype == 1 then
		logData.printToScreen = true
	elseif logtype == 2 then
		logData.printToPaper = true
	elseif logtype == 3 then
		logData.printToScreen = true
		logData.printToPaper = true
	elseif checkTableMembership(compoundID, logtype) then
		searchID = logtype
		if not checkTableMembership(compoundID, searchID-1) then
			logData.printToScreen = true
			logtype = logtype-1
		elseif not checkTableMembership(compoundID, searchID-2) then
			logData.printToPaper = true
			logtype = logtype - 2
		elseif not checkTableMembership(compoundID, searchID-3) then
			logData.printToScreen = true
			logData.printToPaper = true
			logtype = logtype - 3
		end
		elseif checkTableMembership(fileIDs, logtype) then
		logData.printToFile = true
		logData.printToFileType = logtype
		if logData.printToFileType == 4 then
			logFile = fs.open(logData.logLocation, "w")
		elseif logData.printToFileType == 8 then
		logFile = fs.open(logData.logLocation, "a")
		logFile.writeLine(constant.seperator)
		logFile.writeLine("Starting New Log File")
		elseif checkTableMembership(rotateFileIDs, logData.printToFileType) then
			if not fs.exists(logData.idLocation) then
				idFile = fs.open(logData.idLocation, "w")
				idFile.write("0")
				idFile.close()
			else
				if logData.printToFileType == 16 then
					idFile = fs.open(logData.idLocation, "r")
					lastID = idFile.readAll()
					idFile.close()
					newID = tonumber(lastID) + 1
					idFile = fs.open(logData.idLocation, "w")
					idFile.write(tostring(newID))
					idFile.close()
					oldLog = logData.logLocation
					newLog = oldLog..lastID
				elseif logData.printToFileType == 32 then
					idFile = fs.open(logData.idLocation, "r")
					lastID = idFile.readAll()
					idFile.close()
					newID = tonumber(lastID) - 1
					oldLog = logData.logLocation..lastID
					size = fs.getSize(oldLog)
					if size > logTypeData[typeIDref[32]]["rotateSizeBytes"] then
						logData.logLocation = logData.logLocation..lastID
					else
						logData.logLocation = logData.logLocation..newID
					end
					if fs.exists(logData.logLocation) then
						logFile = fs.open(logData.logLocation, "a")
						logFile.writeLine(constant.seperator)
						logFile.writeLine("Starting New Log File")
					else
						logFile = fs.open(logData.logLocation, "w")
					end
				elseif logData.printToFileType == 64 then
					idFile = fs.open(logData.idLocation, "r")
					lastID = idFile.readAll()
					idFile.close()
					newID = tonumber(lastID) - 1
					idFile = fs.open(logData.idLocation, "w")
					idFile.write(tostring(newID))
					idFile.close()
					oldLog = logData.logLocation
					newLog = oldLog..lastID
					logFile = fs.open(newLog, "a")
					logFile.writeLine(constant.seperator)
					logFile.writeLine("Starting New Log File")
				end
			end
		end
	end
end




	