<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE MudletPackage>
<MudletPackage version="1.001">
	<TriggerPackage>
		<TriggerGroup isActive="yes" isFolder="yes" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="no" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
			<name>casraf</name>
			<script></script>
			<triggerType>0</triggerType>
			<conditonLineDelta>0</conditonLineDelta>
			<mStayOpen>0</mStayOpen>
			<mCommand></mCommand>
			<packageName></packageName>
			<mFgColor>#ff0000</mFgColor>
			<mBgColor>#ffff00</mBgColor>
			<mSoundFile></mSoundFile>
			<colorTriggerFgColor>#000000</colorTriggerFgColor>
			<colorTriggerBgColor>#000000</colorTriggerBgColor>
			<regexCodeList />
			<regexCodePropertyList />
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>Failed spells</name>
				<script></script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand></mCommand>
				<packageName></packageName>
				<mFgColor>#804002</mFgColor>
				<mBgColor>#ffffff</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>You lost your concentration while trying to cast (.+)</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>0</integer>
				</regexCodePropertyList>
			</Trigger>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>Stay invis</name>
				<script>if not tmpVis then
  send("c invis")
end
tmpVis = false</script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand></mCommand>
				<packageName></packageName>
				<mFgColor>#fd8008</mFgColor>
				<mBgColor>#252525</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>You are no longer invisible</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>0</integer>
				</regexCodePropertyList>
			</Trigger>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>Campaign mob done - Check Campaign</name>
				<script></script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand>cp ch</mCommand>
				<packageName></packageName>
				<mFgColor>#ff0000</mFgColor>
				<mBgColor>#ffff00</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>Congratulations, that was one of your CAMPAIGN mobs!</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>0</integer>
				</regexCodePropertyList>
			</Trigger>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>Global Quest mob done - Check Global Quest</name>
				<script></script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand>gq ch</mCommand>
				<packageName></packageName>
				<mFgColor>#ff0000</mFgColor>
				<mBgColor>#ffff00</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>Congratulations, that was one of the GLOBAL QUEST mobs!</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>0</integer>
				</regexCodePropertyList>
			</Trigger>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>Task done - Check Tasks</name>
				<script>send("tasks here")</script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand></mCommand>
				<packageName></packageName>
				<mFgColor>#ff0000</mFgColor>
				<mBgColor>#ffff00</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>** Task Done  : </string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>0</integer>
				</regexCodePropertyList>
			</Trigger>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>HL only</name>
				<script>-- send("crc; q comp")</script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand></mCommand>
				<packageName></packageName>
				<mFgColor>#ff0000</mFgColor>
				<mBgColor>#ffff00</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>QUEST: You have almost completed your QUEST!</string>
					<string>You seem unable to hunt that target for some reason.</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>0</integer>
					<integer>0</integer>
				</regexCodePropertyList>
			</Trigger>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>Underwater breathing</name>
				<script></script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand>ca underwater</mCommand>
				<packageName></packageName>
				<mFgColor>#fd8008</mFgColor>
				<mBgColor>#333333</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>You cough and splutter as the water invades your lungs!</string>
					<string>You are no longer able to breathe underwater.</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>0</integer>
					<integer>0</integer>
				</regexCodePropertyList>
			</Trigger>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>True seeing</name>
				<script>send("c true")</script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand></mCommand>
				<packageName></packageName>
				<mFgColor>#ff0000</mFgColor>
				<mBgColor>#ffff00</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>You feel almost blind at the loss of your magical sight</string>
					<string>You lost your concentration while trying to cast true seeing.</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>0</integer>
					<integer>0</integer>
				</regexCodePropertyList>
			</Trigger>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="yes" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>disarmed</name>
				<script>send("get "..aard.config["wield"]..";wield "..aard.config["wield"])</script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand></mCommand>
				<packageName></packageName>
				<mFgColor>#fc0067</mFgColor>
				<mBgColor>#fff5fa</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>^.* DISARMS you and sends your .* flying\!$</string>
					<string>^.* DISARMS you and you struggle not to drop your weapon!</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>1</integer>
					<integer>1</integer>
				</regexCodePropertyList>
			</Trigger>
			<TriggerGroup isActive="yes" isFolder="yes" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="no" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>Catch targets</name>
				<script></script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand></mCommand>
				<packageName></packageName>
				<mFgColor>#ff0000</mFgColor>
				<mBgColor>#ffff00</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList />
				<regexCodePropertyList />
				<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="no" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
					<name>CP none</name>
					<script>should_reset_cp_targets = true
cp_targets = {}</script>
					<triggerType>0</triggerType>
					<conditonLineDelta>0</conditonLineDelta>
					<mStayOpen>0</mStayOpen>
					<mCommand></mCommand>
					<packageName></packageName>
					<mFgColor>#ff0000</mFgColor>
					<mBgColor>#ffff00</mBgColor>
					<mSoundFile></mSoundFile>
					<colorTriggerFgColor>#000000</colorTriggerFgColor>
					<colorTriggerBgColor>#000000</colorTriggerBgColor>
					<regexCodeList>
						<string>You are not currently on a campaign.</string>
					</regexCodeList>
					<regexCodePropertyList>
						<integer>3</integer>
					</regexCodePropertyList>
				</Trigger>
				<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="no" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
					<name>Catch target mob campaign</name>
					<script>if should_reset_cp_targets then
  cp_targets = {}
  should_reset_cp_targets = false
  -- echo("\nResetting cp targets")
end

cp_targets = cp_targets or {}

local mob = matches[3]
local area = matches[4]

table.insert(cp_targets, { ["mob"] = mob, ["area"] = area })

-- echo("\nCaptured " .. mob .. " in " .. area .. " =&gt; " .. matches[1])</script>
					<triggerType>0</triggerType>
					<conditonLineDelta>0</conditonLineDelta>
					<mStayOpen>0</mStayOpen>
					<mCommand></mCommand>
					<packageName></packageName>
					<mFgColor>#ff0000</mFgColor>
					<mBgColor>#ffff00</mBgColor>
					<mSoundFile></mSoundFile>
					<colorTriggerFgColor>#000000</colorTriggerFgColor>
					<colorTriggerBgColor>#000000</colorTriggerBgColor>
					<regexCodeList>
						<string>[*] (a |an |the |some )?([\w\d \-',.]+) \(([a-zA-Z0-9 -']+)\)$</string>
					</regexCodeList>
					<regexCodePropertyList>
						<integer>1</integer>
					</regexCodePropertyList>
				</Trigger>
				<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="no" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
					<name>Catch target mob campaign END</name>
					<script>should_reset_cp_targets = true
echo("\nCaptured " .. #cp_targets .. " target(s)")</script>
					<triggerType>0</triggerType>
					<conditonLineDelta>0</conditonLineDelta>
					<mStayOpen>0</mStayOpen>
					<mCommand></mCommand>
					<packageName></packageName>
					<mFgColor>#ff0000</mFgColor>
					<mBgColor>#ffff00</mBgColor>
					<mSoundFile></mSoundFile>
					<colorTriggerFgColor>#000000</colorTriggerFgColor>
					<colorTriggerBgColor>#000000</colorTriggerBgColor>
					<regexCodeList>
						<string>You may take a campaign at this level.</string>
						<string>You will have to level before you can go on another campaign.</string>
						<string>Use 'cp check' to see only targets that you still need to kill.</string>
					</regexCodeList>
					<regexCodePropertyList>
						<integer>3</integer>
						<integer>3</integer>
						<integer>3</integer>
					</regexCodePropertyList>
				</Trigger>
				<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="no" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
					<name>Catch target mob GQ</name>
					<script>if should_reset_gq_targets then
  gq_targets = {}
  should_reset_gq_targets = false
  -- echo("\nResetting gq targets")
end

gq_targets = gq_targets or {}

local amount = matches[2]
local mob = matches[4]
local area = matches[5]

table.insert(gq_targets, { ["mob"] = mob, ["area"] = area })

-- echo("\nCaptured " .. mob .. " in " .. area .. " =&gt; " .. matches[1])</script>
					<triggerType>0</triggerType>
					<conditonLineDelta>0</conditonLineDelta>
					<mStayOpen>0</mStayOpen>
					<mCommand></mCommand>
					<packageName></packageName>
					<mFgColor>#ff0000</mFgColor>
					<mBgColor>#ffff00</mBgColor>
					<mSoundFile></mSoundFile>
					<colorTriggerFgColor>#000000</colorTriggerFgColor>
					<colorTriggerBgColor>#000000</colorTriggerBgColor>
					<regexCodeList>
						<string>You still have to kill ([\d]+) [*] (a |an |the |some )?([\w\d \-',.]+) \(([a-zA-Z0-9 -']+)\)$</string>
					</regexCodeList>
					<regexCodePropertyList>
						<integer>1</integer>
					</regexCodePropertyList>
				</Trigger>
				<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="no" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
					<name>Catch target mob GQ END</name>
					<script>should_reset_gq_targets = true
