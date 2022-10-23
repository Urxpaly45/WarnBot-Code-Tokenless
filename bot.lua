local discordia = require('discordia')
local client = discordia.Client()
local prefix = 'w!'
local testing_prefix = "t!"
local token = "DISCORD_TOKEN_HERE"
local version = "0.5"

discordia.extensions() -- load all helpful extensions

local red = discordia.Color.fromRGB(255,0,0).value
local orange = discordia.Color.fromRGB(255,165,0).value
local yellow = discordia.Color.fromRGB(255,255,0).value
local green = discordia.Color.fromRGB(0, 255, 0).value
local blue = discordia.Color.fromRGB(0, 0, 255).value
local purple = discordia.Color.fromRGB(128, 0, 128).value
local pink = discordia.Color.fromRGB(255, 0, 255).value
local black = discordia.Color.fromRGB(1, 1, 1).value
local white = discordia.Color.fromRGB(254, 254, 254).value

local dev_ids = {"439198909009756169"}
local tester_ids = {"439198909009756169", "462770046113153058", "703050638984085554", "492402970567376907", "626879624252489748"}


function getTab(name)
	local userWarns = io.open("./"..name..".txt")
	local int
	local count
	local i = 0
	local cont = {}
	local cont2 = {}
	for line in userWarns:lines() do
		i = i + 1
		local args = tostring(line):split(" ")
		for _, text in ipairs(args) do
			table.insert(cont2, text)
		end
		table.insert(cont, cont2)
		cont2 = {}
	end
	userWarns:close()
	return cont
end

function getInt(table, id)
  for _, tab in ipairs(table) do
    if tonumber(tab[1]) == tonumber(id) then
      return tab[2]
    end
  end
end

function writeTable(tabel, id, pos)
  local preEntered = false
    
    for _, tab in ipairs(tabel) do
      if tonumber(tab[1]) == tonumber(id) then
        preEntered = true
        if pos == true then
          tab[2] = tab[2] + 1
        elseif pos == false then
          tab[2] = tab[2] - 1
        elseif tonumber(pos) then
          tab[2] = pos
        end
      end
    end
    
    if preEntered == false then
      if pos ~= true and pos ~= false then
        local REEEEtab = {id, pos}
        table.insert(tabel, REEEEtab)
      else
        local REEEEtab = {id, 1}
        table.insert(tabel, REEEEtab)
      end
    end
     
    return tabel
end

function writeFile(name, table)
  local userWarns = io.open("./"..name..".txt", "w+")
  io.output(userWarns)
  for _, tab in ipairs(table) do
    for i, subsection in ipairs(tab) do
      if i == 2 then
        io.write(tostring(subsection).."\n")
      else
        io.write(tostring(subsection).. " ")
      end
    end
  end
  userWarns:close()
end

function wait(seconds)
  local start = os.time()
  repeat until os.time() > start + seconds
end

function updateStatus()
  while true do
    wait(12)
    
    local guildCount = client.guilds[1]
    client:setGame("Still in development! V"..version .. " in " .. guildCount .. " servers")
  end
end

client:on("ready", function() -- bot is ready
	print("Logged in as " .. client.user.username)
  updateStatus()
end)

function ping(message)
  message:reply("Pong! \n \n *more detailed info coming soon*")
end


function invite(message)
  message:reply{
    embed = {
				title = "Invite Links",
				description = "Useful Invites:",
				fields = { -- array of fields
					{
            name = "Invite this bot!",
						value = "https://invite.warnbot.net",
						inline = true
					},
					{
						name = "Invite to our Support Server!",
						value = "https://support.warnbot.net",
						inline = true
					}
				},
				footer = {
					text = "WarnBot V"..version
				},
				color = green -- hex color code
			}
  }
end

function talk(message, args, enums)
  if message.member:hasPermission(enums.permission.manageMessages) then
    table.remove(args, 1)
    message:reply(table.concat(args, " ")) 
    message:delete()
  else
    message:reply("**Error:** you don't have permission to use this command!")
    
  end
