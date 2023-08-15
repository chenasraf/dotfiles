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
				<script></script>
				<triggerType>0</triggerType>
				<conditonLineDelta>0</conditonLineDelta>
				<mStayOpen>0</mStayOpen>
				<mCommand>ca invis</mCommand>
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
				<mCommand>cp ch</mCommand>
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
				<name>precall</name>
				<script>send(aard.config["port"])</script>
				<command></command>
				<packageName></packageName>
				<regex>^(prc)|(precall)</regex>
			</Alias>
			<Alias isActive="yes" isFolder="no">
				<name>conjure elemental</name>
				<script>local stone = matches[3]
send("hold " .. stone .. "; cast 'conjur elemental'; hold " ..aard.config["held"])</script>
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
				<script>send(aard.config["port"] .. '; w; gulp milk; gulp milk; fill can milk;')</script>
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
  end
else
  send("echo Target is: " .. get_tgt(), false)
end</script>
					<command></command>
					<packageName></packageName>
					<regex>^tgt\s?([a-zA-Z'" -]+)?</regex>
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

send("cast word; rt " .. area .. "; hunt " .. get_tgt() .. "; where " .. get_tgt())</script>
					<command></command>
					<packageName></packageName>
					<regex>chase ([\w\d]+) (.+)</regex>
				</Alias>
			</AliasGroup>
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
					<name>Primary Spell 🎯️</name>
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
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
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
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>🥶️ Cone of Cold</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'cone of cold'</commandButtonDown>
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
					<name>🤢️ Acid Blast</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'acid blast'</commandButtonDown>
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
				<Action isActive="yes" isFolder="no" isPushButton="no" isFlatButton="no" useCustomLayout="no">
					<name>⚡️ Lightning Bolt</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>ca 'lightning bolt'</commandButtonDown>
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
					<name>Quest</name>
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
					<name>Quest Info</name>
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
					<name>Quest Request</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>crecall; quest request</commandButtonDown>
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
					<name>Quest Complete</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>crecall; quest complete</commandButtonDown>
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
					<name>Campaign</name>
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
					<name>Campaign Check</name>
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
					<name>Campaign Info</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>campaign info</commandButtonDown>
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
					<name>Campaign Request</name>
					<packageName></packageName>
					<script></script>
					<css></css>
					<commandButtonUp></commandButtonUp>
					<commandButtonDown>crecall; campaign request</commandButtonDown>
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
				<name>alt + 1 bag</name>
				<packageName></packageName>
				<script>local bag = aard.config["bag"] or aard.config["pbag"]
send("examine " .. bag)</script>
				<command></command>
				<keyCode>49</keyCode>
				<keyModifier>671088640</keyModifier>
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
			<valueType>4</valueType>
		</Variable>
		<Variable>
			<name>goal</name>
			<keyType>4</keyType>
			<value>obal</value>
			<valueType>4</valueType>
		</Variable>
		<Variable>
			<name>target</name>
			<keyType>4</keyType>
			<value>hair stylist</value>
			<valueType>4</valueType>
		</Variable>
	</VariablePackage>
</MudletPackage>