echo("\nCaptured " .. #gq_targets .. " GQ target(s)")</script>
					<triggerType>0</triggerType>
					<conditonLineDelta>0</conditonLineDelta>
					<mStayOpen>0</mStayOpen>
					<mCommand></mCommand>
					<packageName></packageName>
					<mFgColor>#ff0000</mFgColor>
					<mBgColor>#ffff00</mBgColor>
					<mSoundFile></mSoundFile>
					<colorTriggerFgColor>#000000</colorTriggerFgColor>
					<colorTriggerBgColor>#000000</colorTriggerBgColor>
					<regexCodeList>
						<string>more gquests at this level.</string>
					</regexCodeList>
					<regexCodePropertyList>
						<integer>0</integer>
					</regexCodePropertyList>
				</Trigger>
			</TriggerGroup>
			<Trigger isActive="yes" isFolder="no" isTempTrigger="no" isMultiline="no" isPerlSlashGOption="no" isColorizerTrigger="no" isFilterTrigger="no" isSoundTrigger="no" isColorTrigger="no" isColorTriggerFg="no" isColorTriggerBg="no">
				<name>cp level</name>
				<script>--toggle noexp back off
--in scripts section look at "config" cplvl and set to 0 to disable noexp cp toggle
if matches[2] then
	aard.cpLevel = tonumber(matches[2])
else
	aard.cpLevel = tonumber(gmcp.char.status.level)
end
if aard.noexp == " *NO EXP*" and tonumber(gmcp.char.status.level) &lt;= aard.cpLevel and tonumber(gmcp.char.status.level) &lt;= tonumber(aard.config["cplvl"]) then
  aard.noexp = ""
  aard.qTimeNOexp()
	send("noexp")--turn noexp back on
end</script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand></mCommand>
				<packageName></packageName>
				<mFgColor>#ff0000</mFgColor>
				<mBgColor>#ffff00</mBgColor>
				<mSoundFile></mSoundFile>
				<colorTriggerFgColor>#000000</colorTriggerFgColor>
				<colorTriggerBgColor>#000000</colorTriggerBgColor>
				<regexCodeList>
					<string>.* tells you 'Good luck in your campaign!'$</string>
					<string>^Level Taken........: \[  (?:| |  ) (\d+) \]$</string>
				</regexCodeList>
				<regexCodePropertyList>
					<integer>1</integer>
					<integer>1</integer>
				</regexCodePropertyList>
			</Trigger>
		</TriggerGroup>
	</TriggerPackage>
	<TimerPackage />
	<AliasPackage>
		<AliasGroup isActive="yes" isFolder="yes">
			<name>echo</name>
			<script></script>
			<command></command>
			<packageName>echo</packageName>
			<regex></regex>
			<Alias isActive="yes" isFolder="no">
				<name>`echo</name>
				<script>local s = matches[2]

s = string.gsub(s, "%$", "\n")
feedTriggers("\n" .. s .. "\n")
echo("\n")</script>
				<command></command>
				<packageName></packageName>
				<regex>`echo (.+)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>`cecho</name>
				<script>local s = matches[2]

s = string.gsub(s, "%$", "\n")
cfeedTriggers("\n" .. s .. "\n")
echo("\n")</script>
				<command></command>
				<packageName></packageName>
				<regex>`cecho (.+)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>`decho</name>
				<script>local s = matches[2]

s = string.gsub(s, "%$", "\n")
dfeedTriggers("\n" .. s .. "\n")
echo("\n")</script>
				<command></command>
				<packageName></packageName>
				<regex>`decho (.+)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>`hecho</name>
				<script>local s = matches[2]

s = string.gsub(s, "%$", "\n")
hfeedTriggers("\n" .. s .. "\n")
echo("\n")</script>
				<command></command>
				<packageName></packageName>
				<regex>`hecho (.+)</regex>
			</Alias>
		</AliasGroup>
		<AliasGroup isActive="yes" isFolder="yes">
			<name>run-lua-code-v4</name>
			<script></script>
			<command></command>
			<packageName>run-lua-code-v4</packageName>
			<regex></regex>
			<Alias isActive="yes" isFolder="no">
				<name>run lua code</name>
				<script>local f, e = loadstring("return "..matches[2])
if not f then
  f, e = assert(loadstring(matches[2]))
end

local r =
  function(...)
    if not table.is_empty({...}) then
      display(...)
    end
  end
r(f())</script>
				<command></command>
				<packageName></packageName>
				<regex>^lua (.*)$</regex>
			</Alias>
		</AliasGroup>
		<AliasGroup isActive="yes" isFolder="yes">
			<name>deleteOldProfiles</name>
			<script></script>
			<command></command>
			<packageName>deleteOldProfiles</packageName>
			<regex></regex>
			<Alias isActive="yes" isFolder="no">
				<name>delete old profiles</name>
				<script>deleteOldProfiles(matches[3], matches[2])

--Syntax examples: "delete old profiles"  -&gt; deletes profiles older than 31 days
--					"delete old maps 10"	-&gt; deletes maps older than 10 days</script>
				<command></command>
				<packageName></packageName>
				<regex>^delete old (profiles|maps|modules)(?: (\d+))?$</regex>
			</Alias>
		</AliasGroup>
		<AliasGroup isActive="yes" isFolder="yes">
			<name>enable-accessibility</name>
			<script></script>
			<command></command>
			<packageName>enable-accessibility</packageName>
			<regex></regex>
			<Alias isActive="yes" isFolder="no">
				<name>mudlet accessibility on</name>
				<script>echo("Welcome to Mudlet!\n")
echo("Let's adjust a few preferences to improve the visually impaired experience:\n")

setConfig("autoClearInputLine", true)
echo("Text will now be removed from the input line after it was sent ✓\n")
setConfig("showSentText", false)
echo("Text sent to the game will not appear in the main window ✓\n")

setConfig("caretShortcut", "ctrltab")
echo("Shortcut to switch between input line and main window set to Ctrl+Tab. You can also change it to either Tab or F6 in settings.\n")

if getOS() == "windows" then
  setConfig("blankLinesBehaviour", "hide")
  echo("Blank lines will be removed from the output ✓\n")
end

if getOS() == "mac" then
  echo("\nYou're on a mac and VoiceOver will skip reading text when there's lots of it coming in. Would you like to install a third-party TTS plugin to alleviate this issue?\n")
  echo("Type 'mudlet access reader' if so.\n")
  echo("See https://wiki.mudlet.org/w/Accessibility_on_OSX if you'd like to learn more.\n")
end

echo("\nThat's all, enjoy Mudlet!\n")</script>
				<command></command>
				<packageName></packageName>
				<regex>^mudlet access(?:ibility)? on$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>mudlet accessibility reader</name>
				<script>uninstallPackage"reader"
installPackage"https://github.com/tspivey/mudlet-reader/releases/latest/download/reader.mpackage"</script>
				<command></command>
				<packageName></packageName>
				<regex>^mudlet access(?:ibility)? reader$</regex>
			</Alias>
		</AliasGroup>
		<AliasGroup isActive="yes" isFolder="yes">
			<name>casraf</name>
			<script></script>
			<command></command>
			<packageName></packageName>
			<regex></regex>
			<AliasGroup isActive="yes" isFolder="yes">
				<name>target</name>
				<script></script>
				<command></command>
				<packageName></packageName>
				<regex></regex>
				<Alias isActive="yes" isFolder="no">
					<name>get set target</name>
					<script>if matches[2] then
  if matches[2] == "n" or matches[2] == "n " then
    send("echo Are you trying to use ntgt?", false)
  else
    set_tgt(matches[2])
    echo_tgt_switch()
    send("hunt " .. get_tgt() .. "; where " .. get_tgt())
  end
else
  send("echo Target is: " .. get_tgt(), false)
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^tgt\s?([\d\w'" -]+)?</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>next target</name>
					<script>if matches[2] then
  set_tgt_n(matches[2])
else
  next_tgt_n()
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^ntgt\s?([0-9]+)?</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>get/set goal</name>
					<script>goal = goal or "here"
if matches[2] then
  goal = matches[2]
  send("echo Goal switched to: " .. goal, false)
else
  send("echo Goal is: " .. goal, false)
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^gl(\s([a-zA-Z"']+))?$</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>chase</name>
					<script>local area = matches[2]
local mob = matches[3]

set_tgt(mob)
echo_tgt_switch()

expandAlias("prc;rt " .. area .. "; hunt " .. get_tgt() .. "; where " .. get_tgt())</script>
					<command></command>
					<packageName></packageName>
					<regex>chase ([\w\d]+) (.+)</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>cptgt</name>
					<script>cp_targets = cp_targets or {}
if #cp_targets == 0 then
  echo("No targets captured. Try using 'campaign check'\n")
else
  for k, v in ipairs(cp_targets) do
    echo("Target #" .. k .. ": " .. v["mob"] .. " from " .. v["area"] .."\n")
  end
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^cptgt$</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>cphunt</name>
					<script>cp_targets = cp_targets or {}
local idx = tonumber(matches[2] or "1")

local tgt = get_cp_tgt_info(idx)

if tgt == nil then
  echo("You tried accessing target no. " .. idx .. ", but there are only " .. #cp_targets .. " target(s).\n")
else
  local mob, area = unpack(tgt)
  expandAlias("chase " .. area .. " " .. mob)
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^cphunt( ([0-9]+))?$</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>cphere</name>
					<script>cp_targets = cp_targets or {}
local idx = tonumber(matches[2] or "1")

local tgt = get_cp_tgt_info(idx)

if tgt == nil then
  echo("You tried accessing target no. " .. idx .. ", but there are only " .. #cp_targets .. " target(s).\n")
else
  local mob, area = unpack(tgt)
  expandAlias("tgt " .. mob)
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^cphere( ([0-9]+))?$</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>cpreset</name>
					<script>cp_targets = {}
should_reset_cp_targets = false
echo("Reset CP targets\n")</script>
					<command></command>
					<packageName></packageName>
					<regex>^cpreset$</regex>
				</Alias>
			</AliasGroup>
			<AliasGroup isActive="yes" isFolder="yes">
				<name>bags</name>
				<script></script>
				<command></command>
				<packageName></packageName>
				<regex></regex>
				<Alias isActive="yes" isFolder="no">
					<name>from bag</name>
					<script>local item = matches[3]
local action = matches[4]
local bag = aard.config['bag']

local cmd = 'get ' .. item .. ' ' .. bag .. "; " .. action .. " " .. item .. "; put " .. item .. " " .. bag .. ";"

decho(serialize(matches))
decho("\nitem: ["..item.."], action: [" .. action .. "]\n")
send(cmd)</script>
					<command></command>
					<packageName></packageName>
					<regex>^(fb|from\sbag) ([\w\d\-_.]+|['"][\w\d\s\-_.]+["'])\s?(.*)</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>putall</name>
					<script>local items = matches[4]
local bag = matches[3]

for i, item in pairs(items:split(' ')) do
  local cmd = "put " .. item .. " " .. bag
  send(cmd)
  -- echo(cmd)
  -- echo("\n")
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^(pa|putall) ([\w\d\-_.]+) ([\w\d\-_.  ]+)</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>bag portal</name>
					<script>local area = matches[3]:lower()

if aard.portItems[area] ~= nil then
  local item = aard.portItems[area]
  send("get '"..item.."' '"..aard.config["portbag"].."'; hold '" .. item .. "'; enter; hold " .. aard.config["held"] .. "; put '" ..item.. "' '"..aard.config["portbag"].."'")
else
  echo("Portal item for " .. (area or "nil") .. " not found\n")
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^(bp|bportal) (.+)$</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>buy to bag</name>
					<script>local count = matches[2]
local item = matches[3]

send("buy " .. count .. " " .. item .. "; put all." .. item .. " " .. aard.config["bag"])</script>
					<command></command>
					<packageName></packageName>
					<regex>^bbuy ([0-9]*) (.+)$</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>buy to pbag</name>
					<script>local count = matches[2]
local item = matches[3]

send("buy " .. count .. " " .. item .. "; put all." .. item .. " " .. aard.config["pbag"])</script>
					<command></command>
					<packageName></packageName>
					<regex>^pbuy ([0-9]*\s)?(.+)$</regex>
				</Alias>
				<Alias isActive="yes" isFolder="no">
					<name>bag quaff</name>
					<script>local pot = matches[3]

send("get " .. pot .. " " .. aard.config["pbag"] .. "; quaff " .. pot)</script>
					<command></command>
					<packageName></packageName>
					<regex>^(bq|bag quaff) ([\w\d.\-'"]+)</regex>
				</Alias>
			</AliasGroup>
			<AliasGroup isActive="yes" isFolder="yes">
				<name>pots</name>
				<script></script>
				<command></command>
				<packageName></packageName>
				<regex></regex>
				<Alias isActive="yes" isFolder="no">
					<name>pot sight</name>
					<script>expandAlias("bq sight;bq wolf;bq shadowbane;")</script>
					<command></command>
					<packageName></packageName>
					<regex>^pot sight</regex>
				</Alias>
			</AliasGroup>
			<Alias isActive="yes" isFolder="no">
				<name>precall</name>
				<script>send(aard.config["port"] .. "; hold '" .. aard.config['held'] .. "'")</script>
				<command></command>
				<packageName></packageName>
				<regex>^(prc)|(precall)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>conjure elemental</name>
				<script>local stone = matches[3]
send("hold " .. stone .. "; cast 'conjur elemental'; hold '" ..aard.config["held"] .. "'")</script>
				<command></command>
				<packageName></packageName>
				<regex>^(cj|conjure) (.+)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>crecall</name>
				<script>send("cast 'word of recall'")</script>
				<command></command>
				<packageName></packageName>
				<regex>^(crc)|(crecall)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>arecall</name>
				<script>send("cast 'word of recall'; run 3end")</script>
				<command></command>
				<packageName></packageName>
				<regex>^(arc)|(arecall)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>restock</name>
				<script>send(aard.config["port"] .. "; wear '"..aard.config['held'].."'; w; gulp milk; gulp milk; fill can milk;")</script>
				<command></command>
				<packageName></packageName>
				<regex>^restock</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>sspellup</name>
				<script>send(aard.config["spellup"])</script>
				<command></command>
				<packageName></packageName>
				<regex>^sspellup$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>save config</name>
				<script>save_config(matches[2])</script>
				<command></command>
				<packageName></packageName>
				<regex>config save (.+)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>load config</name>
				<script>load_config(matches[2])</script>
				<command></command>
				<packageName></packageName>
				<regex>config load (.+)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>vconfig</name>
				<script>--(?:\| Stat Mods  \:|\| Resist Mods\:|\| Skill Mods \: Modifies|\| Spells     \: \d+ (?:use|uses) of level|\|            \:
-- \d+ (?:use|uses) of level|\|| ) ([a-zA-Z0-9]+(?: [a-zA-Z]+)*)[ ]*(?:\: \+|\: |by \+| ')[ ]*([a-zA-Z0-9,+-&gt;]+(?: [a-zA-Z]+)*)[']*  

if matches[2] and matches[3] then
	--if aard.config[matches[2]] ~= nil then
	local arg = string.gsub(matches[3],"|",";")
	--if matches[3] has space then surround with single quotes
	aard.config[matches[2]] = arg
  
	if aard.name then
		save_config(aard.name)
	end
	--else
	--	echo("\n"..matches[2].." is Not a valid option.\n")
	--end
elseif matches[2] then
	echo("\nNo Argument Provided for option.\n")
end

display_config()</script>
				<command></command>
				<packageName></packageName>
				<regex>^(?:vc|vco|vcon|vconf|vconfi|vconfig)(?: (\w+) (.*))*$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>todo</name>
				<script>send("tasks here; campaign check; quest info;")</script>
				<command></command>
				<packageName></packageName>
				<regex>^todo|td</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>Knossos - Enter castle</name>
				<script>-- TODO add check for room #

send("s;buy steak;run n2wn;buy silver;")</script>
				<command></command>
				<packageName></packageName>
				<regex></regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>Times - run cmd X times</name>
				<script>local amt = tonumber(matches[2])
local cmd = matches[3]

for i = 1, amt do
  local cur = cmd:gsub('%%', i)
  send(cur)
end</script>
				<command></command>
				<packageName></packageName>
				<regex>times ([0-9]+) (.+)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>Times - run cmd X times</name>
				<script>local amt = tonumber(matches[2])
local cmd = matches[3]

for i = 1, amt do
  local cur = cmd:gsub('%%', i)
  send(cur)
end</script>
				<command></command>
				<packageName></packageName>
				<regex>([\d]+)\* (.+)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>close+lock dir</name>
				<script>local dir = matches[3]
send("close "..dir.."; lock "..dir)</script>
				<command></command>
				<packageName></packageName>
				<regex>(clo|clock) ([dwsneu])</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>knock+enter dir</name>
				<script>local dir = matches[3]
send("c knock "..dir.."; "..dir)</script>
				<command></command>
				<packageName></packageName>
				<regex>(enk|enterknock) ([dwsneu])</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>cr</name>
				<script>send("wake; napalm; ca tru; ca mystic; get all corpse; wear all; get all corpse; wear all")</script>
				<command></command>
				<packageName></packageName>
				<regex>^cr$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>mapload</name>
				<script>local saveString = getMudletHomeDir().."/aardwolf/mapBackup_"..getTime(true,"yyyy.MM.ddThh.mm.ss.zzz")..".dat"
local savedok = saveMap(saveString)

if not savedok then
  echo("Couldn't save map :(\n")
	return 0--bail out, old map didnt save.
else
  echo("Map saved to: "..saveString.."\n")
	loadMap(getMudletHomeDir().."/aardwolf/"..matches[2]..".dat")
end</script>
				<command></command>
				<packageName></packageName>
				<regex>^mapload (.*)$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>mapsave</name>
				<script>local basename = matches[2] or "map"
local filename = getMudletHomeDir().."/aardwolf/"..basename..".dat"
echo("Map saved to: "..filename.."\n")
saveMap(filename)
</script>
				<command></command>
				<packageName></packageName>
				<regex>^mapsave\s?(.*)$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>Put all pots in bags</name>
				<script>send("put all.breakfast " .. aard.config["pbag"] .. "; put all.acco " .. aard.config["pbag"] .. "; put all.camo " .. aard.config["pbag"])</script>
				<command></command>
				<packageName></packageName>
				<regex>potbag</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>rearm</name>
				<script>send("wear '"..aard.config["wield"].."'; wear '"..aard.config["held"].."'")</script>
				<command></command>
				<packageName></packageName>
				<regex>^(rearm|ra)$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>rehold</name>
				<script>send("wear '"..aard.config["held"].."'")</script>
				<command></command>
				<packageName></packageName>
				<regex>^(rehold|rh)$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>keep wear</name>
				<script>local item = matches[3]
send("keep '" .. item .. "'; wear '"..item.."'")</script>
				<command></command>
				<packageName></packageName>
				<regex>^(kw|keepwear) (.+)$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>buy keep wear</name>
				<script>local item = matches[3]
send("buy '" .. item .. "'; keep '" .. item .. "'; wear '"..item.."'")</script>
				<command></command>
				<packageName></packageName>
				<regex>^(bkw|buykeepwear) (.+)$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>portal runto</name>
				<script>expandAlias("prc;rt " .. matches[2])</script>
				<command></command>
				<packageName></packageName>
				<regex>^prt (.+)$</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>vis</name>
				<script>tmpVis = true
send("vis")</script>
				<command></command>
				<packageName></packageName>
				<regex>^vis$</regex>
			</Alias>
		</AliasGroup>
	</AliasPackage>
	<ActionPackage>
		<ActionGroup isActive="yes" isFolder="yes" isPushButton="no" isFlatButton="no" useCustomLayout="no">
			<name>button-spells</name>
			<packageName>button-spells</packageName>
			<script></script>
			<css></css>
			<commandButtonUp></commandButtonUp>
			<commandButtonDown></commandButtonDown>
			<icon></icon>
			<orientation>0</orientation>
			<location>0</location>
			<posX>0</posX>
			<posY>0</posY>
			<mButtonState>1</mButtonState>
			<sizeX>0</sizeX>
			<sizeY>0</sizeY>
			<buttonColumn>1</buttonColumn>
			<buttonRotation>0</buttonRotation>
			<ActionGroup isActive="yes" isFolder="yes" isPushButton="no" isFlatButton="no" useCustomLayout="no">
				<name>Spells</name>
				<packageName></packageName>
				<script></script>
				<css></css>
				<commandButtonUp></commandButtonUp>
				<commandButtonDown></commandButtonDown>
				<icon></icon>
				<orientation>1</orientation>
				<location>2</location>
				<posX>0</posX>
				<posY>0</posY>
				<mButtonState>1</mButtonState>
				<sizeX>0</sizeX>
				<sizeY>0</sizeY>
				<buttonColumn>1</buttonColumn>
				<buttonRotation>0</buttonRotation>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Attack</name>
					<packageName></packageName>
					<script></script>
					<css>border: none; background: none; margin: 8px 0 4px 0;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Primary Atk 🎯️</name>
					<packageName></packageName>
					<script>send(aard.config["attack1"] .. " '" .. target .. "'")</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Primary Atk</name>
					<packageName></packageName>
					<script>send(aard.config["attack1"])</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Secondary Atk</name>
					<packageName></packageName>
					<script>send(aard.config["attack2"])</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>💥️ Earth Maw</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'earth maw'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>💥️ Air Dart</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'air dart'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>💥️ Magic Missile</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'magic missile'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🔥 Balefire</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'balefire'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>⚡️ Lightning Strike</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'lightning strike'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>💡 Nova</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'nova'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>💥️ Force Bolt</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'force bolt'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🔥 Flaming Sphere</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'flaming sphere'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🔥 Fire Breath 👥</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'fire breath'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🥶️ Shard of Ice</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'shard of ice'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🥶️ Ice Cloud 👥</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'ice cloud'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>💥️ Talon</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca talon</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🤢️ Miasma</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'miasma'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🤢️ Acid Cloud 👥</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'acid cloud'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🤢️ Poison</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'poison'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🧛🏼‍ Vampiric Touch</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca vampiric</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="no" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>⚡️ Shock Aura</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'shock aura'</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Heal Spells</name>
					<packageName></packageName>
					<script></script>
					<css>border: none; background: none; margin: 8px 0 4px 0;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>⚕️️ Cure light</name>
					<packageName></packageName>
					<script>send("cast 'cure light'")</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Pots</name>
					<packageName></packageName>
					<script></script>
					<css>border: none; background: none; margin: 8px 0 4px 0;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>HP heal</name>
					<packageName></packageName>
					<script>local pot = aard.config['hpot']
send("get " .. pot .. " " .. aard.config['pbag'] .. "; quaff " .. pot)</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Sanctuary</name>
					<packageName></packageName>
					<script>local pot = "accomplice"
send("get " .. pot .. " " .. aard.config['pbag'] .. "; quaff " .. pot)</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Inertia</name>
					<packageName></packageName>
					<script>local pot = "camouflage"
send("get " .. pot .. " " .. aard.config['pbag'] .. "; quaff " .. pot)</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Utility</name>
					<packageName></packageName>
					<script></script>
					<css>border: none; background: none; margin: 8px 0 4px 0;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>✨️ Spellup</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>spellup</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🎒️ Restock</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>restock</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>😴️ Restock + Sleep</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>restock; sleep bed</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🥛️ Quench</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>gulp can; gulp can;</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Rest Outside 🔥️</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>gulp can; gulp can; fire; sleep</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Quests/Campaigns</name>
					<packageName></packageName>
					<script></script>
					<css>border: none; background: none; margin: 8px 0 4px 0;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>❓️ CP Check</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>campaign check</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>❓️ Q Info</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>quest info</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>❓️ GQ Check</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>gq check</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🤌🏻 CP Request</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>prc; campaign request</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🤌🏻 Q Request</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>prc; quest request</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>✅️ Q Complete</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>prc; quest complete</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Tasks</name>
					<packageName></packageName>
					<script></script>
					<css>border: none; background: none; margin: 8px 0 4px 0;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Tasks</name>
					<packageName></packageName>
					<script>send("tasks " .. goal .. " all")</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Tasks (Here)</name>
					<packageName></packageName>
					<script>send("tasks here all")</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Find</name>
					<packageName></packageName>
					<script></script>
					<css>border: none; background: none; margin: 8px 0 4px 0;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🔍 Where</name>
					<packageName></packageName>
					<script>send("where " .. get_tgt())</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🤔️ Hunt</name>
					<packageName></packageName>
					<script>send("hunt " .. get_tgt())</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>▶ Hunt Next</name>
					<packageName></packageName>
					<script>next_tgt_n()
echo_tgt_switch()
send("hunt " .. get_tgt())</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>⏮ Reset Target</name>
					<packageName></packageName>
					<script>reset_tgt_n()
echo_tgt_switch()</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🔈️ Echo Target</name>
					<packageName></packageName>
					<script>echo_tgt()</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
			</ActionGroup>
		</ActionGroup>
		<ActionGroup isActive="yes" isFolder="yes" isPushButton="no" isFlatButton="no" useCustomLayout="no">
			<name>button-move</name>
			<packageName>button-move</packageName>
			<script></script>
			<css></css>
			<commandButtonUp></commandButtonUp>
			<commandButtonDown></commandButtonDown>
			<icon></icon>
			<orientation>0</orientation>
			<location>0</location>
			<posX>0</posX>
			<posY>0</posY>
			<mButtonState>1</mButtonState>
			<sizeX>0</sizeX>
			<sizeY>0</sizeY>
			<buttonColumn>1</buttonColumn>
			<buttonRotation>0</buttonRotation>
			<ActionGroup isActive="yes" isFolder="yes" isPushButton="no" isFlatButton="no" useCustomLayout="no">
				<name>Move</name>
				<packageName></packageName>
				<script></script>
				<css></css>
				<commandButtonUp></commandButtonUp>
				<commandButtonDown></commandButtonDown>
				<icon></icon>
				<orientation>0</orientation>
				<location>0</location>
				<posX>0</posX>
				<posY>0</posY>
				<mButtonState>1</mButtonState>
				<sizeX>0</sizeX>
				<sizeY>0</sizeY>
				<buttonColumn>1</buttonColumn>
				<buttonRotation>0</buttonRotation>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>⬅</name>
					<packageName></packageName>
					<script></script>
					<css>background-color: green; max-width: 30px;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>w</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>⬇</name>
					<packageName></packageName>
					<script></script>
					<css>background-color: red; max-width: 30px;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>s</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>⬆</name>
					<packageName></packageName>
					<script></script>
					<css>background-color: red; max-width: 30px;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>n</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>➡</name>
					<packageName></packageName>
					<script></script>
					<css>background-color: green; max-width: 30px;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>e</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>↗</name>
					<packageName></packageName>
					<script></script>
					<css>background-color: blue; max-width: 30px;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>u</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>↙</name>
					<packageName></packageName>
					<script></script>
					<css>background-color: blue; max-width: 30px;</css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>d</commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Recall</name>
					<packageName></packageName>
					<script>expandAlias("crc")</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Portal Recall</name>
					<packageName></packageName>
					<script>send(aard.config["port"] .. "; hold " .. aard.config['held'])</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>Upper Planes Portal</name>
					<packageName></packageName>
					<script>send("hold planes;enter;hold " .. aard.config["held"])</script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown></commandButtonDown>
					<icon></icon>
					<orientation>1</orientation>
					<location>0</location>
					<posX>0</posX>
					<posY>0</posY>
					<mButtonState>1</mButtonState>
					<sizeX>0</sizeX>
					<sizeY>0</sizeY>
					<buttonColumn>1</buttonColumn>
					<buttonRotation>0</buttonRotation>
				</Action>
			</ActionGroup>
		</ActionGroup>
	</ActionPackage>
	<ScriptPackage>
		<ScriptGroup isActive="yes" isFolder="yes">
			<name>deleteOldProfiles</name>
			<packageName>deleteOldProfiles</packageName>
			<script></script>
			<eventHandlerList />
			<Script isActive="yes" isFolder="no">
				<name>deleteOldProfiles script</name>
				<packageName></packageName>
				<script>function deleteOldProfiles(keepdays_arg, delete_folder)
  --[[
  Deletes old profiles/maps/modules in the "current"/"map"/"moduleBackups" folders of the Mudlet home directory.
  The following files are NOT deleted:
  - Files newer than the amount of days specified as an argument to deleteOldProfiles(), or 31 days if not specified.
  - One file for every month before that. Specifically: The first available file of every month prior to this.
  Setting the second argument to true will delete maps instead of profiles. (e.g. deleteOldProfiles(10, true))
  --]]

  -- Ensure correct value is passed for second argument
  assert(type(delete_folder) == "string", "Wrong type for delete_folder; expected string, got " .. type(delete_folder))
  assert(table.contains({"profiles", "maps", "modules"}, delete_folder), "delete_folder must be profiles, maps or modules")

  local keepdays = tonumber(keepdays_arg) or 31
  local profile_table = {}
  local used_last_mod_months = {}
  local slash = (string.char(getMudletHomeDir():byte()) == "/") and "/" or "\\"
  local delnum = 0

  local to_folder = {
    profiles = "current",
    maps = "map",
  }

  local dirpath = delete_folder == "modules"
    and getMudletHomeDir()..slash..".."..slash..".."..slash.."moduleBackups"
    or getMudletHomeDir()..slash..to_folder[delete_folder]

  -- Traverse the profiles folder and create a table of files:
  for filename in lfs.dir(dirpath) do
    if filename~="." and filename~=".." then
      profile_table[#profile_table+1] = {
        name = filename,
        last_mod = lfs.attributes(dirpath..slash..filename, "modification")
      }
    end
  end

  -- Sort the table according to last modification date from old to new:
  table.sort(profile_table, function (a,b) return a.last_mod &lt; b.last_mod end)

  echo(string.format(
    "\nDeleting old %s. Files newer than %d days and one for every month before that will be kept.",
    delete_folder,
    keepdays
  ))

  for i, v in ipairs(profile_table) do
    local days = math.floor(os.difftime(os.time(), v.last_mod) / 86400)
    local last_mod_month = os.date("%Y/%m", v.last_mod)
    if days &gt; keepdays then
      -- For profiles older than X days, check if we already kept a table for this month:
      if not table.contains(used_last_mod_months, last_mod_month) then
        -- If not, do nothing and mark this month as "kept".
        used_last_mod_months[#used_last_mod_months+1] = last_mod_month
      else
        -- Otherwise remove the file:
        local success, errorstring = os.remove(dirpath..slash..v.name)
        if success then
          delnum = delnum + 1
        else
          cecho("\n&lt;red&gt;ERROR: "..errorstring)
        end
      end
    end
  end

  echo(string.format("\nDeletion complete. %d/%d files were removed successfully.", delnum, #profile_table))
end
</script>
				<eventHandlerList />
			</Script>
		</ScriptGroup>
		<ScriptGroup isActive="yes" isFolder="yes">
			<name>casraf</name>
			<packageName></packageName>
			<script></script>
			<eventHandlerList />
			<Script isActive="yes" isFolder="no">
				<name>target</name>
				<packageName></packageName>
				<script>target = target or ""
target_n = target_n or 1

function echo_tgt_switch()
  send("echo Target switched to: " .. get_tgt(), false)
end

function echo_tgt()
  send("echo Target is: " .. get_tgt(), false)
end

function set_tgt(tgt, log)
  target = tgt
  target_n = 1
end

function get_tgt()
  return target_n .. "." .. target
end

function next_tgt_n(log)
  set_tgt_n((target_n or 1) + 1, log)
end

function set_tgt_n(n, log)
  target_n = n
  log = log or true
end

function reset_tgt_n(log)
  set_tgt_n(1, log)
end</script>
				<eventHandlerList />
			</Script>
			<Script isActive="yes" isFolder="no">
				<name>config</name>
				<packageName></packageName>
				<script>aard.config = {
  ["hpot"]="breakfast",
  ["mpot"]="moonlight",
  ["vpot"]="refreshing",
  ["pbag"]="backpack",
  ["portbag"]="bag",
  ["wield"]="erato",
  ["dual"]="flute",
  ["held"]="notes",
  ["port"]="cast 'word of recall'",
  ["attack1"]="ca 'flame arrow'",
  ["debuff1"]="ca poison",
  ["debuff2"]="ca wither",
  ["cplvl"]=150,
  ["cpexp"]=700,
  ["group"]=1,
  ["tdiff"]=-3,
  ["speak"]="false", -- Stringly typed because of user input in vconfig
  ["spellup"]="napalm;spellup",
}

function load_config(name)
  if name then
    local filename = getMudletHomeDir().."/aardwolf/config-"..name..".lua"
    table.load(filename, aard.config)
    decho("Loaded from "..filename.."\n")
  else
    decho("Must provide filename\n")
  end
end

function save_config(name)
  if name then
    local filename = getMudletHomeDir().."/aardwolf/config-"..name..".lua"
    table.save(filename, aard.config)
    decho("Saved to "..filename.."\n")
  else
    decho("Must provide filename\n")
  end
end

local srep = string.rep

function lpad(s, l, c)
	local res = srep(c or ' ', l - #s) .. s
	return res, res ~= s
end

-- pad the right side
function rpad(s, l, c)
	local res = s .. srep(c or ' ', l - #s)
	return res, res ~= s
end

-- pad on both sides (centering with left justification)
function spad(s, l, c)
	c = c or ' '
	local res1, stat1 = rpad(s,    (l / 2) + #s, c) -- pad to half-length + the length of s
	local res2, stat2 = lpad(res1,  l,           c) -- right-pad our left-padded string to the full length
	return res2, stat1 or stat2
end

function display_config()
  local tbl = {
    { "port", "Recall portal to use" },
    { "wield", "Wielded weapon to use" },
    { "dual", "Dual wielded weapon to use" },
    { "held", "Held item to return after using portals" },
    { "spellup", "Spellup to use" },
    { "hpot", "Health potion to use" },
    { "mpot", "Mana potion to use" },
    { "vpot", "Moves potion to use" },
    { "pbag", "Potions bag" },
    { "portbag", "Portals bag" },
    { "bag", "General bag" },
    { "attack1", "Primary attack" },
    { "attack2", "Secondary attack" },
    { "debuff1", "First debuff" },
    { "debuff2", "Second debuff" },
    { "cplvl", "Level to CP level until" },
    { "cpexp", "CP Level noexp toggle amount" },
    { "group", "Group Frame Format until" },
    { "tdiff", "Time Difference from Mud Time" },
    { "speak", "Speak audio alerts" },    
  }
  
  --lua display(getFgColor())
  decho("&lt;51,102,255&gt;-vconfig- &lt;192,192,192&gt; seperate multiple commands with &lt;51,102,255&gt;|&lt;192,192,192&gt; instead of &lt;51,102,255&gt;;\n\n")
  
  for i, row in ipairs(tbl) do
    local key = row[1]
    local desc = row[2]
    
    local value = aard.config[key] or "&lt;empty&gt;"
    local edit_value = aard.config[key] or ""
    
    decho("  &lt;51,102,255&gt;- &lt;192,192,192&gt; " .. rpad("[" .. key .. "]", 10) .. "&lt;255,165,0&gt;" .. rpad(desc, 40) .. "&lt;192,192,192&gt; ")
    setFgColor(51, 102, 255)
    echoLink(value, "printCmdLine'vconfig "..key.." "..string.gsub(edit_value,";","|"):gsub("'", "\\'") .."'", "Click to override " .. desc, true)
    echo("\n")
  end
  
  setFgColor(192,192,192)
  echo("\n")
end

if aard.name then
  load_config(aard.name)
end</script>
				<eventHandlerList />
			</Script>
			<Script isActive="yes" isFolder="no">
				<name>utils</name>
				<packageName></packageName>
				<script>function serialize(t)
  local serializedValues = {}
  local value, serializedValue
  for i=1,#t do
    value = t[i]
    serializedValue = type(value)=='table' and serialize(value) or value
    table.insert(serializedValues, serializedValue)
  end
  return string.format("{ %s }", table.concat(serializedValues, ', ') )
end</script>
				<eventHandlerList />
			</Script>
			<ScriptGroup isActive="yes" isFolder="yes">
				<name>Maps</name>
				<packageName></packageName>
				<script></script>
				<eventHandlerList />
				<Script isActive="yes" isFolder="no">
					<name>tools</name>
					<packageName></packageName>
					<script>function minimapsnap()
	local mapw = 232
	local maph = 255
	local mapx = 800
	local mapy = 0
  if GUIframe.tabCoords.topRightTabs then
		mapx = GUIframe.tabCoords.topRightTabs.x - mapw - 22
		mapy = GUIframe.tabCoords.topRightTabs.y
	end
	
  if minimap then
		--minimap
		minimap:move(mapx,mapy)
		
		--group frames
		if gInfo then
      local barW = 150
      local gx = minimap.x:gsub("px","")+(minimap.width:gsub("px","")-barW)
      local gy = minimap.y:gsub("px","")+minimap.height:gsub("px","")
      gInfo:move(gx,gy)
		end
		
	end	
end

function mapStarter()
  setMapUserData("last_modified", getTime(true,"yyyy.MM.ddThh:mm:ss.zzz"))
  
  local saveString = getMudletHomeDir().."/aardwolf/mapBackup_"..getTime(true,"yyyy.MM.ddThh.mm.ss.zzz")..".dat"
	local savedok = saveMap(saveString)
	
  if not savedok then
    echo("Couldn't save map :(\n")
		return 0--bail out, map didnt save.
  else
    echo("Map saved to: "..saveString.."\n")
		loadMap(getMudletHomeDir().."/aardwolf/mapStarter.dat")
  end
  --lua display(getMapUserData("last_modified"))
  --lua display(getAllMapUserData())	
end

function mapCheck()
	--MAP Backup, save, load
  local myRoomsTable = getRooms()
  local count = count or 0
  for _ in pairs(myRoomsTable) do count = count + 1 end
	if count &gt; 14906 then
		echo("\n")
		aard.log:info("Your existing map has "..count.." rooms mapped.")
		aard.log:info("To load the starter map anyway (14907 rooms) type: startermap")
		aard.log:info("startermap will backup your map before loading the starter map.")
	else
		mapStarter()		
	end
end

function checkDoor(id,dir)
  local doors = getDoors(id)
  
  if not next(doors) then
		--cecho("\nThere aren't any doors in the room.")
		return
	end
  
  local door_status = {"open", "closed", "locked"}  
  for direction, door in pairs(doors) do
  	if direction == dir then
			if dir == "up" then--shorten further
				dir = "u"
			elseif dir == "down" then--shorten further
				dir = "d"
			end
  		return "o "..dir..";"
  	end
    --cecho("\nThere's a door leading in "..direction.." that is "..door_status[door]..".")
  end
end

function openDoor(dir)
  local doors = getDoors(aard.map.current_room)
  
  if not next(doors) then
		--cecho("\nThere aren't any doors in the room.")
		return
	end
  
  local door_status = {"open", "closed", "locked"}  
  for direction, door in pairs(doors) do
  	if direction == dir then
      if door_status[door] == "locked" then
        send("c knock "..dir..";op "..dir,true)
      else
    		send("op "..dir,true)
      end
  	end
    --cecho("\nThere's a door leading in "..direction.." that is "..door_status[door]..".")
  end
end

aard.echocolour = "cyan"

function aard_regenerate_areas()
  -- cached data
  aard.areatable = getAreaTable() -- this translates an area name to an ID
  aard.areatabler = {} -- this translates an ID to an area name

  local t = getAreaTable()
  for k,v in pairs(t) do
    aard.areatabler[tonumber(v)] = k
  end

  --aard.clearpathcache()
end
aard_regenerate_areas()

function aard.echoPath(from, to)
	assert(tonumber(from) and tonumber(to), "getPath: both from and to have to be room IDs")
	if getPath(from, to) then
		cecho("&lt;white&gt;Directions from &lt;yellow&gt;" .. string.upper(searchRoom(from)) .. " &lt;white&gt;to &lt;yellow&gt;" .. string.upper(searchRoom(to)) .. "&lt;white&gt;:")
		echo(table.concat(speedWalkDir, ", "))
		return aard.speedWalkDir
	else
	  cecho("&lt;white&gt;I can't find a way from &lt;yellow&gt;" .. string.upper(searchRoom(from)) .. " &lt;white&gt;to &lt;yellow&gt;" .. string.upper(searchRoom(to)) .. "&lt;white&gt;")
	end
end

function aard.roomFind(query)
  if query:ends('.') then query = query:sub(1,-2) end
  local result = aard.searchRoom(query)

  if type(result) == "string" or not next(result) then
    cecho("\n&lt;grey&gt; You have no recollection of any room with that name.\n") return end

  cecho("\n&lt;DarkSlateGrey&gt; You know the following relevant rooms:\n")

  local function showmeropis(roomid)
    if aard.game ~= "achaea" then return '' end

    return aard.oncontinent(getRoomArea(roomid), "Main") and '' or ' (Meropis)'
  end

  if not tonumber(select(2, next(result))) then -- old style
    for roomid, roomname in pairs(result) do roomid = tonumber(roomid)
      cecho(string.format("  &lt;LightSlateGray&gt;%s&lt;DarkSlateGrey&gt; (",
        tostring(roomname)))
      cechoLink("&lt;"..aard.echocolour.."&gt;"..roomid, 'gotoRoom('..roomid..')', string.format("Go to %s (%s)", roomid, tostring(roomname)), true)
      cecho(string.format("&lt;DarkSlateGrey&gt;) in &lt;LightSlateGray&gt;%s%s&lt;DarkSlateGrey&gt;.", aard.stripRoomName(tostring(getRoomAreaName(getRoomArea(roomid)))), showmeropis(roomid)))
      fg("DarkSlateGrey") echoLink(" &gt; Show path", [[aard.echoPath(]]..aard.map.current_room..[[, ]]..roomid..[[)]], "Display directions from here to "..roomname, true) echo("  ")
			fg("DarkSlateGrey") echoLink(" &gt; Show recall path\n", [[showSpeedWalk(32418, ]]..roomid..[[)]], "Display directions from here to "..roomname, true)
			resetFormat()
    end

  else -- new style
    for roomname, roomid in pairs(result) do roomid = tonumber(roomid)
      cecho(string.format("  &lt;LightSlateGray&gt;%s&lt;DarkSlateGrey&gt; (",
        tostring(roomname)))
      cechoLink("&lt;"..aard.settings.echocolour.."&gt;"..roomid, 'aard.gotoRoom('..roomid..')', string.format("Go to %s (%s)", roomid, tostring(roomname)), true)
      cecho(string.format("&lt;DarkSlateGrey&gt;) in &lt;LightSlateGray&gt;%s%s&lt;DarkSlateGrey&gt;.", aard.cleanAreaName(tostring(getRoomAreaName(getRoomArea(roomid)))), showmeropis(roomid)))
      fg("DarkSlateGrey") echoLink(" &gt; Show path", [[aard.echoPath(]]..aard.map.current_room..[[, ]]..roomid..[[)]], "Display directions from here to "..roomname, true) echo("  ")
			fg("DarkSlateGrey") echoLink(" &gt; Show recall path\n", [[showSpeedWalk(32418, ]]..roomid..[[)]], "Display directions from here to "..roomname, true)
			resetFormat()
    end
  end

  cecho(string.format("  &lt;DarkSlateGrey&gt;%d rooms found.\n", table.size(result)))
end

function aard.roomFindArea(query)
  if query:ends('.') then query = query:sub(1,-2) end
  local result = aard.searchRoomArea(query)

  if type(result) == "string" or not next(result) then
    cecho("\n&lt;grey&gt; You have no recollection of any room with that name.\n") return end

  cecho("\n&lt;DarkSlateGrey&gt; You know the following relevant rooms:\n")

  local function showmeropis(roomid)
    if aard.game ~= "achaea" then return '' end

    return aard.oncontinent(getRoomArea(roomid), "Main") and '' or ' (Meropis)'
  end

  if not tonumber(select(2, next(result))) then -- old style
    for roomid, roomname in pairs(result) do roomid = tonumber(roomid)
      cecho(string.format("  &lt;LightSlateGray&gt;%s&lt;DarkSlateGrey&gt; (",
        tostring(roomname)))
      cechoLink("&lt;"..aard.echocolour.."&gt;"..roomid, 'gotoRoom('..roomid..')', string.format("Go to %s (%s)", roomid, tostring(roomname)), true)
      cecho(string.format("&lt;DarkSlateGrey&gt;) in &lt;LightSlateGray&gt;%s%s&lt;DarkSlateGrey&gt;.", aard.stripRoomName(tostring(getRoomAreaName(getRoomArea(roomid)))), showmeropis(roomid)))
      fg("DarkSlateGrey") echoLink(" &gt; Show path", [[aard.echoPath(]]..aard.map.current_room..[[, ]]..roomid..[[)]], "Display directions from here to "..roomname, true) echo("  ")
			fg("DarkSlateGrey") echoLink(" &gt; Show speedwalk\n", [[showSpeedWalk(32418, ]]..roomid..[[)]], "Display directions from here to "..roomname, true)
			resetFormat()
    end

  else -- new style
    for roomname, roomid in pairs(result) do roomid = tonumber(roomid)
      cecho(string.format("  &lt;LightSlateGray&gt;%s&lt;DarkSlateGrey&gt; (",
        tostring(roomname)))
      cechoLink("&lt;"..aard.settings.echocolour.."&gt;"..roomid, 'aard.gotoRoom('..roomid..')', string.format("Go to %s (%s)", roomid, tostring(roomname)), true)
      cecho(string.format("&lt;DarkSlateGrey&gt;) in &lt;LightSlateGray&gt;%s%s&lt;DarkSlateGrey&gt;.", aard.cleanAreaName(tostring(getRoomAreaName(getRoomArea(roomid)))), showmeropis(roomid)))
      fg("DarkSlateGrey") echoLink(" &gt; Show path", [[aard.echoPath(]]..aard.map.current_room..[[, ]]..roomid..[[)]], "Display directions from here to "..roomname, true) echo("  ")
			fg("DarkSlateGrey") echoLink(" &gt; Show speedwalk\n", [[showSpeedWalk(32418, ]]..roomid..[[)]], "Display directions from here to "..roomname, true)
			resetFormat()
    end
  end

  cecho(string.format("  &lt;DarkSlateGrey&gt;%d rooms found.\n", table.size(result)))
end

-- searchRoom with a cache!
local cache = {}
setmetatable(cache, {__mode = "kv"}) -- weak keys/values = it'll periodically get cleaned up by gc

function aard.searchRoom(what)
  what = what:lower()
  local result = nil -- cache[what]
  if not result then
    result = searchRoom(what)
    local realResult = {}
    for key, value in pairs(type(result) == "table" and result or {}) do
        -- both ways, because searchRoom can return either id-room name or the reverse
        if type(key) == "string" then					
          realResult[key:ends(" (road)") and key:sub(1, -8) or key] = value
        else
          realResult[key] = value:ends(" (road)") and value:sub(1, -8) or value
        end
    end
    cache[what] = realResult
    result = realResult
  end
  return result
end

function aard.searchRoomExact(what)
  what = what:lower()
  local result = nil -- cache[what]
  if not result then
    result = searchRoom(what,true,true)
    local realResult = {}
    for key, value in pairs(type(result) == "table" and result or {}) do
        -- both ways, because searchRoom can return either id-room name or the reverse
        if type(key) == "string" then					
          realResult[key:ends(" (road)") and key:sub(1, -8) or key] = value
        else
          realResult[key] = value:ends(" (road)") and value:sub(1, -8) or value
        end
    end
    cache[what] = realResult
    result = realResult
  end
  return result
end

function aard.searchRoomArea(what)
  what = what:lower()
  local result = nil -- cache[what]
  if not result then
    result = searchRoom(what)
    local realResult = {}
    for key, value in pairs(type(result) == "table" and result or {}) do
        -- both ways, because searchRoom can return either id-room name or the reverse
        if type(key) == "string" then					
          realResult[key:ends(" (road)") and key:sub(1, -8) or key] = value
        else
					--search room by string value
					--display(value)
					if getRoomArea(key) == getRoomArea(aard.map.seen_room) then
						realResult[key] = value:ends(" (road)") and value:sub(1, -8) or value
					end
					--display(getRoomArea(key))
					--display(getRoomArea(aard.map.seen_room))          
        end
    end
    cache[what] = realResult
    result = realResult
  end
  return result
end</script>
					<eventHandlerList />
				</Script>
				<Script isActive="yes" isFolder="no">
					<name>onRoom</name>
					<packageName></packageName>
					<script>function onRoom()	
  if not aard.map.current_room then--value not initialized
    if gmcp.room.info then
      if gmcp.room.info.num then--gmcp room number available
        if gmcp.room.info.num ~= -1 then--gmcp room number is not a -1 value (nomap room)
          aard.map.current_room = gmcp.room.info.num
        end
      end
    end
  end
  if not (aard.map.init) then return end

  if (aard.special_move) then 
	aard.special_move = false
	return 
  end
  aard.log:debug("Parsing room")
  if gmcp.room.info then
  	if gmcp.room.info.num == 49393 then
  		send("close north;lock north")
  	elseif gmcp.room.info.num == 47195 and aard.command == "n" then
  		send("close south;lock south")
  	elseif gmcp.room.info.num == 49260 and aard.command == "u" then
  		send("close down;lock down")
  	end
	end
  aard.map:parseGmcpRoom()
	
end
-- Parse gmcp.room data from the mud

function aard.map:parseGmcpRoom()
  local room_data = gmcp.room.info
	--local full = gmcp.room
  --display(room_data)
	--display(full)
  local zone_name = gmcp.room.info.zone

  -- Zone Handling
  if aard.map.current_zone ~= zone_name then
    aard.log:debug("Entered different zone")
    aard.map:setZone(zone_name)
  end
 
  -- Continent handling
  if gmcp.room.info.coord.cont == 1 then
    aard.log:debug("Continent room seen")
    local found_zone, zone_id = aard.map:isKnownZone(zone_name)
--    setGridMode(zone_id, true)
  end

  aard.map.seen_room = gmcp.room.info.num
  aard.map.prior_room = aard.map.current_room

  if aard.map.seen_room == -1 then
    -- Eventually needs to work to map "nomap" areas...
    aard.log:info("Can't find room based on mud id - none given - nomap rooms not yet implemented")
    local nexits = getRoomExits(aard.map.current_room)
		display(nexits)
		--if direction from existing room - room exists then display warning, room already exists
		--elseif direction does not have existing room, create it.
  		--aard.log:debug("New room seen - creating...")
      --aard.map:createRoom()
  elseif roomExists(aard.map.seen_room) then
	
    if getRoomEnv(aard.map.seen_room) == 999 then
				aard.map:exploreRoom()
--      aard.log:debug("Existing room is a temp room - recreating")
--      deleteRoom(aard.map.seen_room)  -- Causes exits to get delinked!
--      aard.map:createRoom()
--      aard.map:connectExits(aard.map.prior_room_data) -- Relink missing exits
    else
      aard.log:debug("Found existing room - moving there")
      aard.map.current_room = aard.map.seen_room
			--jakejake this goes off the direction used instead of vnum info. for now lets work without this.
			--because if you quickly spam comamnds such as north west north west, it gets it wrong.
			--i have an idea that may make this work by comparing command history, but its not a priority right now.
			--if aard.map:isCardinalExit(command) then
			--	if aard.map.prior_room ~= gmcp.room.info.num then--prevent same room linking, alas you cannot go that way!
			--		setExit(aard.map.prior_room, aard.map.current_room, command)
			--	end
			--end
			--do some get room position magic here, to confirm that a room exists in the given direction.
			--and that the previous and current roomnumbers line up for that direction.
      if aard.other == true then
				aard.other = false
				aard.map:connectSpecialExits()
      end
			centerview(aard.map.seen_room)--jakejake	
    	if firstRoom == true or aard.newzone == true then
    	  aard.map:connectExits(gmcp.room,false)
    	else
    	  aard.map:connectExits(gmcp.room,true)
    	end
    end
  else
    aard.log:debug("New room seen - creating...")
    --display(room_data)
    aard.map:createRoom()
  end
  aard.map.prior_room_data = table.copy(gmcp.room)
  aard.map.prior_zone_name = zone_name
	
	--call map label update here.
	--mapLabel(room_data.zone:gsub("^%l", string.upper) .. " - " .. room_data.name)
	local maptext = room_data.zone:gsub("^%l", string.upper) .. " - " .. aard.stripRoomName(gmcp.room.info.name)
	GUIframe.tabs.Map:echo('&lt;p style="font-size:13px; color = white"&gt;&lt;b&gt;' .. maptext)
end

function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end</script>
					<eventHandlerList>
						<string>gmcp.room</string>
					</eventHandlerList>
				</Script>
			</ScriptGroup>
			<Script isActive="yes" isFolder="no">
				<name>portal items</name>
				<packageName></packageName>
				<script>aard.portItems = {
  ["aylor"] = "Amulet of Aardwolf",
  ["boot"] = "duffle",
  ["fayke"] = "Wizard's Prism",
  ["amazon"] = "Queen Melosa's Mirror",
  ["amusement"] = "amulet planes",
  ["entropy"] = "Lemniscate",
  ["arisian"] = "dolphin",
  ["mayhem"] = "Compendium of Fal'Shara",
  ["academy"] = "Academy portal",
  ["adaldar"] = "Permanent Peace",
  ["lagoon"] = "A Black Pendant",
  ["raukora"] = "Black Darkness of the Citadel",
  ["horath"] = "amulet of dragon warding",
  ["callhero"] = "Aura of the Sage",
  ["cataclysm"] = "Laurels of the Victor",
  ["cougarian"] = "Cowlina's Trust",
  ["fens"] = "dreary hole of despair",
  ["stronghold"] = "Enchanted Dreams",
  ["zyian"] = "Medallion",
  ["darklight"] = "orb of the stars",
  ["deadlights"] = "Timeless Seal of the Ages",
  ["ddoom"] = "Desert Doom",
  ["desert"] = "Gate Rune",
  ["dsr"] = "Queen Angelina's Locket",
  ["drageran"] = "Backstage Pass",
  ["drageran"] = "Royal Audience",
  ["dread"] = "Broken Curse",
  ["dynasty"] = "Hatshepsut's Cartouche",
  ["empire"] = "Denali's teleport device",
  ["talsa"] = "Irresistible Calling",
  ["talsa"] = "Evil Intentions",
  ["talsa"] = "Cosmic Calling",
  ["hades"] = "Golden Obol",
  ["autumn"] = "Map of the Woods",
  ["citadel"] = "A Majestic Orb",
  ["petstore"] = "Golden Pet Collar",
  ["undefined"] = "Sir Lauren's Despair",
  ["arena"] = "&lt;-L-&gt; Lifetime Pass to the Gladiators Arena &lt;-L-&gt;",
  ["glamdursil"] = "copy of the ((Map of the World))",
  ["glamdursil"] = "cheat code",
  ["fortress"] = "Goblin Warplans",
  ["goldrush"] = "train ticket",
  ["aylor"] = "garbage can",
  ["knossos"] = "Passport to Knossos.",
  ["helegear"] = "Icy Portal of Gvozd",
  ["cards"] = "[House] of Cards",
  ["cards"] = "[Trump] of Benedict",
  ["reme"] = "two-way mirror",
  ["imperial"] = "dark crystal",
  ["insan"] = "Cedria",
  ["losttime"] = "Time Capsule",
  ["kearvek"] = "Dark Orb of the Vampires",
  ["fields"] = "A Trip To The Killing Fields",
  ["labyrinth"] = "wooden yoke",
  ["labyrinth"] = "Yelsem's (:*Freedom*:)",
  ["legend"] = "apple press",
  ["agroth"] = "A Chip of Willow Bark",
  ["agroth"] = "A Cautionary Tale of the Marsh",
  ["masq"] = "A Masquerade Mask",
  ["dunoir"] = "horn of the ANCESTORS",
  ["nanjiki"] = "Magic Banana",
  ["oradrin"] = "-=Oradrin's Call=-",
  ["partroxis"] = "The Partroxis",
  ["pompeii"] = "black volcanic glass",
  ["undefined"] = "Gold Plated Silhouette brooch",
  ["undefined"] = "Share Ownership of Hotele Royale",
  ["qong"] = "Hot Wok of Qong",
  ["deneria"] = "mirror showing Deneria's past",
  ["firebird"] = "Crystal ball",
  ["ruins"] = "A Heliodor Shard",
  ["sagewood"] = "Bell Tent",
  ["sanguine"] = "Strange glowing disc",
  ["sohtwo"] = "demon school handbook",
  ["sohtwo"] = "A Jewelry Box",
  ["undefined"] = "Sea King's Portal",
  ["snuckles"] = "Enchanted Spellbook",
  ["lemdagor"] = "Storm Ship in a Bottle",
  ["takeda"] = "Tiger of Kai",
  ["tirna"] = "ring of pale mushrooms",
  ["illoria"] = "Sigil of Illoria",
  ["tol"] = "starburst",
  ["gwillim"] = "Crown of Swords",
  ["gwillim"] = "Passage to Gwillimberry",
  ["bonds"] = "badge of the Draconic Intelligence Service",
  ["verdure"] = "holy well",
  ["wizards"] = "Honeycomb",
  ["omentor"] = "Aethelswyth's Visions",
  ["wooble"] = "Cracked Wooble-nut",
  ["xylmos"] = "An Envelope of Xyl",
  ["ygg"] = "A Small Crystal Tree",
  ["yurgach"] = "pendant in the likeness of Kali",
  ["adaldar"] = "Temporary Truce",
  ["blackrose"] = "A Black Rose",
  ["dread"] = "Cursed Note",
  ["citadel"] = "book entitled 'My Citadel'",
  ["undefined"] = "One-Day Pass to the Gladiators Arena",
  ["paradise"] = "golem's ear",
  ["qong"] = "low quality wok",
  ["nenukon"] = "-*)Monuhi's Legacy(*-",
  ["sanctity"] = "A Bloody Griffin Wing",
  ["temple"] = "Yin-Yang Pendant",
}</script>
				<eventHandlerList />
			</Script>
			<Script isActive="yes" isFolder="no">
				<name>cp hunt</name>
				<packageName></packageName>
				<script>cp_targets = cp_targets or {}


function get_cp_tgt_info(idx)
  if #cp_targets &lt; idx then
    return nil
  else
    local _curTarget = cp_targets[idx]
    local cleanArea = _curTarget["area"]
    if aard.areaInfo[cleanArea] ~= nil then
      cleanArea = aard.areaInfo[cleanArea].zone
    else
      cleanArea = cleanArea:gsub("The ", ""):split(' ')[1]:gsub("'", ""):gsub('"', "")
    end
    return { _curTarget["mob"], cleanArea }
  end
end</script>
				<eventHandlerList />
			</Script>
		</ScriptGroup>
	</ScriptPackage>
	<KeyPackage>
		<KeyGroup isActive="yes" isFolder="yes">
			<name>casraf</name>
			<packageName></packageName>
			<script></script>
			<command></command>
			<keyCode>33554431</keyCode>
			<keyModifier>0</keyModifier>
			<Key isActive="yes" isFolder="no">
				<name>+ spellup / attack spell</name>
				<packageName></packageName>
				<script>if aard.state == 8 then
	send(aard.config["attack1"],true)--in combat
else	
	send(aard.config["spellup"],true)--out of combat
end</script>
				<command></command>
				<keyCode>43</keyCode>
				<keyModifier>536870912</keyModifier>
			</Key>
			<Key isActive="yes" isFolder="no">
				<name>1 inv</name>
				<packageName></packageName>
				<script>send("inv")</script>
				<command></command>
				<keyCode>49</keyCode>
				<keyModifier>536870912</keyModifier>
			</Key>
			<Key isActive="yes" isFolder="no">
				<name>shift + 1 eq</name>
				<packageName></packageName>
				<script>send("eq")</script>
				<command></command>
				<keyCode>49</keyCode>
				<keyModifier>570425344</keyModifier>
			</Key>
			<Key isActive="yes" isFolder="no">
				<name>alt + 1 pbag</name>
				<packageName></packageName>
				<script>local bag = aard.config["pbag"]
send("examine " .. bag)</script>
				<command></command>
				<keyCode>49</keyCode>
				<keyModifier>671088640</keyModifier>
			</Key>
			<Key isActive="yes" isFolder="no">
				<name>shift + alt + 1 bag</name>
				<packageName></packageName>
				<script>local bag = aard.config["bag"]
send("examine " .. bag)</script>
				<command></command>
				<keyCode>49</keyCode>
				<keyModifier>704643072</keyModifier>
			</Key>
			<Key isActive="yes" isFolder="no">
				<name>. scan / debuff</name>
				<packageName></packageName>
				<script>if aard.state == 8 then
  --in combat, debuff
	send(aard.config["debuff1"],true)
  send(aard.config["debuff2"],true)
else	
  --out of combat, scan
	send("scan",true)
end</script>
				<command></command>
				<keyCode>46</keyCode>
				<keyModifier>536870912</keyModifier>
			</Key>
			<Key isActive="yes" isFolder="no">
				<name>5 Look &amp; Exits</name>
				<packageName></packageName>
				<script></script>
				<command>l;ex</command>
				<keyCode>53</keyCode>
				<keyModifier>536870912</keyModifier>
			</Key>
		</KeyGroup>
	</KeyPackage>
	<VariablePackage>
		<HiddenVariables />
		<Variable>
			<name>target_n</name>
			<keyType>4</keyType>
			<value>1</value>
			<valueType>3</valueType>
		</Variable>
		<Variable>
			<name>goal</name>
			<keyType>4</keyType>
			<value> Tairayden</value>
			<valueType>4</valueType>
		</Variable>
		<Variable>
			<name>target</name>
			<keyType>4</keyType>
			<value>daisensei</value>
			<valueType>4</valueType>
		</Variable>
	</VariablePackage>
</MudletPackage>