end

function help(message)
  message:reply{
    embed = {
				title = "Help",
				description = "",
				fields = { -- array of fields
					{
            name = "Info:",
						value = " \n WarnBot website: [https://warnbot.net](https://warnbot.net \"Our Website!\") \n  Invite WarnBot: [https://invite.warnbot.net](https://invite.warnbot.net \"Invite me to Your Server!\") \n __Prefix__: **w!**",
						inline = false
					},
					{
						name = "General Commands:",
						value = "*invite*: Gets the links to invite the bot and to the support server \n \n *updates*: See the bot's update log \n \n *vote*: Vote for the bot on verified bot lists \n \n *disc-tips*: Useful Discord tips \n \n *ping*: Pong! \n \n *cool-servers*: See some servers that WarnBot suggests \n \n *suggest*: Get the link to make a suggestion \n \n",
						inline = false
					},
          {
            name = "Moderation Commands:",
            value = "*clear <Number>*: Clear specified number of previous messages. (Max 100) \n \n *mute <@user> (Reason)*: Mute mentioned member for listed reason \n \n *unmute <@user>*: Unmute mentioned user \n \n *warn <@user> (Reason)*: Warn mentioned member for listed reason \n \n *kick <@user> (Reason)*: Kick mentioned member for listed reason \n \n *ban <@user> (Reason)*: Ban mentioned member for listed reason \n \n *announce <announcement>*: Announce something in the server you want to announce it in \n \n *rules <rules>*: Make the rules in the same server you use the command in \n \n *talk <text>*: Talk as WarnBot",
            inline = false
          }
				},
				footer = {
					text = "WarnBot V"..version
				},
				color = green -- hex color code
			}
  }
end

function updates(message)
  message:reply{
    embed = {
				title = "Update Log:",
				description = "**0.1:** Basic Common Moderation Commands \n \n **0.2:** Announce, Rules, & Update Log Commands \n \n **0.3:** Vote, Tips & Ping Commands added, fixed Clear command to delete an accurate number of messages \n \n **0.4:** Talk, Suggest, Cool Servers Commands added, Updated some error messages, fixed Ping command \n \n **0.5:** WarnBot [website](https://warnbot.net) released, added more tips to disc-tips command",
				footer = {
					text = "WarnBot V"..version
				},
				color = white -- hex color code
			}
  }
end

function vote(message)
  message:reply{
    embed = {
				title = "Vote Links",
				description = "`Top.gg`: https://top.gg/bot/635977560492081162 \n `DiscordBotList.com`: https://discordbotlist.com/bots/warnbot \n `BotsforDiscord.com`: https://botsfordiscord.com/bot/635977560492081162 \n `botrix.tk`: https://botrix.tk/bots/635977560492081162 \n (Please vote, it would greatly help)",
				footer = {
					text = "WarnBot V"..version
				},
				color = blue -- hex color code
			}
  }
end

function discTips(message)
  message:reply{
    embed = {
				title = "Here are some tips!",
				description = "`1)` **Want to mention someone who isn't in this group or has been banned?** \n Try doing this! \"<@{Put id of the user here}>\" \n \n `2)` **Want to find the id of a user?** \n In settings go to \"Appearance\" (under \"App Settings\") and toggle Developer Mode on. Once you have done so, find the user you want to get the id of, and right-click their card. \n \n `3)` **How do I \"close\" or \"open\" my DMs?** \n Open settings, and go to \"Privacy & Safety\". Toggle the first switch. If you want to \"close\" them, toggle it so it turns gray, and press yes. If you want to \"open\" them, toggle it so it turns blue, and press yes. \n \n `4)` **Want to change to light mode or to dark mode?** \n Open settings, and go to \"Appearance\". There, you should see something that says \"Theme\". Right under that, choose the mode you want, and click on it once. It may take a second for it to switch. \n \n `5)` **Want discord to stop changing your \":)\"s to :slight_smile:s?** \n Open settings. Go to “Text & Images”. Scroll down until you see the :slight_smile: emoji. Toggle the switch to the right of it so it turns gray. If you want to re-enable it, toggle it again so it turns blue.",
				footer = {
					text = "WarnBot V"..version
				},
				color = blue -- hex color code
			}
  }
end

function coolServers(message)
  local dm = message.guild.members:get(message.member.id)
  if(not dm) then
    message.channel:send("**Error:** cannot send DM to user: <@".. message.member.id .. ">")
  else 
    dm:send{
      embed = {
				title = "Here are some cool servers I suggest joining!",
				description = "**WarnBot Support:** https://support.warnbot.net/ \n > Have questions? Want help with commands? Join our server! \n \n That’s all for now! Check back later!",
				footer = {
					text = "WarnBot V"..version
				},
				color = green -- hex color code
			}
    }
    message.channel:send("Message sent; check your DMs!")
  end
end

function suggest(message)
  message:reply{
    embed = {
				title = "Suggest",
				description = "If you would like to make a suggestion, please go to https://suggestions.warnbot.net/",
				footer = {
					text = "WarnBot V"..version
				},
				color = black -- hex color code
			}
  }
end

function equation(message, args, enums)
  local num1 = args[3]
  local num2 = args[4]
  local answer
  if not tonumber(num1) or not tonumber(num2) then
    message:reply("**Error:** Incorrect format: `w!equation <mult/div/sub/add> <num1> <num2>`")
  else
    
    num1 = tonumber(num1)
    num2 = tonumber(num2)
    
    if args[2] == "mult" then
      answer = (num1 * num2)
      message:reply("**Result:** `" .. answer .. "`")
    elseif args[2] == "div" then
      answer = (num1 / num2)
      message:reply("**Result:** `" .. answer .. "`")
    elseif args[2] == "sub" then
      answer = (num1 - num2)
      message:reply("**Result:** `" .. answer .. "`")
    elseif args[2] == "add" then
      answer = (num1 + num2)
      message:reply("**Result:** `" .. answer .. "`")
    else
      message:reply("**Error:** Incorrect format: `w!equation <mult/div/sub/add> <num1> <num2>`")
    end
    
  end
end

function clear(message, args, enums)
  local num = tonumber(args[2])
  local innum = num
  local nums = {}
  local err
  
  if num == nil then
    local err = "**Error:** input not a number."
    
  elseif num > 1000 or num < 1 then
    err = "**Error:** input must be a number greater than 0 and less than or equal to 1000."
    
  else
    err = "success"
    if num > 100 then
      while num > 0 do
        if num > 100 then
          num = num - 100
          table.insert(nums, 100)
        else
          table.insert(nums, num)
          num = 0
        end
      end
    else
      nums = {num}
    end
  end
  
  if message.member:hasPermission(enums.permission.manageMessages) then
    
  else
    
    err = "**Error:** you don't have permission to use this command!"
  end
  if err == "success" then
    
    message:delete()
    
    for _,toDel in ipairs(nums) do
      local messageids = {}
      for messages in message.channel:getMessages(toDel):iter() do
        table.insert(messageids, messages) 
      end
      message.channel:bulkDelete(messageids)
    end
    local reply = message:reply("**"..innum.."** messages successfully deleted!")
    wait(1.25)
    reply:delete()
  else 
    message:reply(err)
  end
end

function mute(message, args, enums)
  if message.member:hasPermission("kickMembers") then -- If user using cmmnd has perm to use it
    
    local role
    local dm
    local table = getTab("muteRoles")
    pcall(function() role = tostring(getInt(table, message.guild.id)) dm = message.guild.members:get(message.mentionedUsers.first.id) end)
    
    
    local member = message.mentionedUsers.first
    member = message.guild:getMember(member)
    
    
    if not role then
      message:reply("**Error:** there is no Muted role in this server yet. I am currently unable to configure one, so I reccommend getting Dyno (https://dyno.gg) and running the `?mute` command on someone once with that. \n \n If you do have a muted role, and I didn't see it, do `w!muteRole @role`")
    else
      member:addRole(role)
      
      local arg3Exists,idc = pcall(function() local ifnil = "something but is ".. args[3] .. " nill?" end)
      if arg3Exists then
        local argCount = 3
        while args[argCount] do
          if argCount ~= 3 then
            args[3] = tostring(args[3]) .. " " .. args[argCount]
          end
          argCount = argCount + 1
        end
      else 
        args[3] = "No reason provided"
      end
      if(not dm) then
        message.channel:send("**Error:** cannot send DM to user: <@".. message.mentionedUsers.first.id .. "> \n \n User was still muted!")
      else 
        message.channel:send("<@" .. message.mentionedUsers.first.id .. "> has been Muted!")
        dm:send{
          embed = {
            title = "Mute",
            description = "**Server:** " .. message.guild.name .. "\n **Moderator:** <@" .. message.author.id .. "> \n **Message:** ```" .. args[3] .. "```",
            footer = {
              text = "WarnBot V"..version
            },
            color = blue -- hex color code
          }
        }
      end
    end
    
  else
    
    message:reply("**Error:** you don't have permission to use this command!")
    
  end
end

function unmute(message, args, enums)
  if message.member:hasPermission("kickMembers") then -- If user using cmmnd has perm to use it
    
    local role
    local table = getTab("muteRoles")
    pcall(function() role = tostring(getInt(table, message.guild.id)) end)
    
    
    local member = message.mentionedUsers.first
    member = message.guild:getMember(member)
    
    
    if not role then
      message:reply("**Error:** there is no Muted role in this server yet. I am currently unable to configure one, so I reccommend getting Dyno (https://dyno.gg) and running the `?mute` command on someone once with that. \n \n If you do have a muted role, and I didn't see it, do `w!muteRole @role`")
    else
      member:removeRole(role)
      message:reply("<@"..member.id .. "> has been unmuted!")
      
    end
    
  else
    
    message:reply("**Error:** you don't have permission to use this command!")
    
  end
end

function muteRole(message, args, enums)
  local newVal = ""
  local table = getTab("muteRoles")
  newVal = message.mentionedRoles.first.id
  if newVal ~= "" then
    
    table = writeTable(table, message.guild.id, newVal)
    writeFile("muteRoles", table)
    message:reply("<@&" .. newVal .. "> is the new Mute role")
  else
    message:reply("**Error:** you must mention a valid role")
  end
end

function warn(message, args, enums)
  if message.member:hasPermission("kickMembers") then -- If user using cmmnd has perm to use it
    
    local arg3Exists,idc = pcall(function() local ifnil = "something but is ".. args[3] .. " nill?" end)
    if arg3Exists then
      local argCount = 3
      while args[argCount] do
        if argCount ~= 3 then
          args[3] = tostring(args[3]) .. " " .. args[argCount]
        end
        argCount = argCount + 1
      end
    else 
      message:reply("**Error:** No Reason Provided")
      
    end
    
    if arg3Exists then
      local table = getTab("userWarns")
      table = writeTable(table, message.mentionedUsers.first.id, true)
      local warns = getInt(table, message.mentionedUsers.first.id)
      if warns == nil then
        table = writeTable(table, message.mentionedUsers.first.id, 1)
        warns = 1
      end
      writeFile("userWarns", table)
      local dm = message.guild.members:get(message.mentionedUsers.first.id)
      if(not dm) then
        message.channel:send("**Error:** cannot send DM to user: ".. message.mentionedUsers.first)
      else 
        dm:send{
          embed = {
            title = "Warn",
            description = "**Server:** " .. message.guild.name .. "\n **Moderator:** <@" .. message.author.id .. "> \n **Message:** ```" .. args[3] .. "```",
            footer = {
              text = "WarnBot V"..version
            },
            color = yellow -- hex color code
          }
        }
        message.channel:send("<@"..message.mentionedUsers.first.id .. "> now has " .. tostring(warns) .. " warns!")
      end
    end
  else
    message:reply("**Error:** you don't have permission to use this command!")
  end
end

function kick(message, args, enums)
  if message.member:hasPermission("kickMembers") then -- If user using cmmnd has perm to use it
    local kickMember = message.mentionedUsers.first
    
    local dm = message.guild.members:get(message.mentionedUsers.first.id)
    local argCount = 3
    while args[argCount] do
      if argCount ~= 3 then
        args[3] = tostring(args[3]) .. " " .. args[argCount]
      end
      argCount = argCount + 1
    end
    if(not dm) then
      message.channel:send("**Error:** cannot send DM to user: ".. message.mentionedUsers.first)
    else 
      dm:send{
        embed = {
          title = "Kick",
          description = "**Server:** " .. message.guild.name .. "\n **Moderator:** <@" .. message.author.id .. "> \n **Message:** ```" .. args[3] .. "```",
          footer = {
            text = "WarnBot V"..version
          },
          color = yellow -- hex color code
        }
      }
      message.guild:kickUser(kickMember)
      message.channel:send("<@"..message.mentionedUsers.first.id .. "> has been kicked!")
    end
    
  else
    message:reply("**Error:** you don't have permission to use this command!")
  end
end

function ban(message, args, enums)
  if message.member:hasPermission("banMembers") then -- If user using cmmnd has perm to use it
    local banMember = message.mentionedUsers.first
    
    local dm = message.guild.members:get(message.mentionedUsers.first.id)
    local argCount = 3
    while args[argCount] do
      if argCount ~= 3 then
        args[3] = tostring(args[3]) .. " " .. args[argCount]
      end
      argCount = argCount + 1
    end
    if(not dm) then
      message.channel:send("**Error:** cannot send DM to user: ".. message.mentionedUsers.first)
    else 
      dm:send{
        embed = {
          title = "Ban",
          description = "**Server:** " .. message.guild.name .. "\n **Moderator:** <@" .. message.author.id .. "> \n **Message:** ```" .. args[3] .. "```",
          footer = {
            text = "WarnBot V"..version
          },
          color = red -- hex color code
        }
      }
      message.guild:banUser(banMember)
      message.channel:send("<@"..message.mentionedUsers.first.id .. "> has been banned!")
    end
    
  else
    message:reply("**Error:** you don't have permission to use this command!")
  end
end

function unban(message, args, enums)
  if message.member:hasPermission("banMembers") then -- Uf user using cmmnd has perm to use it
    local unbanMember = message.mentionedUsers.first
    
    local dm = message.guild.members:get(message.mentionedUsers.first.id)
    local argCount = 3
    while args[argCount] do
      if argCount ~= 3 then
        args[3] = tostring(args[3]) .. " " .. args[argCount]
      end
      argCount = argCount + 1
    end
    if(not dm) then
      message.channel:send("**Error:** cannot send DM to user: ".. message.mentionedUsers.first)
    else 
      dm:send{
        embed = {
          title = "Ban",
          description = "**Server:** " .. message.guild.name .. "\n **Moderator:** <@" .. message.author.id .. "> \n **Message:** ```" .. args[3] .. "```",
          footer = {
            text = "WarnBot V"..version
          },
          color = red -- hex color code
        }
      }
      message.guild:unbanUser(unbanMember)
      message.channel:send("<@"..message.mentionedUsers.first.id .. "> has been kicked!")
    end
    
  else
    message:reply("**Error:** you don't have permission to use this command!")
  end
end

function announce(message, args, enums)
  if message.member:hasPermission("manageMessages") then -- If user using cmmnd has perm to use it
    local argCount = 2
    while args[argCount] do
      if argCount ~= 2 then
        args[2] = tostring(args[2]) .. " " .. args[argCount]
      end
      argCount = argCount + 1
    end

      message:reply{
        embed = {
          title = "Announcement from ".. client:getUser(tostring(message.author.id)).tag,
          description = args[2],
          footer = {
            text = "WarnBot V"..version
          },
          color = green -- hex color code
        }
      }
      message:delete()
  else
    message:reply("**Error:** you don't have permission to use this command!")
  end
end

function rules(message, args, enums)
  if message.member:hasPermission("administrator") then -- If user using cmmnd has perm to use it
    local argCount = 2
    while args[argCount] do
      if argCount ~= 2 then
        args[2] = tostring(args[2]) .. " " .. args[argCount]
      end
      argCount = argCount + 1
    end
      message.channel:send{
        embed = {
          title = "Rules",
          description = args[2],
          footer = {
            text = "WarnBot V"..version
          },
          color = yellow -- hex color code
        }
      }
      message:delete()
  else
    message:reply("**Error:** you don't have permission to use this command!")
  end
end

function testing(message, args, enums)
  
end

function stop(message, args, enums)
  for _,id in ipairs(dev_ids) do
    print(id)
    print(message.author.id)
    if tostring(id) == tostring(message.author.id) then 
      print(1)
      message:reply("Bot Stopped")
      client:setStatus("invisible")
      client:stop()
    end
  end
end

client:on('messageCreate', function(message) --When a message is sent
    
  local content = message.content
  local args = content:split(" ") -- split all arguments into a table
  local prefix_args = content:split("!")
  local member = message.member
  local memberid = message.author.id
  local enums = discordia.enums
  
  if prefix_args[1] == "w" then -- if "w" is before "!" to make prefix
    
    if args[1] == prefix..'ping' then -- If it's w!ping -- GENERAL
      print('Ping')
      local succ, err = pcall(ping, message)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix..'help' or args[1] == prefix..'commands' then -- If it's w!help
      print('Help')
      local succ, err = pcall(help, message)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."invite" then -- If it's w!invite
      print("Invite")
      local succ, err = pcall(invite, message)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."talk" then -- If it's w!talk
      print("Talk")
      local succ, err = pcall(talk, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."updates" then -- If it's w!updates
      print("Updates")
      local succ, err = pcall(updates, message)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."vote" then -- If it's w!vote
      print("Vote")
      local succ, err = pcall(vote, message)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."disc-tips" then -- If it's w!disc-tips
      print("Disc-Tips")
      local succ, err = pcall(discTips, message)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."cool-servers" then -- If it's w!cool-servers
      print("Cool-Servers")
      local succ, err = pcall(coolServers, message)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."suggest" then -- If it's w!suggest
      print("Suggest")
      local succ, err = pcall(suggest, message)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."equation" then -- If it's w!equation
      print("Equation")
      local succ, err = pcall(equation, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."clear" then -- If it's w!clear -- MODERATION
      print("Clear")
      local succ, err = pcall(clear, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."mute" then -- If it's w!mute
      print("Mute")
      local succ, err = pcall(mute, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."muteRole" then -- If it's w!mute
      print("MuteRole")
      local succ, err = pcall(muteRole, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."unmute" then -- If it's w!unmute
      print("Unmute")
      local succ, err = pcall(unmute, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."warn" then -- If it's w!warn
      print("Warn")
      local succ, err = pcall(warn, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."kick" then -- If it's w!kick 
      print("Kick")
      local succ, err = pcall(kick, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."ban" then -- If it's w!ban
      print("Ban")
      local succ, err = pcall(ban, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."unban" then -- If it's w!unban
      print("Unban")
      local succ, err = pcall(unban, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."announce" then -- If it's w!announce
      print("Announce")
      local succ, err = pcall(announce, message, args, enums)
      if succ == false then
        print(err)
      end
      
    elseif args[1] == prefix.."rules" then -- If it's w!rules
      print("Rules")
      pcall(rules, message, args, enums)
    end
    
  elseif prefix_args[1] == "t" then -- Testing Commands
    
    if args[1] == testing_prefix.."testing" then -- If it's t!testing
      print("Testing")
      pcall(testing, message, args, enums)
      
    elseif args[1] == testing_prefix.."stop" then
      print("STOP")
      local succ, err = pcall(stop, message, args, enums)
      if succ == false then
        print(err)
      end
    end
  end
end)

client:run('Bot '..token)
